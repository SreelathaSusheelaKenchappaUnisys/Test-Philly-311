/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackRestTest {

        static testMethod void EmptySuccessTest() {
        
                //
                // created for fb-00037
                //
                RestRequest aRequest = new RestRequest();
                aRequest.addParameter('owner', UserInfo.getName());
                aRequest.addParameter('productCategory', 'Feedback');
                aRequest.addParameter('organizationId', 'anOrganizationId');
                aRequest.addParameter('organizationName', 'anOrganizationName');
                aRequest.addParameter('summary', 'aSummary');
                aRequest.addParameter('description', 'just testing');
                aRequest.addParameter('type', 'chore');
                aRequest.addParameter('host', 'aHost');
                aRequest.addParameter('referer', 'aReferer');
                aRequest.addParameter('url', 'http://www.google.com/');
                aRequest.addParameter('userAgent', 'aUserAgent');
                aRequest.addParameter('userEmail', 'tgagne@xede.com');
                aRequest.addParameter('userName', 'Tom Gagne');
                
                RestResponse aResponse = new RestResponse();
                system.assertNotEquals(null, aResponse.headers);
                
                FeedbackRest aRest = new FeedbackRest();
                
                aRest.handleRequest(aRequest, aResponse);
                
                ID anId = AssertSuccess(aResponse.responseBody);
                
                Feedback fb = new Feedback(anId);
                
                system.assertEquals('anOrganizationId', fb.getOrganizationId());
                system.assertEquals('anOrganizationName', fb.getOrganizationName());
                system.assertEquals('aSummary', fb.getSummary());
                system.assertEquals('just testing', fb.getDescription());  
                system.assertEquals('Chore', fb.getType()); 
                system.assertEquals('aHost', fb.getHost());
            
        }
        
        static testMethod void PercentCharacterTest() {
        
                //
                // fb-00040
                //
                RestRequest aRequest = new RestRequest();
                aRequest.addParameter('summary', EncodingUtil.urlEncode('Is there a problem with % characters?', 'utf-8'));
                
                RestResponse aResponse = new RestResponse();
                
                FeedbackRest aRest = new FeedbackRest();
                
                aRest.handleRequest(aRequest, aResponse);
                
                AssertSuccess(aResponse.responseBody);
        }
        
        static string AssertSuccess(Blob aBlob) {
       
                Dom.Document aDoc = new Dom.Document();
                aDoc.load(aBlob.toString());
                Dom.XmlNode aRoot = aDoc.getRootElement();
                system.assertEquals('feedback', aRoot.getName());
                system.assertEquals('Success', aRoot.getAttribute('type', null));
                system.assertNotEquals('', aRoot.getAttribute('id', null));
                
                return aRoot.getAttribute('id', null);
        }
        
        static testMethod void TestRemoteURLTest(){
        
                Feedback_Config__c aConfig = FeedbackMock.SavedConfig('fb-00456');
                
                RestRequest aRequest = new RestRequest();
                aRequest.addParameter('action', 'popup');
                aRequest.addParameter('config', 'fb-00456');
                
                RestResponse aResponse = new RestResponse();
                
                FeedbackRest aRest = new FeedbackRest();
                
                aRest.handleRequest(aRequest, aResponse);
                
                system.assertNotEquals(null, aResponse.responseBody);
                FeedbackRest.PopupResponse popup = (FeedbackRest.PopupResponse) Json.deserialize(aResponse.responseBody.toString(), FeedbackRest.PopupResponse.class);
                system.assertEquals('https://xcg.secure.force.com/apex/Feedback', popup.url);
                system.debug(popup.parameters);
        }
}