/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackEmailHandlerTest {

        static testMethod void emailWithTicket(){
        
                User aUser = FeedbackMock.SavedStandardUser();
                
                Feedback fb = new Feedback('test', 'description about test');
                fb.save();      
                
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = aUser.email;
                email.toAddresses = new string[] { 'anotheruser@xede.com' };
                email.subject = 'test subject for ' + fb.getName();
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                system.assertEquals(true, result.success);
                system.assertEquals(null, result.message);
                
                Task aTask = [ select id, subject, description, ownerId from Task where whatId = :fb.getId() limit 1 ];
                system.assertEquals(email.subject, aTask.subject);
                system.assertEquals(aUser.id, aTask.OwnerId, 'Task owner is not test user\'s');
                
                list<string> lines = aTask.description.split('\n');
                system.assert(lines[0].startsWith('Date: '));
                system.assert(lines[1].startsWith('From: '));
                system.assert(lines[2].startsWith('To: '));
                system.assert(lines[3].startsWith('Cc: '));
                system.assert(lines.size() > 5);
        }
        
        static testMethod void emailWithoutTicket(){
        
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = 'testuser@xede.com';
                email.toAddresses = new string[] { 'anotheruser@xede.com' };
                email.subject = 'no ticket here!';
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                system.assertEquals(true, result.success, result.message);
                system.assert(result.message.startsWith('Created new ticket, '));
                
                // now lets find the new feedback                
                string fbRegexPattern = '[fF][bB]-\\d+';
                Pattern p = Pattern.compile(fbRegexPattern);
                    
                Matcher m = p.matcher(result.message);
                
                list<string> fbNames = new list<string>();  
                
                while (m.find())
                        fbNames.add(m.group());
                
                system.assertEquals(false, fbNames.isEmpty(), 'missing feedback name in ' + result.message);
                Feedback__c newFb = [ select id, user_email__c from Feedback__c where name = :fbnames[0] limit 1 ];
                system.assertNotEquals(null, newFb);
                system.assertEquals(email.fromAddress, newFb.User_Email__c);
        }
        
        static testMethod void emailWithBadTicket(){
        
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = 'testuser@xede.com';
                email.toAddresses = new string[] { 'anotheruser@xede.com' };
                email.subject = 'Can you find fb-99999';
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                system.assertEquals(false, result.success, result.message);
        }
        
        static testMethod void emailFromStrangerToUserTest(){
        
                User aUser = FeedbackMock.SavedStandardUser();
                
                Feedback fb = new Feedback('test', 'description about test');
                fb.save();      
                
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = 'nobody@stranger.com';
                email.toAddresses = new string[] { aUser.Email };
                email.ccAddresses = null;       
                email.subject = 'test subject for ' + fb.getName();
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                
                Task aTask = [ select id, ownerId from Task where whatId = :fb.getId() limit 1 ];       
                system.assertEquals(aUser.id, aTask.OwnerId, 'Task owner is not test user\'s');
        }
        
        static testMethod void emailFromStrangerCcUserTest(){
        
                User aUser = FeedbackMock.SavedStandardUser();
                
                Feedback fb = new Feedback('test', 'description about test');
                fb.save();      
                
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = 'nobody@stranger.com';
                email.toAddresses = null;
                email.ccAddresses = new string[] { aUser.Email };
                email.subject = 'test subject for ' + fb.getName();
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                
                Task aTask = [ select id, ownerId from Task where whatId = :fb.getId() limit 1 ];       
                system.assertEquals(aUser.id, aTask.OwnerId, 'Task owner is not test user\'s');
        }
        
        static testMethod void emailFromContactToUserTest(){
        
                Contact aContact = FeedbackMock.SavedContact('');
                User aUser = FeedbackMock.SavedStandardUser();
                
                Feedback fb = FeedbackMock.SavedFeedback();
                
                Messaging.InboundEmail email = new Messaging.InboundEmail();
                email.fromAddress = aContact.Email;
                email.toAddresses = new string[] { aUser.Email };
                email.ccAddresses = null;       
                email.subject = 'test subject for ' + fb.getName();
                email.plainTextBody = 'a plain text body';
                email.headers = new Messaging.InboundEmail.Header[] {};
                
                Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
                
                FeedbackEmailHandler aHandler = new FeedbackEmailHandler();
                
                Messaging.InboundEmailResult result = aHandler.handleInboundEmail(email, envelope);
                
                Task aTask = [ select id, whoId from Task where whatId = :fb.getId() limit 1 ];     
                system.assertEquals(aContact.id, aTask.whoId, 'Task name is not the contact\'s');
        }
}