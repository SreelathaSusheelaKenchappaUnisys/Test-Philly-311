/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public with sharing class FeedbackMock {
        public static Feedback SavedFeedback() { return SavedFeedback('summary', 'description'); }
        
        public static Feedback SavedFeedback(string summary, string description) {
       
                Feedback feeb = new Feedback(summary, description);
                feeb.save();
                
                return feeb;
        }
        
        public static Feedback_Config__c SavedConfig(string aName){
        
                Feedback_Config__c config = new Feedback_Config__c(
                    name = aName,
                    post_uri__c = 'https://xcg.secure.force.com/apex/Feedback',
                    use_post_uri__c = true,
                    product_category__c = 'Testing'
                );
                
                insert config;
                
                return config;
        }
        
        public static Contact SavedContact(string seed) {
                Contact aContact = new Contact(
                    lastName = 'Mock',
                    firstname = seed + '-Contact',
                    email = seed + 'MockContact@feedbacktest.com'
                );
                
                insert aContact;
                
                return aContact;
        }
        
        public static Contact SavedContactWithEmail(string anEmail) {
       
                Contact aContact = new Contact(
                    lastName = 'McLast',
                    firstName = 'Test',
                    email = anEmail
                );
                
                insert aContact;
                return aContact;
        }
        
        public static User SavedStandardUser() { return SavedStandardUser('test'); }
        
        public static User SavedStandardUser(string seed) {
        
                Profile aProfile = [ select id from Profile where name = 'standard user' limit 1];
                
                User auser = new User(
                    username = seed + '@feedbacktest.com',
                    email = seed + '@feedbacktest.com',
                    lastName = 'Feedback',
                    firstName = seed,
                    alias = seed,
                    timeZoneSidKey = 'America/New_York',
                    localeSidKey = 'en_US',
                    profileid = aProfile.id,
                    emailEncodingKey = 'UTF-8',
                    languageLocaleKey = 'en_US'
                );
                
                insert aUser;
                
                return aUser;
        }
        
}