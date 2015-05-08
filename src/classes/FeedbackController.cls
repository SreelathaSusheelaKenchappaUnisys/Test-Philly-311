/*
Copyright 2013, Xede Consulting Group, Inc.
*/

public without sharing class FeedbackController extends XedeController {
    
        public FeedbackController() {
                super();
                system.debug(pageParameters);
                model = new Feedback(null, '');
                model.setUrl(pageParameters.get('PageURL'));
                model.setUserName(pageParameters.get('userName'));
                model.setUserEmail(pageParameters.get('userEmail'));
                model.setUserAgent(pageHeaders.get('User-Agent'));
                model.setReferrer(pageHeaders.get('Referer'));
                model.setOrganizationId(pageParameters.get('orgId'));
                model.setOrganizationName(pageParameters.get('orgName'));
                
                string aString = pageParameters.get('config');
                if (String.IsNotBlank(aString)) {
                        system.debug('Config JSON : ' + aString);
                    
                    try {
                            map<string, object> aMap = (map<string, object>) Json.DeserializeUntyped(aString);
                            aMap.remove('CurrencyIsoCode');
                            string newJson = Json.serialize(aMap);
                            model.setConfig((Feedback_Config__c) Json.DeSerialize(newJson, Feedback_Config__c.class));
                    } catch (Exception e){  
                            system.debug(e.getMessage());
                            throw e;
                    }
                }
                
                loadProxiesFromModel();
        }
        
        public string getDescription() { return proxy == null ? null : proxy.Description__c; }  
        public string getRecordId() { return model == null ? null : model.getId(); }    
        public string getRecordNumber() { return model == null ? null : model.getName(); }
        public string getType() { return proxy == null ? null : proxy.Type__c; }
        public string getSummary() { return proxy == null ? null : proxy.summary__c; }
        public string getUrl() { return model == null ? null : model.getUrl(); }
    
        protected override void loadProxiesFromModel(){
        
                proxy = new Feedback__c();
                proxy.type__c = model.getType();
                proxy.summary__c = model.getSummary();
                proxy.description__c = model.getDescription();
                
                xproxy = new Feedback_Feedback__c();
                xproxy.Related_Feedback__c = pageParameters.get('related');
        }
        
        protected override void loadModelFromProxies(){
        
                model.setType(proxy.type__c);
                model.setDescription(proxy.description__c);
                model.setSummary(proxy.summary__c);
        }
    
        public PageReference sendFeedback(){
                loadModelFromProxies();
            
                if (String.IsNotBlank(xproxy.Related_Feedback__c)) {
                        Feedback parent = new Feedback(xproxy.Related_Feedback__c);
                        Feedback child = parent.copyForRelated();
                        child.setDescription(model.getDescription());
                        child.setSummary(model.getSummary());
                        child.setType(model.getType());
                        child.save();
                        model = child;  // fb-00590
                        
                        xproxy.Feedback__c = child.getId();
                        upsert xproxy;
                        
                        return null;
                }
    
                model.save();
                return null;
        }
    
        Feedback model {get; private set;}
        
        public Feedback__c proxy { get; private set; } 
        public Feedback_Feedback__c xproxy { get; private set; }
        
        public string relation { get; set; }
        public string relatedItem { get; set; }
}