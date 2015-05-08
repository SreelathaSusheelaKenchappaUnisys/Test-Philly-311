/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackTest {
        static testMethod void testUpdateTrigger(){
        
                Feedback fb = new Feedback('', '');
                fb.setOrganizationId('aFakeId');
                fb.setOrganizationName('a fake name');
                
                fb.save();
                
                system.assertNotEquals(null, fb.getId());
                system.assertNotEquals(null, fb.getName());
                
                Feedback_Account_Org__c anFao = [ select id, org_id__c, org_name__c from Feedback_Account_Org__c where org_id__c = 'aFakeId' limit 1];
                system.assertEquals('aFakeId', anFao.org_id__c);
        }
    
        static testMethod void TestAssignmentStatus() {
                Feedback fb = new Feedback('', '');
                system.debug('creating a new, empty feedback - no feeditem expected');
                fb.save();
                
                fb = new Feedback(fb.getId());
                
                system.assertEquals('New', fb.getStatus());
                system.assertEquals(null, fb.getAssignedTo());
                system.assertEquals(UserInfo.GetOrganizationId(), fb.getOrganizationId());
                system.assertEquals(UserInfo.GetName(), fb.getUserName());
                system.assertNotEquals(null, fb.getUserEmail());
                system.assertEquals('', fb.getOrganizationName());
                
                fb.setAssignedTo(UserInfo.GetUserId());
                system.debug('I expect one feeditem for the new assignment');
                fb.save();
                
                fb = new Feedback(fb.getId());
                system.assertEquals('Assigned', fb.getStatus());
                system.assertEquals(UserInfo.GetUserId(), fb.getAssignedTo());
                
                fb.setStatus('Resolved');
                system.debug('not sure if I get a feeditem when I resolve it');
                fb.save();
                
                fb = new Feedback(fb.getId());
                system.assertEquals('Resolved', fb.getStatus());
        }
        
        static testMethod void TestAutoSummary(){
        
                Feedback fb = new Feedback('test', 'now is the time. for all good men.');
                system.assertEquals('now is the time', fb.getSummary());
                
                fb = new Feedback('test', 'now\nis\nthe\ntime');
                system.assertEquals('now', fb.getSummary());
        }
        
        static testMethod void TestLeft(){
        
            system.assertEquals('abc', Feedback.Left('abcdefg', 3));
            system.assertEquals('abc', Feedback.Left('abc', 5));
            system.assertEquals('', Feedback.Left('abc', 0)); 
            system.assertEquals('', Feedback.Left(null, 3));    
        }
        
        static testMethod void executeAnonymousTest(){
        
                if (Test.isRunningTest() == true)
                        return;
                /* 
                execute this code inside an anonymous tab
                         
                Feedback_Config__c config = new Feedback_Config__c(
                    name = 'Testing',
                    post_uri__c = 'https://xcg.secure.force.com/services/apexrest/FeedbackRest',
                    use_post_uri__c = true,
                    product_category__c = 'Testing'
                );
                
                system.debug(config);
                system.debug(UserInfo.GetOrganizationName());
                
                Feedback fb = new Feedback(UserInfo.GetOrganizationId(), 'aName', 'aType', 'aSummary', 'aDescription');
                fb.setConfig(config);
                fb.save();
                */
        }
        
        static testMethod void bugFB00043(){
        
                if (Test.isRunningTest() == true)
                        return;
                /* 
                execute this code inside an anonymous tab
                         
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                
                request.setMethod('POST');
                request.setBody('<message>Can you see me?</message>');
                request.setEndpoint('https://xcg.secure.force.com/services/apexrest/FeedbackRest?ignore=true');
                
                Httpresponse response = http.send(request);
                
                system.debug(response.getBody());
                */
        }
}