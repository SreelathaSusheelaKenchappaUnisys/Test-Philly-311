/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@RestResource(urlMapping='/FeedbackBitBucket/*')
global without sharing class FeedbackBitBucket extends XedeObject {
        class Commmit {
                string authorEmail() {
                        integer lessThan = raw_author.indexOf('<');
                        integer greaterThan = raw_author.indexOf('>');
                        if (greaterThan > lessThan)
                                return raw_author.substring(lessThan + 1, greaterThan);
            
                return null;
                }
        
                string author;
                string branch;
                list<File> files;
                string message;
                string raw_author;
                string raw_node;
        }
    
        class File {
                string file;
                string type;
        }
        
        public class Push {
                list<Commmit> commits;
                map<string, string> repository;
                string canon_url;
                string user;
        }
        
        static String DoEither() {
                system.debug(RestContext.request);
                
                string encodedParam = RestContext.request.params.get('payload');
                
                FeedbackBitBucket anInstance = new FeedbackBitBucket();
                
                anInstance.handleUrlEncodedString(encodedParam);
                
                string aResponse = XedeUtil.Join(anInstance.feedbackNameList, ', ');
                system.debug(aResponse);
                return aResponse;
        }
        
        @HttpGet
        global static String DoGet() {
                return DoEither();
        }
      
        @HttpPost
        global static String DoPost() {
                return DoEither();
        }
        
        public FeedbackBitBucket() {}   
        
        public void handle(string aString) {
       
                if(String.IsBlank(aString))
                        return;
                    
                payload = aString;
                            
                system.debug(payload);
                
                Push aPush = (Push) Json.Deserialize(payload, Push.class);              
                
                string fbRegexPattern = '[fF][bB]-\\d+';
                Pattern p = Pattern.compile(fbRegexPattern);
                list<Task> taskList = new list<Task>();
                        
                for (Commmit each : aPush.commits) {
                        list<string> fbNames = new list<string>();
                    
                        Matcher m = p.matcher(each.message);
                        while(m.find())
                                fbNames.add(m.group());
                        
                        system.debug('   Commit message : ' + each.message);
                        system.debug('Includes FB items :' + fbNames);
                        
                        map<ID, Feedback__c> fbList = new map<ID, Feedback__c>([ select id from Feedback__c where name in :fbNames ]);
                        
                        string messageBody = String.Format('{0}{1}commits/{2}\n\n{3}\n\n{4}', new string[] {
                                aPush.canon_url,
                                aPush.repository.get('absolute_url'),
                                each.raw_node,
                                each.message.replaceAll(fbRegexPattern, '').trim(),
                                each.raw_author
                        });
                        
                        messageBody += '\n';
                        
                        for (File eachFile : each.files)
                                messageBody += '\n' + eachFile.type + ' ' + eachFile.file;
                        
                        for (ID eachId : fbList.keySet())               
                                taskList.add(new Task(
                                    whatId = eachId, 
                                    subject = 'Commit : ' + each.message.trim().abbreviate(50, 0),
                                    Status = 'Completed',
                                    Description = messageBody,
                                    ActivityDate = Date.Today(),
                                    OwnerId = ownerIdFromEmail(each.authorEmail()),
                                    WhoId = whoIdFromEmail(each.authorEmail())
                                    )
                                );
                        
                        feedbackNameList.addAll(fbNames);
                }
                
                insert taskList;
        }
        
        public void handleUrlEncodedString(string anEncodedString){
        
                handle(EncodingUtil.URLDecode(anEncodedString, 'utf-8'));
        }
        
        string ownerIdFromEmail(string anEmailAddress){
      
                system.debug('Searching for user with email address ' + anEmailAddress);
                string anId = UserInfo.getUserId();
                
                if(String.IsBlank(anEmailAddress))
                        return anId;
                
                list<User> aList = [ select id from User where isActive = true and userType in ('Standard','Guest') and email = :anEmailAddress ];
                if(aList.isEmpty() == false)
                        return aList[0].id;
                    
                return anId;
        }
        
        string whoIdFromEmail(string anEmailAddress){
        
                system.debug('Searching for contact with email address ' + anEmailAddress);
                string anId = null;
                
                if(String.IsNotBlank(anEmailAddress)) {
                        list<Contact> aList = [ select id from Contact where email = :anEmailAddress ];
                        if(aList.isEmpty() == false)
                                return aList[0].id;
                }
                    
                return anId;
        }   
        
        public set<string> feedbackNameList = new set<string>();
        public string payload { get; private set; } 
}