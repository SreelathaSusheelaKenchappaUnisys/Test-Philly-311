@isTest
//Test class for testing the trigger on cases
private class TriggerOnCasesTest{
   
    //Information Request
    static testMethod void validate1() 
    {      
       Case cas = new Case(Type='Information Request Type',Status='Closed',Subject='Test',Description='Testing using Test Class',Origin='Phone',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas;//insert case      
       test.stopTest(); 
       cas = [SELECT Id,Type,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Reason after inserting new case: '+ cas.Reason); 
       System.assertEquals('Question Answered',cas.Reason); // Test that the trigger correctly updated the Fields
    }
    
    //Graffiti Removal 
    static testMethod void validate2() 
    {      
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Graffiti Removal',Floor__c='3rd or above',Property_Type__c='Pole',Property_Owner__c='Yes',Rail_Corridor__c='No',Powerwash__c='Yes',Surface_Type__c='Brick',Painted_Surface__c='No',Subject='Test',Origin='Phone',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas; //insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Closed',cas.Status);// Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
     //Graffiti Removal  
    static testMethod void validate2b() 
    {      
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Graffiti Removal',Floor__c='3rd or above',Property_Type__c='Pole',Property_Owner__c='No',Rail_Corridor__c='Yes',Powerwash__c='Yes',Surface_Type__c='Brick',Painted_Surface__c='No',Subject='Test',Origin='Phone',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas; //insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Closed',cas.Status);// Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
     //Graffiti Removal  
    static testMethod void validate2c() 
    {      
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Graffiti Removal',Floor__c='3rd or above',Property_Type__c='Pole',Property_Owner__c='No',Rail_Corridor__c='No',Powerwash__c='Yes',Surface_Type__c='Brick',Painted_Surface__c='No',Center_City_District__c='In',Subject='Test',Origin='Phone',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas; //insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Closed',cas.Status);// Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Illegal Dumping 
    static testMethod void validate3() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Illegal Dumping',Is_Trash_on_Street_or_Sidewalk__c='No',Type_of_Materials__c='Construction Materials',Is_Trash_on_Vacant_Lot__c='No',Condition_of_Materials__c='Bagged',Trash_Include_Commercial_Hazardous_Waste__c='Yes',Trash_Include_Household_Hazardous_Waste__c='No',Origin='Phone',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas;//insert case   
       test.stopTest();    
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);
     //  System.assertEquals('Closed',cas.Status); // Test that the trigger correctly updated the Fields
      // System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Abandoned Vehicle  
    static testMethod void validate4() 
    {      
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes();
       Case cas = new Case(Department__c='Police Department',Case_Record_Type__c ='Abandoned Vehicle',Is_there_a_busted_steering_column__c ='Yes',Origin='Phone',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas;//insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);
       System.assertEquals('Closed',cas.Status); // Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Rubbish/Recyclable Material Collection  
    static testMethod void validate5() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Rubbish/Recyclable Material Collection',Set_Out_in_Time__c ='No',Origin='Phone',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas;//insert case   
       test.stopTest();    
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);
       System.assertEquals('Closed',cas.Status); // Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Street Light Outage  
    static testMethod void validate6() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Origin='Phone',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_Illuminating_a_Street__c='Yes',Is_the_Light_in_a_Park__c='No',Is_Light_Illuminating_an_Alley__c='No',Problem_Type__c ='On During Day',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);       
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); // Test that the trigger correctly updated the Fields
    }
    
   //Street Light Outage
    static testMethod void validate7() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Is_the_Light_Illuminating_a_Street__c='Yes',Is_the_Light_in_a_Park__c='Yes',Origin='Phone',Is_the_Light_a_Traffic_Signal__c='No',Is_Light_Illuminating_an_Alley__c='No',Problem_Type__c = 'On During Day',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case 
       test.stopTest();      
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);       
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); // Test that the trigger correctly updated the Fields
    }
    
   //Street Light Outage
    static testMethod void validate8() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Is_Light_Illuminating_an_Alley__c='Yes',Is_the_Light_Illuminating_a_Street__c='Yes',Origin='Phone',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Problem_Type__c = 'On During Day',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='1200 yerkes',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case   
       test.stopTest();    
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);       
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); // Test that the trigger correctly updated the Fields
    }
    
   //Street Light Outage
    static testMethod void validate9() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Is_the_Light_Illuminating_a_Street__c='Yes',Origin='Phone',Is_Light_Illuminating_an_Alley__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Problem_Type__c = 'On During Day',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
    //Street Light Outage
     static testMethod void validate10() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Private_Property__c='Yes',Origin='Phone',Is_Light_Illuminating_an_Alley__c='Yes',Is_the_Light_Illuminating_a_Street__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Problem_Type__c = 'On During Day',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
   //Street Light Outage
    static testMethod void validate11() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Origin='Phone',Is_Light_Illuminating_an_Alley__c='No',Problem_Type__c = 'Other',Is_the_Light_Illuminating_a_Street__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Is_Light_on_Public_Property__c='No',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case    
       test.stopTest();   
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);  
       System.assertEquals('Street Light(Other)',cas.Service_Request_Type__c);  // Test that the trigger correctly updated the Fields
    }
    
    static testMethod void validate12() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Street Light Outage',Is_Light_Illuminating_an_Alley__c='No',Origin='Phone',Problem_Type__c = 'On During Day',Is_the_Light_Illuminating_a_Street__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Is_Light_on_Public_Property__c='No',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case     
       test.stopTest();  
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);  
       System.assertEquals('Street Light Outage',cas.Service_Request_Type__c);  // Test that the trigger correctly updated the Fields
    }
    
   //Street Light Outage
    static testMethod void validate13() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       PS_Fields_Mapping__c p = new PS_Fields_Mapping__c(Name='Are you the property Owner?',Field_Name__c='Are you the property Owner?',Value__c='Property_Owner__c');
       insert p;
       Required_Streets_Field__c r = new Required_Streets_Field__c(Name='Problem_Type__c',Case_Record_Type__c ='Street Light Outage',Department__c='Streets Department',Label__c='Problem Type',Required__c = TRUE,API_Name__c='Problem_Type__c');
       insert r;
       Case cas = new Case(Case_Record_Type__c ='Street Light Outage',Is_Light_Illuminating_an_Alley__c='No',Origin='Phone',Problem_Type__c = 'Bulb Hanging',Is_the_Light_Illuminating_a_Street__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Is_Light_on_Public_Property__c='No',Hazardous__c='No',Subject='Test',Description='Testing using Test Class Custom fields:',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Department__c='Streets Department',Customer_request_id__c='314145');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case      
       test.stopTest(); 
       cas = [SELECT Id,Service_Request_Type__c,Hazardous__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);  
       System.assertEquals('New',cas.Status);
       System.assertEquals('Yes',cas.Hazardous__c);  // Test that the trigger correctly updated the Fields
    }
    
   //Rubbish/Recyclable Material Collection
    static testMethod void validate14() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes();        
       Case cas = new Case(Department__c='Streets Department',Case_Record_Type__c ='Rubbish/Recyclable Material Collection',Origin='Phone',Is_Trash_in_a_Wastebasket__c ='Yes',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Reason); 
       test.startTest();
       insert cas;//insert case 
       test.stopTest();      
       cas = [SELECT Id,Service_Request_Type__c,Status FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);
       System.assertEquals('Closed',cas.Status); // Test that the trigger correctly updated the Fields
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
   //Street Light Outage
    static testMethod void validate15() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Street Light Outage',Customer_request_id__c='314145',Origin='Phone',Is_Light_Illuminating_an_Alley__c='No',Problem_Type__c = 'On During Day',Is_the_Light_Illuminating_a_Street__c='No',Is_the_Light_a_Traffic_Signal__c='No',Is_the_Light_in_a_Park__c='No',Is_Light_on_Public_Property__c='No',Hazardous__c='No',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Department__c='Streets Department');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();
       CaseComment com = new CaseComment(CommentBody='Test',ParentId=cas.id);
       insert com;     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);  
       System.assertEquals('Street Light Outage',cas.Service_Request_Type__c);  // Test that the trigger correctly updated the Fields
    }
    
    static testMethod void validate16() {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact con = new Contact(LastName='ANON',email='test@test.com');
       test.startTest();
       insert con;//insert contact 
       Case cas = new Case(ByPass_VR_WF__c=true,Department__c = 'License & Inspections',contactid=con.id,Case_Record_Type__c ='Fire Residential or Commercial',Origin='Phone',Service_Request_Type__c='Fire Residential',Customer_request_id__c='314145',Subject='Test',Description='Testing using Test Class',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Hazardous_Materials_Spill__c='No',Specific_Location_of_Fire_Code_Violation__c='Test',Residential_or_Commerical__c='Residential',Residential_Property_Type__c='House');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);  
       System.assertEquals('Fire Residential',cas.Service_Request_Type__c);  // Test that the trigger correctly updated the Fields        
    }
    
    static testMethod void validate17() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes();         
       Contact c = new Contact ( LastName = 'ANON');
       insert c;
       Case cas = new Case(contactid=c.id,ByPass_VR_WF__c=TRUE,Department__c = 'License & Inspections',Case_Record_Type__c ='Construction Site Task Force',Building_Collapsing__c ='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
        
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
    static testMethod void validate18() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact ( LastName = 'ANON'); 
       insert c; 
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Emergency Air Conditioning',Heat_Emergency__c='No',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Nursing_Personal_Care_Home_Hospital__c='No',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
    //Police Complaint
    static testMethod void validate19() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Police Complaint',Physical_or_Verbal_Abuse__c='No Abuse',Streets_Dept_Complaint__c='No',Abandoned_Vehicle_Complaint__c='No',Fire_Dept_or_EMS_Complaint__c='No',Incident_Date_and_Time__c='15 march 7 am',Officer_Breaking_Law__c='No',Follow_Up_Contact__c='No',City_of_Philadelphia_Police__c='Yes',Complaint_or_Compliment__c='Compliment',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
    //Smoke Detector
    static testMethod void validate20() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Smoke Detector',Philadelphia_Resident__c='No',New_Request__c='No',Residence_Type__c='Single Family House',Owner_Occupied_Property__c='No',Access_Provided_by_Adult__c='No',Disabilities_Language_Information__c='Test',Installation_Time__c='Test',FloorSmokeDetector__c=2,Front_or_Back__c='Back',Engine__c='Test',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
    }
    
    //Boarding Room House
    static testMethod void validate21() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact (LastName = 'ANON');
       insert c;
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,ByPass_VR_WF__c=TRUE,Case_Record_Type__c ='Boarding Room House',Rental_License__c='Yes',Zoning_Permit__c='Yes',Number_of_Unrelated_Tenants__c=2,Does_Owner_Reside_at_Property__c='No',Property_Owner_Name__c='Test',L_I_Address__c='Test',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case  
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
       Case cas2 = new Case(contactid=c.id,Department__c = 'License & Inspections',ByPass_VR_WF__c=TRUE,Service_Request_Type__c='Boarding Room House',Case_Record_Type__c ='Boarding Room House',Rental_License__c='No',Zoning_Permit__c='No',Number_of_Unrelated_Tenants__c=2,Does_Owner_Reside_at_Property__c='No',Property_Owner_Name__c='Test',L_I_Address__c='Test',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       insert cas2; 
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.assertEquals('Boarding Room House',cas2.Service_Request_Type__c); 
       test.stopTest();     
    }
    
    //Building construction
    static testMethod void validate22() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes();
       Contact c = new Contact (LastName = 'ANON'); 
       insert c; 
       Case cas = new Case(ByPass_VR_WF__c=TRUE,Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Building Construction',Description='test',Fence_Height_Feet__c='4',Fence_Location__c='Front',Type_of_Work_Being_Done__c='Zoning',Fence_Paved_Area_or_Shed__c='Fence',Valid_Permit__c='Unsure',Unsafe_Conditions__c='No',Where_is_Work_Being_Done__c='test',Day_of_Week_Work_Being_Done__c='test',L_I_District__c='Test',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case  
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c); 
       cas.Fence_Height_Feet__c='5';
       cas.Type_of_Work_Being_Done__c='Building';      
       update cas;//update case 
       cas.Type_of_Work_Being_Done__c='Plumbing';
       update cas;//update case      
       cas.Type_of_Work_Being_Done__c='Electrical';
       cas.Sparking_Wires_or_Illegal_Hookups__c = 'No';
       update cas;//update case   
       cas.Type_of_Work_Being_Done__c='Zoning';
       update cas;//update case  
       test.stopTest();     
    }
    
    //Sanitation / Dumpster Violation
    static testMethod void validate23() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Sanitation / Dumpster Violation',ByPass_VR_WF__c=True,Is_Trash_on_Curb_Now__c='No',Violation_Type__c='Sanitation',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Inlet Cleaning
    static testMethod void validate24() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Water Department (PWD)',Case_Record_Type__c ='Inlet Cleaning',Heavy_Rain__c='Yes',Subject='Test',Origin='Phone',ByPass_VR_WF__c=True,Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Salting
    static testMethod void validate25() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Salting',Problem_Type__c='Icy Road Surface',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Icy Road Surface',cas.Service_Request_Type__c);
       cas.Problem_Type__c = 'Snow Removal';
       cas.Service_Request_Type__c='Snow Removal';
       update cas;
       System.assertEquals('Snow Removal',cas.Service_Request_Type__c);        
       test.stopTest();     
    }
    
    //Traffic Signal Emergency
    static testMethod void validate26() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Traffic Signal Emergency',Request_for_New_Traffic_Signal__c='Yes',Subject='Test',Origin='Phone',ByPass_VR_WF__c=True,Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
       cas.Service_Request_Type__c = 'Traffic (Other)';
       cas.Signal_Type__c= 'Signal Other';
       cas.Request_for_New_Traffic_Signal__c = 'No';
       cas.Request_to_Modify_Traffic_Signal_Operati__c='No';
       cas.Blocked_by_Tree_Branches_or_Foliage__c='No';
       cas.Problem_Type__c='All Out';
       update cas;
       System.assertEquals('Traffic (Other)',cas.Service_Request_Type__c);        
       test.stopTest();     
    }
    
     //Street Trees
    static testMethod void validate27() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Street Trees',ByPass_VR_WF__c=True,Tree_in_Alley_Frontyard_or_Backyard__c='Yes',Property_Owner_Street_Trees__c='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
     //Street Paving
    static testMethod void validate28() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Street Paving',ByPass_VR_WF__c=True,Resurfacing_Request__c='No',Resurfacing_defect__c='No',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Stop Sign Repair
    static testMethod void validate29() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Stop Sign Repair',ByPass_VR_WF__c=True,Not_Visible__c='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Newsstand Outdoor Cafe
    static testMethod void validate30() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Department__c = 'Streets Department',Case_Record_Type__c ='Newsstand Outdoor Cafe',ByPass_VR_WF__c=True,On_the_City_s_Public_Right_Of_Way__c='No',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case  
       test.stopTest();     
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
    }
    
    //Infestation Residential and License Residential
    static testMethod void validate31() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact ( LastName = 'ANON');
       insert c; 
       Case cas = new Case(Department__c='License & Inspections',contactid=c.id,Case_Record_Type__c ='Infestation Residential',ByPass_VR_WF__c=True,Residential_or_Commerical__c='Commercial',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
       Case cas2 = new Case(Case_Record_Type__c ='License Residential',ByPass_VR_WF__c=True,License_to_Rent__c='Yes',Zoning_Permit__c='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213);
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.debug('Status after inserting new case: '+ cas2.Status);     
       System.assertEquals('Service Not Needed',cas2.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas2.Status);  
       System.assertEquals('Service Not Needed',cas2.Service_Request_Type__c); 
       test.stopTest();     
   
    }
    
    //Other Dangerous and Tree Dangerous
    static testMethod void validate32() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact (LastName = 'ANON'); 
       insert c;//insert contact
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Other Dangerous',Structure_Collapsing__c='Yes',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
       Case cas2 = new Case(contactid=c.id,Department__c = 'License & Inspections',Case_Record_Type__c ='Tree Dangerous',ByPass_VR_WF__c=True,Tree_on_Power_Lines_No_Smoke_Fire__c='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345'); 
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.assertEquals('Service Not Needed',cas2.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas2.Status);  
       System.assertEquals('Service Not Needed',cas2.Service_Request_Type__c);
       test.stopTest();     
       
    }
    
    
     //Maintenance Residential or Commercial and No Heat Residential
    static testMethod void validate33() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact ( LastName = 'ANON'); 
       insert c;//insert contact
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Maintenance Residential or Commercial',Residential_or_Commerical__c='Residential',Drainage_Problem__c='Yes',Flooded_Residential_Basement__c='Yes',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status);     
       System.assertEquals('Service Not Needed',cas.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas.Status);  
       System.assertEquals('Maintenance Residential',cas.Service_Request_Type__c);
       Case cas2 = new Case(contactid=c.id,Department__c = 'License & Inspections',Case_Record_Type__c ='No Heat (Residential)',ByPass_VR_WF__c=True,Residential_or_Commerical__c='Commercial',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345'); 
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.assertEquals('Service Not Needed',cas2.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas2.Status);  
       System.assertEquals('Service Not Needed',cas2.Service_Request_Type__c);
       test.stopTest();     
       
    }    
    
    //Vacant House or Commercial and Zoning Business
    static testMethod void validate34() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact (LastName = 'ANON'); 
       insert c;//insert contact
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Vacant House or Commercial',Residential_or_Commerical__c='Residential',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Residential_or_Commerical__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.assertEquals('Vacant House',cas.Service_Request_Type__c);
       cas.Residential_or_Commerical__c='Commercial';
       update cas;
       Case casUp=[SELECT Id,Service_Request_Type__c,Residential_or_Commerical__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.assertEquals('Vacant Commercial',casUp.Service_Request_Type__c);
       Case cas2 = new Case(contactid=c.id,Department__c = 'License & Inspections',Case_Record_Type__c ='Zoning Business',ByPass_VR_WF__c=True,Sign_on_Street_Pole_Median_or_Curb__c='Yes',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345'); 
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.assertEquals('Service Not Needed',cas2.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas2.Status);  
       System.assertEquals('Service Not Needed',cas2.Service_Request_Type__c);
       test.stopTest();     
       
    }  
    
    //Parks Recreation safety and Maintenance and Street Defect
    static testMethod void validate35() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact ( LastName = 'ANON'); 
       insert c;//insert contact
       Case cas = new Case(Department__c = 'Streets Department',contactid=c.id,Case_Record_Type__c ='Street Defect',Running_Water__c='Yes',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.assertEquals('Service Not Needed',cas.Service_Request_Type__c);
       cas.Running_Water__c='No';
       cas.Crack_in_Street_Depression_or_a_Hole_i__c='Depression';
       update cas;
       Case casUp =[SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id]; 
       System.assertEquals('Depression',casUp.Service_Request_Type__c);      
       Case cas2 = new Case(Department__c = 'Parks & Recreation',Case_Record_Type__c ='Parks and Rec Safety and Maintenance',ByPass_VR_WF__c=True,Reported_to_911__c='No',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345'); 
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];
       System.assertEquals('Service Not Needed',cas2.Reason); // Test that the trigger correctly updated the Fields
       System.assertEquals('Closed',cas2.Status);  
       System.assertEquals('Emergency',cas2.Service_Request_Type__c);
       test.stopTest();     
       
    }    
    
    //Building Dangerous and Zoning Residential
    static testMethod void validate36() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Contact c = new Contact ( LastName = 'ANON'); 
       insert c;//insert contact
       Case cas = new Case(Department__c = 'License & Inspections',contactid=c.id,Case_Record_Type__c ='Building Dangerous',Building_Collapsing__c='No',Under_Construction_or_Demolition__c='No',Emergency_Repairs_for_Facade__c='No',Location_of_Dangerous_Condition__c='Exterior',Vacant_or_Occupied__c='Vacant',Residential_or_Commerical__c='Residential',L_I_District__c='test',L_I_Address__c='test',House_or_Apartment_Complex__c='House',Single_or_Multi_Family__c='Single',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345',Description='Custom Fields: Is the building occupied or vacant?: Occupied What is the dangerous condition?: dangerous condition Where is the dangerous condition located on the property?: rear Your Name & Contact Number: Saurav & +918861516144');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       Case cas2 = new Case(contactid=c.id,Department__c = 'License & Inspections',Case_Record_Type__c ='Zoning Residential',Property_Type_multi__c='Duplex',Owner_Occupied__c='No',L_I_District__c='test',L_I_Address__c='test',ByPass_VR_WF__c=True,Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Centerline_2272x__c=123.123,Centerline_2272y__c=213.213,Customer_Request_Id__c='12345'); 
       insert cas2;
       cas2 = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas2.Id];     
       test.stopTest();    
     
     }
    
    
    static testMethod void validateStreet1() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Case_Record_Type__c ='Salting',Problem_Type__c='Icy Road Surface',Subject='Test',Origin='Phone',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Description='Test',Department__c='Streets Department',Type='Service Request Type');
       System.debug('Reason before inserting new case: ' + cas.Service_Request_Type__c); 
       test.startTest();
       insert cas;//insert case 
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       System.debug('Status after inserting new case: '+ cas.Status); 
       System.assertEquals('Icy Road Surface',cas.Service_Request_Type__c);
       cas.Problem_Type__c = 'Snow Removal';
       cas.Service_Request_Type__c='Snow Removal';
       cas.Streets_Request_Id__c = '1234';
       cas.Status = 'Open';
       update cas;
       System.assertEquals('Snow Removal',cas.Service_Request_Type__c);         
       cas.Status = 'New';
       update cas;
       cas.Status = 'In-Progress';
       update cas;
       cas.Status = 'Open';
       update cas; 
       cas.Status = 'Closed';
       update cas;
       cas.Status = 'In-Progress';
       update cas;        
       test.stopTest();     
    }
    
    static testMethod void sample() 
    {            
       GISMock.Bootstrap(); 
       GISMock.SetAnswer1200Yerkes(); 
       Case cas = new Case(Type='Information Request Type',Status='In-Progress',Street__c='21 N Juniper st',Customer_Declined__c=true,Translator_Required__c='No',Origin='Phone',Subject='Test',Description='Testing using Test Class');
       test.startTest();
       insert cas;//insert case       
       test.stopTest();
       cas = [SELECT Id,Service_Request_Type__c,Status,Reason FROM Case WHERE Id =:cas.Id];
       cas.Status='New';
       update cas;
    }
    
    static testMethod void closeChildCase() {
        //GISMock.Bootstrap();
        
        XedeTestData testData = new XedeTestData('GISTestData');

        Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
            testData.find('Address1'), 
            testData.find('Topic1'),
            testData.find('ServiceAreasCourtyard'),
            testData.find('Projection1'),
            testData.find('YerkesAddress'), 
            testData.find('YerkesTopics'), 
            testData.find('YerkesServiceAreas'),
            testData.find('YerkesProject')
        }));
        
        RecordType rt = [ select id, name, developerName from RecordType where developerName = 'Miscellaneous' limit 1 ];
        
        Case aParentCase = new Case(
            Street__c = '1234 Parent Street',
            Description = 'Parent Case',
            Customer_Declined__c=true,
            Translator_Required__c='No',
            Subject = 'Parent Subject',
            Origin='Phone',
            RecordTypeId = rt.Id
        );
        
        test.startTest();
        insert aParentCase;
        
        Case aChildCase = new Case(
            Street__c = '1234 Child Street',
            Description = 'Child Case',
            Subject = 'Child Subject',
            Origin='Phone',
            Customer_Declined__c=true,
            Translator_Required__c='No',
            ParentId = aParentCase.id,
            RecordTypeId = rt.Id
        );
        
        insert aChildCase;
        
        test.stopTest();
        
        Case aCase = [ select id, status from case where id = :aChildCase.id ];
        system.assertEquals('Closed', aCase.status);
    }
}