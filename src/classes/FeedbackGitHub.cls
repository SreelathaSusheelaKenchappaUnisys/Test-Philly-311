/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@RestResource(urlMapping='/FeedbackGitHub/*')
global with sharing class FeedbackGitHub extends XedeObject {
        class Person {
                string name;
                string email;       
        }
        
        class Commmit {
                string id;
                string message;
                string timestamp;
                string url;
                list<string> added;
                list<string> removed;
                list<string> modified;
                Person author;
        }
        
        public class Push {
                string before;
                string after;
                string ref;
                list<Commmit> commits;
        }
        
        static String DoEither() {
                string encodedParam = RestContext.request.params.get('payload');
                
                FeedbackGitHub anInstance = new FeedbackGitHub();
                
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
        
        public FeedbackGitHub() {}  
        
        public void handle(string aString){
        
                if (String.IsBlank(aString))
                        return;
                    
                payload = aString;
                            
                list<Note> noteList = new list<Note>();
                
                string fbRegexPattern = '[fF][bB]-\\d+';
                Pattern p = Pattern.compile(fbRegexPattern);
                
                Push aPush = (Push) Json.Deserialize(payload, Push.class);              
                
                for (Commmit each : aPush.commits) {
                        list<string> fbNames = new list<string>();
                        
                        Matcher m = p.matcher(each.message);
                        while (m.find())
                            fbNames.add(m.group());
                        
                        system.debug('   Commit message : ' + each.message);
                        system.debug('Includes FB items :' + fbNames);
                        
                        map<ID, Feedback__c> fbList = new map<ID, Feedback__c>([ select id from Feedback__c where name in :fbNames ]);
                        
                        string messageBody = String.Format('{0}\n\n{1}\n\n{2} <{3}>', new string[] {
                                each.url,
                                each.message.replaceAll(fbRegexPattern, '').trim(),
                                each.author.name,
                                each.author.email
                        });
                        
                        messageBody += '\n';
                        
                        for (string eachNew : each.added)
                                messageBody += '\n+ ' + eachNew;
                        
                        for (string eachMod : each.modified)
                                messageBody += '\nm ' + eachMod;
                        
                        for (string eachDel : each.removed)
                                messageBody += '\n- ' + eachDel;  
                        
                        for (ID eachId : fbList.keySet())
                                noteList.add(new Note(
                                    parentId = eachId, 
                                    title = each.message.replaceAll(fbRegexPattern, '').trim().abbreviate(30, 0), 
                                    body = messageBody
                                ));
                        
                        feedbackNameList.addAll(fbNames);
                }
                
                insert noteList;
        }
        
        public void handleUrlEncodedString(string anEncodedString){
        
                handle(EncodingUtil.URLDecode(anEncodedString, 'utf-8'));
        }   
        
        public set<string> feedbackNameList = new set<string>();
        public string payload { get; private set; } 
}