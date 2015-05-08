/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@RestResource(urlMapping='/FeedbackRest/*')
global with sharing class FeedbackRest extends XedeObject {
    
        global class PopupResponse {
                global string url;
                global string parameters;
        }
    
        @HttpGet
        global static void doGet() {
                FeedbackRest aRest = new FeedbackRest();        
                aRest.handleRequest(RestContext.request, RestContext.response);     
        }
      
        @HttpPost
        global static void doPost() {                    
                FeedbackRest aRest = new FeedbackRest();
                aRest.handleRequest(RestContext.request, RestContext.response);        
        }
    
        public FeedbackRest() {} // is public for unit testing purposes
        
        public void handleRequest(RestRequest request, RestResponse response){
        
                system.debug(request);
                string action = request.params.get('action');
                
                if (String.isNotBlank(action) && action.equalsIgnoreCase('popup'))
                        handlePopup(request, response);
                
                else
                        handleLegacy(request, response);
        }
        
        public void handlePopup(RestRequest request, RestResponse response) {
       
                FeedbackComponentController fcc = new FeedbackComponentController();
                fcc.settingName = request.params.get('config');
                fcc.getFeedbackConfig();
                
                PopupResponse popup = new PopupResponse();
                popup.url = fcc.getUri();
                popup.parameters = fcc.getUrlParameters();
                
                response.responseBody = Blob.ValueOf(Json.Serialize(popup));
        }
        
        public void handleLegacy(RestRequest request, RestResponse response) { 
       
                string decodedParam; // when the parameters are URL encoded, they should arrive here decoded
                
                Feedback fb = new Feedback();
                
                try {
                        response.addHeader('Content-Type', 'application/xml; charset=ISO-8859-1');
            
                        try {
                                Feedback_Config__c fbc = new Feedback_Config__c();
                                fb.setConfig(fbc);
                                
                                for (string each : request.params.keySet()) {
                                
                                        if (each.equalsIgnoreCase('owner')) {
                                                fbc.Owner__c = request.params.get(each);
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('productCategory')) {
                                                fbc.Product_Category__c = request.params.get(each);
                                                continue;
                                        }
                                                    
                                        if (each.equalsIgnoreCase('organizationId')) {      
                                                fb.setOrganizationId(request.params.get(each));
                                                continue;
                                        }
                                    
                                        if (each.equalsIgnoreCase('organizationName')) {
                                                fb.setOrganizationName(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('type')) {
                                                fb.setType(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('summary')) {
                                                fb.setSummary(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('description')) {
                                                fb.setDescription(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('host')) {
                                                fb.setHost(request.params.get(each));
                                                continue;
                                        }   
                                        
                                        if (each.equalsIgnoreCase('referer')) {
                                                fb.setReferrer(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('url')) {
                                                fb.setUrl(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('userAgent')) {
                                                fb.setUserAgent(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('userEmail')) {
                                                fb.setUserEmail(request.params.get(each));
                                                continue;
                                        }
                                        
                                        if (each.equalsIgnoreCase('userName')) {
                                                fb.setUserName(request.params.get(each));
                                                continue;
                                        }                   
                                }
                            
                                fb.save();
                                FeedbackException.RaiseSuccess(fb);
                                
                        }catch (FeedbackException ex){ 
                                throw ex;
                        }
                        catch (Exception ex){
                        
                                system.debug('Unexpected error, ' + ex.getMessage());
                                FeedbackException.RaiseError('Saving Feedback', ex);
                        }
                        
                }catch (FeedbackException fex) {
                
                        string xmlString = fex.getXmlString();
                        system.debug(xmlString);
                        response.responseBody = Blob.valueOf(xmlString);
                }       
        }
}