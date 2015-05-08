/*
Copyright 2013, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackControllerTest {

        static testMethod void testMultipleFeedbacksOnPortalHomePage(){
             
                Pagereference pg = Page.Blank;
                Test.setCurrentPage(pg);
                pg.getHeaders().put('User-Agent','there needs to be a user-agent header');
                
                string pageUrl =  URL.getSalesforceBaseUrl().toExternalForm() + pg.getUrl();
                
                pg.getParameters().put('PageURL', pageURL); //we now expect this value to be passed in since feedback is now a popup
                
                FeedbackController fb = new FeedbackController();
                
                system.assertEquals(null, fb.getType());
                system.assertNotEquals(null, fb.getUrl());
                system.assertEquals(pageURL, fb.getUrl(), 'fb.currentPageUrl should be the full path');
                
                fb.proxy.type__c = 'Feedback Unit Test 1';
                fb.proxy.description__c = 'First test feedback on portal home page';
                
                system.assertEquals(0, Limits.getDmlStatements());
                fb.sendFeedback();
                system.assertEquals(3, Limits.getDmlStatements(), '1(feedback insert) 2(feedback update trigger)');
                
                List<Feedback__c> testFeedback = [select Id, Long_url__c from Feedback__c where Type__c = 'Feedback Unit Test 1'];
                system.assertEquals(1, testFeedback.size());
                system.assertEquals(pageURL, testFeedback[0].Long_url__c);
                
                system.assertEquals('Feedback Unit Test 1', fb.getType());
                system.assertEquals(pageURL, fb.getUrl());
                
                fb.proxy.type__c = 'Feedback Unit Test 2';
                fb.proxy.description__c = 'Second test feedback on portal home page';
                
                fb.sendFeedback();
                
                testFeedback = [select Id, Long_url__c, Description__c from Feedback__c where Type__c = 'Feedback Unit Test 2'];
                system.assertEquals(1, testFeedback.size());
                system.assertEquals(pageURL,testFeedback[0].Long_url__c);
                
                system.assertEquals('Feedback Unit Test 2', fb.getType());
                system.assertEquals(pageUrl, fb.getUrl());
        }       
    
        static testMethod void testAddNoteToFeedbackRecord() {
                Pagereference pg = Page.Blank;
                Test.setCurrentPage(pg);
                pg.getHeaders().put('User-Agent','there needs to be a user-agent header');
                
                FeedbackController fb = new FeedbackController();
                
                fb.proxy.type__c = 'Feedback Unit Test';
                fb.proxy.description__c = 'There will eventually be a note attached to this record.';
                fb.sendFeedback();
        
                List<Feedback__c> testFeedback = [select Id, (select Id from Notes) from Feedback__c where Type__c = 'Feedback Unit Test'];
                system.assertEquals(1,testFeedback.size());
                system.assertEquals(0,testFeedback[0].Notes.size());
                
                Note feedbackNote = new Note();
                feedbackNote.Title = 'Feedback Note';
                feedbackNote.Body = 'Call now for your chance to win!';
                feedbackNote.ParentId = testFeedback[0].Id;
                insert feedbackNote;
        
                testFeedback = [select Id, (select Id from Notes) from Feedback__c where Type__c = 'Feedback Unit Test'];
                system.assertEquals(1,testFeedback.size());
                system.assertEquals(1,testFeedback[0].Notes.size());
        }
    
        static testMethod void testDescriptionExceedsMaxLength(){
    
                Integer descriptionMaxLength = Feedback__c.Description__c.getDescribe().getLength();
                 
                Pagereference pg = Page.Blank;
                Test.setCurrentPage(pg);
                pg.getHeaders().put('User-Agent','there needs to be a user-agent header');
                
                FeedbackController fb = new FeedbackController();
                
                fb.proxy.type__c = 'Feedback Unit Test';
                fb.proxy.description__c = 'Message is too long.';
                
                for(integer counter=0; counter < descriptionMaxLength; counter++)
                    fb.proxy.description__c += 'XY';
                
                fb.sendFeedback();
        
                List<Feedback__c> testFeedback = [select Id, Description__c from Feedback__c where Type__c = 'Feedback Unit Test'];
        
                system.assertEquals(1,testFeedback.size());
                system.assertEquals(testFeedback[0].Description__c.length(),descriptionMaxLength);
        }
        
        static testMethod void jsonDeserializeTest() {
        
                XedeTestData data = new XedeTestData('FeedbackTestData');
                string aString = data.find('JsonWithCurrencyCode');
                map<string, object> aMap = (map<string, object>) Json.DeserializeUntyped(aString);
                
                aMap.remove('CurrencyIsoCode');
                
                string newJson = Json.serialize(aMap);
                Feedback_Config__c config = (Feedback_Config__c) Json.Deserialize(newJson, Feedback_Config__c.class);
                system.assertEquals(false, config.Use_Post_URI__c);
                system.assertEquals('Default2', config.Name);
                system.assertEquals('Macquarie', config.Product_Category__c);
                
                system.assertEquals('https://xfb-developer-edition.na12.force.com/apex/Feedback', config.Post_URI__c);      
        }
        
        static testMethod void testRelatedFeedback() {
       
                Feedback original = new Feedback('original', 'description');
                original.save();
                system.assertNotEquals(null, original.getId());
                
                Pagereference pg = Page.Blank;
                pg.getParameters().put('related', original.getId());
                Test.setCurrentPage(pg);
                system.assertEquals(1, ApexPages.currentPage().getParameters().size());
                system.assertEquals(original.getId(), ApexPages.currentPage().getParameters().get('related'));
                
                FeedbackController fb = new FeedbackController();
                system.debug(fb.xproxy);
                system.debug(fb.proxy);
                system.assertNotEquals(null, fb.xproxy.Related_Feedback__c);
                
                fb.proxy.type__c = 'related unit test';
                fb.proxy.description__c = 'related description';
                fb.sendFeedback();
        
                system.assertNotEquals(null, fb.xproxy.id);
                system.assertNotEquals(null, fb.xproxy.feedback__c);
                system.assertNotEquals(null, fb.getRecordId());
        }
        
        static testMethod void anonymousExecuteTest() {
                /*
                execute the below in an anonymous block
                        
                Feedback_Config__c config = Feedback_Config__c.GetInstance('Remote');
                Feedback fb = new Feedback('Test', 'Summary', 'Description');
                fb.setType('Chore');
                fb.setUrl('http://www.google.com');
                fb.setConfig(config);
                fb.save();
                */
        }
}