/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackBitBucketTest {

        static testMethod void commitTest() {
                Contact aContact = FeedbackMock.SavedContactWithEmail('marcus@somedomain.com');
                system.assertNotEquals(null, aContact.id);
                
                Feedback fb1 = new Feedback('summary1', 'description1');
                fb1.save();
                fb1 = new Feedback(fb1.getId());
                
                Feedback fb2 = new Feedback('summary2', 'description2');
                fb2.save();
                fb2 = new Feedback(fb2.getId());
                
                Feedback fb3 = new Feedback('summary3', 'description3');
                fb3.save();
                fb3 = new Feedback(fb3.getId());
                
                PageReference pg = Page.blank;
                
                XedeTestData data = new XedeTestData('FeedbackTestData');
                string format = data.find('BitPushData1');
                
                system.debug(format);
                
                format = format.replace('{0}', fb1.getName());
                format = format.replace('{1}', fb2.getName());
                string payload = format.replace('{2}', fb3.getName());
                
                system.debug(payload);
                
                FeedbackBitBucket aGitHub = new FeedbackBitBucket();
                aGitHub.handle(payload);
                system.assertEquals(1, aGitHub.feedbackNameList.size());
                system.assertEquals(11, Limits.getDmlStatements());  
                
                list<Task> taskList = [ select id, whoId, description from Task where whatId = :fb1.getId() ];
                system.assertEquals(1, taskList.size());
                system.assertEquals(aContact.id, taskList[0].whoId); 
                
                string commitUrl = 'https://bitbucket.org/marcus/project-x/commits/620ade18607ac42d872b568bb92acaa9a28620e9'; 
                system.assert(taskList[0].description.startsWith(commitUrl), taskList[0].description);
                
                system.assert(taskList[0].description.contains('Bertrand'), 'the author\' last name is missing?');
                system.assert(taskList[0].description.contains('marcus@somedomain.com'), 'the author\' email is missing?');
        }    
}