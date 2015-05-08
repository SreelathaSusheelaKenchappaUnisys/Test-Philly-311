@isTest
private class X311CaseEditClrExtTest{
    
    
    static Case cse;
    static testMethod void  getRecord()
    {
        //Case cse=[select casenumber,subject from Case where subject='Abandoned Bike' LIMIT 1 ];
        cse=new Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike');
        system.assertNotEquals(null,cse);
        
        Directory__c dir=new Directory__c (Name='MAGDALENA INCZE', Bold__c='1',Department__c='DEPARTMENT OF HUMAN SERVICES', DepartmentCode__c='022', 
                                FirstName__c='MAGDALENA', LastName__c='INCZE', Location__c='1515 ARCH-5FL', Phone__c='(215) 683-6679',
                                Title__c='SOCIAL WORKER 2', Unit__c='DEPARTMENT OF HUMAN SERVICES', UnitCode__c='022222737');
                                
        insert dir;
        ApexPages.currentPage().getParameters().put('cas14', cse.subject);
        ApexPages.currentPage().getParameters().put('dirId', dir.id);
        ApexPages.currentPage().getParameters().put('dirSR', 'Directory Assistance - IR');
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        system.assertNotEquals(null,editClr.cs);
        system.assertEquals('Abandoned Bike',editClr.cs.subject);
       system.assertEquals(null, editClr.cs.RecordTypeId);
       
    
    }
    static testMethod void getRecordTypeInfoTest()
    {
      // RecordType ='xyz';
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email',Tagged_With_Yellow_Alert_Notice__c='No');
        //cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        system.assertNotEquals(null,cse);
        
        ApexPages.currentPage().getParameters().put('cas14', cse.subject);
        ApexPages.currentPage().getParameters().put('dirId', cse.id);
        ApexPages.currentPage().getParameters().put('dirSR', cse.casenumber);
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
      // editClr.cs.RecordTypeId ='xyz';
      editClr.cs.id = null;
     // editClr.cs.RecordType == 'Information Request';
        //RecordType rd = [Select name,id from RecordType where id =: editClr.cs.RecordTypeId];
        //system.assertNotEquals(null,rd);
        system.assertEquals(true,editClr.getrecordtypeinfo());
    }
    static testMethod void getSrTypeInfoTest()
    {
        //cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email',Tagged_With_Yellow_Alert_Notice__c='No');
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        system.assertNotEquals(null,cse);
        
        ApexPages.currentPage().getParameters().put('cas14', cse.subject);
        ApexPages.currentPage().getParameters().put('dirId', cse.id);
        ApexPages.currentPage().getParameters().put('dirSR', cse.casenumber);
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        system.assertEquals(false,editClr.getsrtypeinfo());
    }
    static testMethod void getrecordtypeinfoInformationRequestTest()
    {
        //cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email',Tagged_With_Yellow_Alert_Notice__c='No');
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        system.assertNotEquals(null,cse);
        
        ApexPages.currentPage().getParameters().put('cas14', cse.subject);
        ApexPages.currentPage().getParameters().put('dirId', cse.id);
        ApexPages.currentPage().getParameters().put('dirSR', cse.casenumber);
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        system.assertEquals(false,editClr.getrecordtypeinfoInformationRequest());
    }
    static testMethod void getrecordtypeinfoNotInformationRequestTest()
    { 
    //cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email',Tagged_With_Yellow_Alert_Notice__c='No');
      cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        system.assertNotEquals(null,cse);
        
        ApexPages.currentPage().getParameters().put('cas14', cse.subject);
        ApexPages.currentPage().getParameters().put('dirId', cse.id);
        ApexPages.currentPage().getParameters().put('dirSR', cse.casenumber);
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        system.assertEquals(false,editClr.getrecordtypeinfoNotInformationRequest());
        
        
        
        
    
    }
    static testMethod void getStatusnameTest()
    {
        
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',status='New');
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        List<selectOption> options = editClr.getStatusname();
        system.assertEquals(2,options.size());
        cse.status='Open';
        options=editClr.getStatusname();
        system.assertEquals(1,options.size());
        cse.status='In-Progress';
        options=editClr.getStatusname();
        system.assertEquals(4,options.size());
        options=editClr.getStatus();
        system.assertEquals(3,options.size());
        
    }
    static testMethod void pickListCodeTest()
    {
       cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
       // cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike', origin='Email',Tagged_With_Yellow_Alert_Notice__c='No');
        // = new List<SelectOption>();
        insert cse;
        Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        cse.RecordTypeId = cs.RecordTypeId;
       // cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
      //  rt.recordtypeid='012G00000014BWo';
        rt.DeveloperName='Abandoned_Vehicle';
        cse.Department__c = 'Police Department';
        list<SelectOption> option=editClr.getSrname();
        //String result=editClr.getScriptName();
        system.assertNotEquals(0,option.size());
       // system.assertNotEquals(null,result);
        
        rt.DeveloperName='Illegal_Dumping';
        option = editClr.getIllegalServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Rubbish_Collection';
        option = editClr.getRubbishRecyclableServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Street_Light_Outage';
        option = editClr.getStreetServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Graffiti';
        option = editClr.getGraffitiServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='No_Heat_Residential';
        option = editClr.getNoHeatServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Boarding_Room_House';
        option = editClr.getBoardingRoomReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Daycare_Residential_or_Commercial';
        option = editClr.getDayCareReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Emergency_Air_Conditioning';
        option = editClr.getEmergencyAirReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Fire_Residential_or_Commercial';
        option = editClr.getFireResidentialReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Infestation_Residential';
        option = editClr.getInfestationResidential();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='License_Residential';
        option = editClr.getLicenseResidentialReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Maintenance_Residential_or_Commercial';
        option = editClr.getMaintenanceResidentialReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Vacant_House_or_Commercial';
        option = editClr.getVacantHouse();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Zoning_Residential';
        option = editClr.getZoningResidentialReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Zoning_Business';
        option = editClr.getZoningBusinessReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Construction_Site_Task_Force';
        option = editClr.getConstructionSiteTaskForceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Building_Dangerous';
        option = editClr.getBuidingDangereousReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Building_Construction';
        option = editClr.getBuildingConstruction();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Dangerous_Sidewalk';
        option = editClr.getDangerousSidewalk();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Abandoned_Bike';
        option = editClr.getAbandonedBike();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Dead_Animal_in_Street';
        option = editClr.getDeadAnimal();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Sanitation_Dumpster_Violation';
        option = editClr.getSanitationDumpster();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Line_Striping';
        option = editClr.getLineStriping();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Manhole_Cover';
        option = editClr.getManhole();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Newsstand_Outdoor_Cafe';
        option = editClr.getNewsstand();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Other_Streets';
        option = editClr.getOtherStreets();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Salting';
        option = editClr.getSalting();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Shoveling';
        option = editClr.getShoveling();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Stop_Sign_Repair';
        option = editClr.getStopSign();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Smoke_Detector';
        option = editClr.getSmokeDetector();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Street_Paving';
        option = editClr.getStreetPaving();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Traffic_Other';
        option = editClr.getTrafficOther();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Traffic_Signal_Emergency';
        option = editClr.getTrafficSignalEmergency();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Alley_Light_Outage';
        option = editClr.getAlleyLightOutage();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Complaint_Streets';
        option = editClr.getComplaintStreets();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Street_Defect';
        option = editClr.getStreetDefect();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Inlet_Cleaning';
        option = editClr.getInletCleaning();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Hydrant_Knocked_Down_No_Water';
        option = editClr.getHydrantKnockedDown();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Complaints_Against_Fire_or_EMS';
        option = editClr.getComplaintsagainstFire();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Police_Complaint';
        option = editClr.getPoliceComplaint();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Vacant_Lot_Clean_Up';
        option = editClr.getVacantLotCleanUp();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Street Trees';
        option = editClr.getStreetTrees();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Parks_and_Rec_Safety_and_Maintenance';
        option = editClr.getParksandRec();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Information_Request';
        option = editClr.getInformationServiceReq();
        system.assertNotEquals(0,option.size());
        
        rt.DeveloperName='Miscellaneous';
        option = editClr.getMiscellaneousServiceReq();
        system.assertNotEquals(0,option.size());
        
        
        option=editClr.getNoHeatServiceReq();
        system.assertNotEquals(0,option.size());
        option=editClr.getBoardingRoomReq();
        system.assertNotEquals(0,option.size());
        option=editClr.getBuidingDangereousReq();
        system.assertNotEquals(0,option.size());
        option=editClr.getDayCareReq();
        system.assertNotEquals(0,option.size());
        
        
        system.assertEquals(false,editClr.getrecordtypeinfo1());
        system.assertEquals(false,editClr.getrecordtypeinfo2());
        system.assertNotEquals(true, editClr.getuserinfo());
        system.assertNotEquals(null, editClr.getuserinfo1());
        
        
    }
    static testMethod void partnerEndPageTest()
    {
    cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        cse.RecordTypeId = cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        
        List<selectOption> options = editClr.getOrigin();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getInformation();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getServiceType();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getMiscellaneousServiceReq();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getInformationServiceReq();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getStreetServiceReq();
        system.assertNotEquals(0,options.size());
        
        options=editClr.getRubbishRecyclableServiceReq();
        system.assertNotEquals(0,options.size());
        
        
    }
    @isTest(SeeAllData=true)
    static void getFlow1NameTest()
    {
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        List<Case> lst=[SELECT RecordTypeId FROM Case LIMIT 40];
        for(Case cs: lst)
        {
       // Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
        rt.developerName='Abandoned_Vehicle';
        String scriptName=editClr.getFlow1Name();
        system.assertNotEquals(null,scriptName);
        }
       
        
        
    }
    @isTest(seeAllData=true)
    static void getScriptNameTest()
    {
        cse=New Case(Type='Service Request Type',street__c='xyz',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        
        insert cse;
        //Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        for(RecordType rt1:[select developerName,id from recordtype LIMIT 40])
        {
       // RecordType rt1 = [select developerName,id from recordtype where developerName ='Abandoned_Bike'];
        cse.RecordTypeId=rt1.Id;
        
       // Case cse1 = [select Type,Department__c,Case_record_type__c,Service_Request_Type__c,Unusable__c,subject,origin,RecordTypeId,Tagged_With_Yellow_Alert_Notice__c from case where id =: cse.id];
        //cse.RecordTypeId ='012G00000014BWo';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        editClr.rt=rt1;
        //RecordType rt=new RecordType();
        //rt.developerName='Abandoned_Vehicle';
      //  Test.startTest();
        list<selectOption> lst= editClr.getSrname();
        String scriptName=editClr.getScriptName();
        system.assertNotEquals(null,scriptName);
         //  String flowName=editClr.getFlow1Name();
        //system.assertNotEquals(null,flowName);
       // Test.stopTest();
        }
        
    }
    
    static testMethod void getRecordTypePageTest()
    {
       cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
        rt.developerName='Abandoned_Vehicle';
        PageReference page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Illegal_Dumping';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Rubbish_Collection';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Street_Light_Outage';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Graffiti';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Information_Request';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Directory_Assistance_IR';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Miscellaneous';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Support_Case';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Abandoned_Bike';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Construction_Site_Task_Force';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Dead_Animal_in_Street';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
        rt.developerName='Traffic_Signal_Emergency';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        rt.developerName='Alley_Light_Outage';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        rt.developerName='Building_Construction';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        rt.developerName='Complaint_Streets';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Line_Striping';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Sanitation_Dumpster_Violation';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Newsstand_Outdoor_Cafe';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Manhole_Cover';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Traffic_Other';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Street_Paving';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Hydrant_Knocked_Down_No_Water';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Vacant_Lot_Clean_Up';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
        
         rt.developerName='Complaints_Against_Fire_or_EMS';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
         
        rt.developerName='Smoke_Detector';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
         
          rt.developerName='Street_Trees';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
         
          rt.developerName='Shoveling';
        page=editClr.getRecordTypePage(rt);
        system.assertNotEquals(null,page);
         
         rt.developerName='Salting';
        page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Other_Streets';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Stop_Sign_Repair';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Street_Defect';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Zoning_Residential';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Vacant_House_or_Commercial';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Tree_Dangerous';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);
rt.developerName='Daycare_Residential_or_Commercial';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Boarding_Room_House';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Maintenance_Residential_or_Commercial';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Building_Dangerous';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Zoning_Business';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Other_Dangerous';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Fire_Residential_or_Commercial';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='License_Residential';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Infestation_Residential';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='No_Heat_Residential';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Emergency_Air_Conditioning';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Traffic_Signal_Emergency';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Police_Complaint';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Parks_and_Rec_Safety_and_Maintenance';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Inlet_Cleaning';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);

rt.developerName='Dangerous_Sidewalk';
page=editClr.getRecordTypePage(rt);
system.assertNotEquals(null,page);
         
    }
    static testMethod void addAccAndContactNameTest() {
        Contact c = new Contact(LastName = 'Test Contact',Email = 'test@philly311.com');
        insert c;
        cse=New Case(Type='Service Request Type',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,street__c='xyz',Department__c='Streets Department',Case_record_type__c='Abandoned Bike',Service_Request_Type__c='Abandoned Bike',Missing_Damaged_Parts__c='Yes',Time_Locked_in_Same_Location__c='More Than One Month',contactid=c.id,Unusable__c='Yes',Tagged_With_Yellow_Alert_Notice__c='No',Translator_Required__c='No',Description='Test',subject='Abandoned Bike',origin='Email');
        insert cse;
        
        RecordType rt1 = [select developerName,id from recordtype where developerName ='Abandoned_Bike'];
        cse.RecordTypeId=rt1.Id;
        Case cse1 = [select Type,Department__c,Case_record_type__c,Service_Request_Type__c,Unusable__c,subject,origin,RecordTypeId,Tagged_With_Yellow_Alert_Notice__c,contactId from case where id =: cse.id];
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse1);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        editClr.rt=rt1;
        editClr.contactChange();
        editClr.addAcc();
        
    
    }
    
    static testMethod void getSrnameTest()
    {
        list<SelectOption> option = new List<SelectOption>();
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
       // Case cs=[SELECT RecordTypeId FROM Case where case_record_type__c='Information Request' LIMIT 1];
        RecordType rt1 = [select developerName,id from recordtype where developerName ='Abandoned_Bike'];
        cse.RecordTypeId=rt1.Id;
       // cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
        rt.developerName='Abandoned_Vehicle';
        option=editClr.getSrname();
        system.assertNotEquals(0,option.size());
        editClr.CustomSave();
        String id=cse.id;
        String objectName='Case';
        X311CaseEditClrExt.getCreatableFieldsSOQL(objectName, cse.id);
        
        editClr.srtChange();
        editClr.redir();
        
    }
    
    @isTest(seeAllData=true)
    static void CaseRecordTypeChangeTest()
    {
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        for(Case cs:[SELECT RecordTypeId FROM Case LIMIT 10])
        {
        cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
        rt.developerName='Abandoned_Vehicle';
        PageReference page=editClr.CaseRecordTypeChange();
        system.assertNotEquals(null,page);
       
        
        
        }
    }
        
    static testMethod void pageMethodTest()
        {
            cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        for(Case cs:[SELECT RecordTypeId FROM Case LIMIT 1])
        {
        cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        RecordType rt=new RecordType();
        rt.developerName='Abandoned_Vehicle';
       
        PageReference page1=editClr.EmergencyTransfer();
        PageReference  page2=editClr.Emergency();
        PageReference page3=editClr.SaveAndCaseCreatedinNovo();
        PageReference page4=editClr.CloseCase();
        PageReference page5=editClr.SaveAndServiceNotNeededLI06();
        PageReference page6=editClr.SaveAndServiceNotNeeded();
        PageReference page7=editClr.SaveNewRedressCase();
        PageReference page8=editClr.redressStatusSet();
        PageReference page9=editClr.SaveAndServiceNotNeeded1();
        PageReference page10=editClr.SaveAndClose();
        PageReference page11=editClr.SaveAndClose1();
        
        integer getDate=editClr.getDate();
        integer getDate1=editClr.getDate1();
        editClr.SaveAndServiceNotNeededCaseOpened();
        }
        
    }
    static testMethod void redressTest()
    {
        cse=New Case(Type='Service Request Type',Department__c='Streets Department',Case_record_type__c='Information Request',Service_Request_Type__c='Abandoned Bike',subject='Abandoned Bike',origin='Email');
        // = new List<SelectOption>();
        insert cse;
        Case cs=[SELECT RecordTypeId FROM Case LIMIT 1];
        
        cse.RecordTypeId=cs.RecordTypeId;
        //cse.RecordTypeId ='012G00000014BWo';
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        X311CaseEditClrExt editClr=new X311CaseEditClrExt(sc);
        X311CaseEditClrExt.redress(cse.id);
    }
    
}