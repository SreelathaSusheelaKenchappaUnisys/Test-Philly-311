global with sharing class ContactWrapper {

        public static void AddressAndAreas(string aContactId) {
        
                if(HasAfterUpdateFired == true)   
                        return;
                    
                HasAfterUpdateFired = true;
          
                if(system.isFuture()) {
                
                        system.debug('Already future, call now method.');
                        AddressAndAreasNow(aContactId);
                        
                }else {
               
                        system.debug('Not the future, make it so.');
                        AddressAndAreasFuture(aContactId);
                }
        }
    
        @future (callout=true)
        public static void AddressAndAreasFuture(string aContactId)  {
   
                AddressAndAreasNow(aContactId);
        }
    
        public static void AddressAndAreasNow(string aContactId) {
    
                try {
                        GIS aGis = new GIS();
                        string aStandardizedAddress;
                    
                        Contact aContact = [ select id, mailingStreet, PhillyRisingArea__c from Contact where id = :aContactId limit 1 ];
                    
                        string aStringResponse = aGis.address(aContact.mailingStreet);
                        GIS.AddressResponse aResponse = (GIS.AddressResponse) Json.deserialize(aStringResponse, GIS.AddressResponse.class);
                    
                        GIS.Address anAddress = aResponse.addresses[0];
                        aStandardizedAddress = anAddress.standardizedAddress;
                    
                        map<string, string> areaMap = aGis.serviceAreas(aStandardizedAddress);
                        aContact.PhillyRisingArea__c = areaMap.get('SA_PHILLYRISING');
                        update aContact;
                        
                } catch (Exception ex) {
               
                        system.debug('Caught exceptions');
                        system.debug(ex);
                }
        }
    
        public static boolean HasAfterUpdateFired = false;
}