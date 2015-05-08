public without sharing class FeedbackComponentController {
        public FeedbackComponentController() {}
        
        public Feedback_Config__c getFeedbackConfig() {
                return config == null ? (config = Feedback_Config__c.getInstance(settingName)) : config; 
        }
        
        public string getUri() {
                return config.Post_URI__c;
        }   
            
        public string getUrlParameters() {
                User aUser = [ select name, email from User where id = :UserInfo.getUserId() ];
                Organization anOrg = [ select id, name from Organization limit 1 ];
        
                list<string> stringList = new list<string>();
                
                stringList.add('userName=' + EncodingUtil.urlEncode(aUser.name, 'utf-8'));
                stringList.add('userEmail=' + EncodingUtil.urlEncode(aUser.email, 'utf-8'));
                stringList.add('orgId=' + EncodingUtil.urlEncode(anOrg.id, 'utf-8'));
                stringList.add('orgName=' + EncodingUtil.urlEncode(anOrg.name, 'utf-8'));
                stringList.add('config=' + EncodingUtil.urlEncode(Json.Serialize(getFeedbackConfig()), 'utf-8'));
                
                
                return String.Join(stringList, '&');
        }
         
        Feedback_Config__c config;
        public string settingName { get; set; }
}