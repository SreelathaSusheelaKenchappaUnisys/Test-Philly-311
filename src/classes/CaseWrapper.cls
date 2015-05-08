global with sharing class CaseWrapper {

    static void AddAddressFailTo(Case aCase, list<CaseComment> aList) {
        aCase.Description = '*ADDRESS VERIFICATION NOT DONE  \r\n' + aCase.Description;
        
        aList.add(
            new CaseComment(
            CommentBody = 'ADDRESS VERIFICATION FAILED',
            IsPublished = false,
            ParentId = aCase.id
            )
        );
    }
    
    public static void ConvertCenterlineTo2272(list<string> aStringList) {
        if (aStringList.isEmpty())
            return;
            
        if (system.isFuture()) {
            system.debug('already in the future?');
            ConvertCenterlineTo2272Now(aStringlist);
        } else {
            // we want to avoid re-running in the present
            // as well as the future.  since the static variable
            // has a different context both now and in the future
            // we must check it in two places.
            
            system.debug('HasAfterUPdateFired = ' + HasAfterUpdateFired);
            if (HasAfterUpdateFired)
                return;
        
            HasAfterUpdateFired = true;
            
            ConvertCenterlineTo2272Future(aStringlist);
        }
    }
    
    @future (callout=true)
    static void ConvertCenterlineTo2272Future(list<string> aStringList) {
        ConvertCenterlineTo2272Now(aStringlist);
    }
    
    static void ConvertCenterlineTo2272Now(list<string> aStringList) {
        system.debug('Case id list = ' + aStringList);
    
        system.debug('HasFutureFired = ' + HasFutureFired);
          
        if (HasFutureFired)
            return;
    
        HasFutureFired = true;
        
        if (aStringList == null || aStringList.size() == 0)
            return;
        
        Group reject = [ select id from group where developerName = 'CitiWorks_Reject' limit 1 ];
        list<Case> caseList = [ 
        select  id, 
            RecordTypeId,
            description, 
            street__c, 
            centerline_match_type__c, 
            centerline__latitude__s, 
            centerline__longitude__s, 
            centerline_2272x__c, 
            centerline_2272y__c 
          from  Case 
            where  id in :aStringlist 
        ];
        
        system.debug(caseList);
        
        set<id> rejectSet = RejectTypes();
        
        GIS aGis = new GIS();
        
        //build geocode (addresses) requst
        
        list<Case> codedList = new list<Case>();
        list<CaseComment> commentList = new list<CaseComment>();
        
        for (Case each : caseList) {
        
            boolean geocodingSucceeded = false;
            
            try {
                string aStringResponse = aGis.address(each.street__c);
                GIS.AddressResponse aResponse = (GIS.AddressResponse) Json.deserialize(aStringResponse, GIS.AddressResponse.class);
                
                GIS.Address anAddress = aResponse.addresses[0];
                each.Street__c = anAddress.standardizedAddress;
                each.Centerline__Longitude__s = anAddress.xCoord;
                each.Centerline__Latitude__s = anAddress.yCoord;
                each.Centerline_Match_Type__c = anAddress.matchType;
                
                // values from other places (topics and service areas)
                each.hansenAddressKey__c = anAddress.addressKey;
                each.L_I_Address__c = anAddress.liAddress;
                
                // if we've come this far, there are values worth saving even if areas fails below
                codedList.add(each);
                geocodingSucceeded = true;
              } catch (XedeException xex) {
              
                   system.debug('Caught exeception');
                   system.debug(xex);
                   if (rejectSet.contains(each.RecordTypeId)) {
                       each.OwnerId = reject.id;
                       AddAddressFailTo(each, commentList);
                   }
             } 
            
             catch (System.Calloutexception cex) {
                 system.debug('Caught exeception');
                 system.debug(cex);
                 if (rejectSet.contains(each.RecordTypeId)) {
                     each.OwnerId = reject.id;
                     AddAddressFailTo(each, commentList);
                 }
             }
            
            // get service areas if geocoding above worked
         
            if (geocodingSucceeded == false)
                continue;
            
            try {
                map<string, string> areaMap = aGis.serviceAreas(each.Street__c);
            
                each.Pickup_Day__c = areaMap.get('SA_STREETS_Rubbish');
                each.Center_City_District__c = areaMap.get('SA_CENTER_CITY_DISTRICT');
                each.Council_District__c = areaMap.get('SA_PLANNING_2016Councilmanic');
                each.Council_District_No__c = areaMap.get('SA_PLANNING_2016Councilmanic');
                each.ZipCode__c = areaMap.get('SA_STREETS_ZipCode');
            } catch (Exception ex) {           
            
                system.debug('Caught exeception'); // we ignore exceptions because service-areas aren't as critical
                system.debug(ex);     // as geocoding the address  
            } 
        }       
        
        //build project request
        
        list<list<string>> xyStringList = new list<list<string>>();
        for (Case each : codedList)
            xyStringList.add(new string[] { String.ValueOf(each.centerline__longitude__s), String.ValueOf(each.centerline__latitude__s) });
        
        if (codedList.isEmpty() == false) {
            do {
                try {
                    GIS.ProjectResponse aResponse = aGis.project(xyStringList, '4326', '2272');
                
                    if (aResponse == null) {
                        system.debug(XedeLog.Write('aGis.project() returned null'));
                        break;
                    }
                    
                    if (aResponse.geometries == null) {
                        system.debug(XedeLog.Write('aGis.project() returned no geometries'));
                        break;
                    }
                    
                    if (aResponse.geometries.size() != caseList.size()) {
                        system.debug(XedeLog.Write('aGis.project() returned {0} geometries but caseList has {1}', 
                        aResponse.geometries.size(),
                        caseList.size()
                        ));
                        break;
                    }
                    
                    for (integer i = 0; i < aResponse.geometries.size(); i++) {
                        codedList[i].centerline_2272x__c = aResponse.geometries[i].x;
                        codedList[i].centerline_2272y__c = aResponse.geometries[i].y;
                    }
                } catch (XedeException xex) {               
                
                    XedeLog.Write('Unable to project xy pairs : {0}', xyStringLIst);
                    for (Case each : codedList) {
                        each.OwnerId = reject.id;
                        AddAddressFailTo(each, commentList);
                    }
                }
            } while (1 == 2); // should just do it once
        }
        
        if (caseList.isEmpty() == false)
            update caseList;
            
        if (commentList.isEmpty() == false)
            insert commentList;
    }
    
    static set<id> RejectTypes() {
        list<X311RequestType__c> requestTypeList = [ 
        select id, case_recordtypeid__c, name 
        from X311RequestType__c 
        where requiresGeocode__c = true
        and case_recordtypeid__c != null 
        ];
        
        set<id> idSet = new set<Id>();
        
        for (X311RequestType__c each : requestTypeList)
            idSet.add(each.Case_RecordTypeId__c);
        
        return idSet;
    }
    
    static boolean HasFutureFired = false;
    static boolean HasAfterUpdateFired = false;
}