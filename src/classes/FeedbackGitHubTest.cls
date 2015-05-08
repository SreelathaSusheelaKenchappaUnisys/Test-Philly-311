/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackGitHubTest {

        static testMethod void commitTest() {
        
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
                string format = data.find('GitPushData1');
                
                format = format.replace('{0}', fb1.getName());
                format = format.replace('{1}', fb2.getName());
                string payload = format.replace('{2}', fb3.getName());
                
                system.debug(payload);
                
                FeedbackGitHub aGitHub = new FeedbackGitHub();
                aGitHub.handle(payload);
                system.assertEquals(3, aGitHub.feedbackNameList.size());
                system.assertEquals(10, Limits.getDmlStatements());        
        }    
}