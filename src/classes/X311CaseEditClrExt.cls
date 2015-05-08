/* This is the main controller class that is responsible for flip functionality
 * dynamic change of scripts, contact lookup, updation of zipcode 
 * based on contact selected
 */

global without sharing class X311CaseEditClrExt {
    ApexPages.StandardController stdController=null;
    public Case cs=null;
    public case cs1;
    public boolean flag{get;set;}
    public PageReference pr1;

    //For contact look up
    public Contact contact {get;set;}
    public Case ca {get;set;} 
    //For contact look up

    public String rtDevName { get; set; }
    public RecordType rt { get; set; }
    public Boolean sendEmailNotification { get; set; }
    public String Comment { get; set; }

    /* The extension constructor initializes the private member
       variable acct by using the getRecord method from the standard
       controller.*/
    public X311CaseEditClrExt(ApexPages.StandardController pstdController) {
        stdController=pstdController;
        cs=(Case) stdController.getRecord();
        //system.debug('contact id in controller'+cs.contactID);
        String sub = ApexPages.currentPage().getParameters().get('cas14');
        String dirId = ApexPages.currentPage().getParameters().get('dirId');
        String dirSR = ApexPages.currentPage().getParameters().get('dirSR');

        if(dirSR != null && dirSR.equals('Directory Assistance - IR'))
            cs.Service_Request_Type__c = 'Directory Assistance - IR';
        if(sub != null && sub != 'Support Case') 
            cs.Subject = sub;
        else  {  
            //  Case cs1 = [Select id, Subject from Case where id =: cs.id];
            if( cs.RecordTypeId != null && cs.id == null)    {
                RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
                System.debug(cs.RecordTypeId);
                if(rd.name != 'Support Case')
                cs.Subject = rd.Name;  
            }
        }  
        if(dirId != null)    {

            Directory__c d = [Select Name, Bold__c, Department__c, DepartmentCode__c, 
                              FirstName__c, LastName__c, Location__c, Phone__c,
                              Title__c, Unit__c, UnitCode__c from Directory__c where id =: dirId];        
            if(d != null)    {
                cs.Name_DirectoryAssistance__c = d.Name;
                cs.First_Name__c = d.FirstName__c;
                cs.Last_Name__c = d.LastName__c;
                cs.Department_Directory_Assistance__c = d.Department__c;
                cs.Location_Directory__c = d.Location__c;
                cs.Department_Code__c = d.DepartmentCode__c;
                cs.Unit__c = d.Unit__c;
                cs.Phone__c = d.Phone__c;
                cs.Unit_Code__c = d.UnitCode__c;
                cs.Bold__c = d.Bold__c;
                cs.Title__c = d.Title__c;
            }  
        }      
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];

        if((PROFILE.get(0).name == 'Partner User') ||(PROFILE.get(0).name == 'City Department Heads')||(PROFILE.get(0).name == 'Partner User')||(PROFILE.get(0).name == 'Partner User')||(PROFILE.get(0).name == 'Partner User')||(PROFILE.get(0).name == 'Partner User')||(PROFILE.get(0).name == 'Partner User')|| (PROFILE.get(0).name == 'Customer community')|| (PROFILE.get(0).name == 'Customer Community Login User')||(PROFILE.get(0).name == 'Department WOM (Field Worker) User')||(PROFILE.get(0).name == 'Neighborhood Liaison')||(PROFILE.get(0).name == 'Police Department Users2')||(PROFILE.get(0).name == 'City Council')||(PROFILE.get(0).name == 'State Reps')||(PROFILE.get(0).name == 'Various Civic City Groups, Kensignton CDC, Northern Liberties CDC')||(PROFILE.get(0).name == 'City Department Heads')||(PROFILE.get(0).name == 'Neighborhood Liaisons1')) {
            flag=true; 
        }
        else
            flag=false;

        //For contact lookup
        contact = new Contact();        
    }

    public boolean getrecordtypeinfo(){     
        if( cs.RecordTypeId != null && cs.id == null)    {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if((rd.name == 'Information Request')||(rd.name == 'Directory Assistance'))
                return false;
        }
        else if(cs.id != null && (cs.Case_Record_Type__c == 'Information Request' || cs.Case_Record_Type__c == 'Directory Assistance'))
            return false;

        return true;
    }

    public boolean getsrtypeinfo(){     
        String dirSR = ApexPages.currentPage().getParameters().get('dirSR');
        if( dirSR != null && dirSR == 'Directory Assistance - IR')   
            return true;
        return false;
    }
    public boolean getrecordtypeinfoInformationRequest(){     
        if( cs.RecordTypeId != null )    {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if(rd.name == 'Information Request'){
                return true;
            }

        }
        return false;
    }
    public boolean getrecordtypeinfoNotInformationRequest(){     
        if( cs.RecordTypeId != null )    {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if(rd.name != 'Information Request'){
                return true;
            }

        }
        return false;
    }

    public boolean getrecordtypeinfo1(){     
        if( cs.RecordTypeId != null && cs.id == null)    {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if((rd.name == 'Complaints Against Fire or EMS'))
                return true;
        }
        else if(cs.Case_Record_Type__c == 'Complaints Against Fire or EMS' && cs.id != null)
            return true;
        return false;
    }

    public boolean getrecordtypeinfo2(){     
        if( cs.RecordTypeId != null && cs.id == null)    {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if((rd.name == 'Smoke Detector'))
                return true;
        }
        else if(cs.Case_Record_Type__c == 'Smoke Detector' && cs.id != null)
            return true;
        return false;
    }  

    public List<selectOption> getStatus() {

        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('New', 'New'));
        options.add(new selectOption('Open', 'Open')); 
        options.add(new selectOption('In-Progress', 'In-Progress')); 

        return options;
    }


    public List<selectOption> getStatusname() {

        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if(cs.Status == 'New'){
            options.add(new selectOption('Request created and submitted to servicing department', 'Request created and submitted to servicing department'));
            options.add(new selectOption('Customer reported issue closed and not resolved (Redress) ', 'Customer reported issue closed and not resolved (Redress)')); 
        }
        else if(cs.Status == 'Open'){
            options.add(new selectOption('Request has been received by servicing department ', 'Request has been received by servicing department'));

        }
        else if(cs.Status == 'In-Progress'){
            options.add(new selectOption('Investigation Conducted', 'Investigation Conducted'));
            options.add(new selectOption('Follow up investigation is scheduled', 'Follow up investigation is scheduled'));
            options.add(new selectOption('Assistance is required from another source', 'Assistance is required from another source'));
            options.add(new selectOption('Case assigned to another servicing department', 'Case assigned to another servicing department'));

        }

        return options;
    }

    /****** Partner Pages Integration Code ***********************/

    public boolean getuserinfo(){

        boolean Portal = false;
        User u = [select IsPortalEnabled from User where id =: Userinfo.getuserId()];
        Portal = u.IsPortalEnabled ;
        return Portal;
    }
    public String getuserinfo1(){

        String Portal1 = '';
        User u = [Select UserType from User where Name =: Userinfo.getName()];
        Portal1 = u.UserType ;
        return Portal1;
    }
    public list<selectOption> getSrname(){
        list<SelectOption> option = new List<SelectOption>();
        String  idOrName =  (cs.RecordTypeId);  
        System.debug('Case Record Type: '+ idOrName);    
        List<RecordType> lstRT=[SELECT Id, DeveloperName, Name FROM RecordType WHERE Id=:idOrName OR Name LIKE :(idOrName + '%') OR DeveloperName = :idOrName];
        RecordType rt=null;
        if (lstRT.size()>0) {
            rt=lstRT[0];
        }
        if (rt.DeveloperName=='Abandoned_Vehicle') {
            option = getAbandonedServiceReq();
        } else if (rt.DeveloperName=='Illegal_Dumping') {
            option = getIllegalServiceReq();
        } else if (rt.DeveloperName=='Rubbish_Collection') {
            option = getRubbishRecyclableServiceReq();
        } else if (rt.DeveloperName=='Tree_Dangerous') {
            option = getTreeDangerousServiceReq();
        } else if (rt.DeveloperName=='Street_Light_Outage') {
            option = getStreetServiceReq();
        } else if (rt.DeveloperName=='Graffiti') {
            option = getGraffitiServiceReq();
        } else if (rt.DeveloperName=='No_Heat_Residential') {
            option = getNoHeatServiceReq();
        } else if (rt.DeveloperName=='Boarding_Room_House') {
            option = getBoardingRoomReq();
        } else if (rt.DeveloperName=='Other_Dangerous') {
            option = getOtherDangerous();
        } else if (rt.DeveloperName=='Daycare_Residential_or_Commercial') {
            option = getDayCareReq();
        } else if (rt.DeveloperName=='Emergency_Air_Conditioning') {
            option = getEmergencyAirReq();
        } else if (rt.DeveloperName=='Fire_Residential_or_Commercial') {
            option = getFireResidentialReq();
        } else if (rt.DeveloperName=='Infestation_Residential') {
            option = getInfestationResidential();
        } else if (rt.DeveloperName=='License_Residential') {
            option = getLicenseResidentialReq();
        } else if (rt.DeveloperName=='Maintenance_Residential_or_Commercial') {
            option = getMaintenanceResidentialReq();
        } else if (rt.DeveloperName=='Vacant_House_or_Commercial') {
            option = getVacantHouse();
        } else if (rt.DeveloperName=='Zoning_Residential') {
            option = getZoningResidentialReq();
        } else if (rt.DeveloperName=='Zoning_Business') {
            option = getZoningBusinessReq();
        } else if (rt.DeveloperName=='Construction_Site_Task_Force') {
            option = getConstructionSiteTaskForceReq();
        } else if (rt.DeveloperName=='Building_Dangerous') {
            option = getBuidingDangereousReq();
        } else if (rt.DeveloperName=='Building_Construction') {
            option = getBuildingConstruction();
        } else if (rt.DeveloperName=='Dangerous_Sidewalk') {
            option = getDangerousSidewalk();
        } else if (rt.DeveloperName=='Abandoned_Bike') {
            option = getAbandonedBike();
        } else if (rt.DeveloperName=='Dead_Animal_in_Street') {
            option = getDeadAnimal();
        } else if (rt.DeveloperName=='Sanitation_Dumpster_Violation') {
            option = getSanitationDumpster();
        } else if (rt.DeveloperName=='Line_Striping') {
            option = getLineStriping();
        } else if (rt.DeveloperName=='Manhole_Cover') {
            option = getManhole();
        } else if (rt.DeveloperName=='Newsstand_Outdoor_Cafe') {
            option = getNewsstand();
        } else if (rt.DeveloperName=='Other_Streets') {         
            option = getOtherStreets();
        } else if (rt.DeveloperName=='Salting') {         
            option = getSalting();
        } else if (rt.DeveloperName=='Shoveling') {         
            option = getShoveling();
        } else if (rt.DeveloperName=='Stop_Sign_Repair') {         
            option = getStopSign();
        } else if (rt.DeveloperName=='Smoke_Detector') {
            option = getSmokeDetector();
        } else if (rt.DeveloperName=='Street_Paving') {         
            option = getStreetPaving();
        }  else if (rt.DeveloperName=='Traffic_Other') {         
            option = getTrafficOther();
        } else if (rt.DeveloperName=='Traffic_Signal_Emergency') {         
            option = getTrafficSignalEmergency();
        } else if (rt.DeveloperName=='Alley_Light_Outage') {         
            option = getAlleyLightOutage();
        } else if (rt.DeveloperName=='Complaint_Streets') {         
            option = getComplaintStreets();
        } else if (rt.DeveloperName=='Street_Defect') {         
            option = getStreetDefect();
        } else if (rt.DeveloperName=='Inlet_Cleaning') {         
            option = getInletCleaning();
        } else if (rt.DeveloperName=='Hydrant_Knocked_Down_No_Water') {         
            option = getHydrantKnockedDown();
        } else if (rt.DeveloperName=='Complaints_Against_Fire_or_EMS') {         
            option = getComplaintsagainstFire();
        } else if (rt.DeveloperName=='Police_Complaint') {         
            option = getPoliceComplaint();
        } else if (rt.DeveloperName=='Vacant_Lot_Clean_Up') {         
            option = getVacantLotCleanUp();
        } else if (rt.DeveloperName=='Street_Trees') {         
            option = getStreetTrees();
        } else if (rt.DeveloperName=='Parks_and_Rec_Safety_and_Maintenance') {         
            option = getParksandRec();
        } else if (rt.DeveloperName=='Information_Request') {
            option = getInformationServiceReq();
        } else if (rt.DeveloperName=='Miscellaneous') {
            option = getMiscellaneousServiceReq();
        }         
        return option;  
    }


    /************ Partner Pages Integration Code End *************/

    public List<selectOption> getGraffitiServiceReq() {
        cs.Type = 'Service Request Type';
        // Department Name Change from "Neighborhood Services" to "Community Life Improvement Program"
        cs.Department__c = 'Community Life Improvement Program';
        cs.Case_Record_Type__c = 'Graffiti Removal';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Graffiti Removal', 'Graffiti Removal'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    } 

    public List<selectOption> getTreeDangerousServiceReq()  {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Tree Dangerous';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Tree Dangerous', 'Tree Dangerous'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;        
    }
    
    
    
    public List<selectOption> getIllegalServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Illegal Dumping';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Illegal Dumping', 'Illegal Dumping'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed')); 
           
        return options;
    } 

    public List<selectOption> getAbandonedServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Police Department';
        cs.Case_Record_Type__c = 'Abandoned Vehicle';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Abandoned Vehicle', 'Abandoned Vehicle'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    /******* L & I SR Type Picklist code for Partner Pages Start *****/

    public List<selectOption> getNoHeatServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'No Heat Residential';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('No Heat Residential', 'No Heat Residential'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getBoardingRoomReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Boarding Room House';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Boarding Room House', 'Boarding Room House'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }
    
    public List<selectOption> getOtherDangerous()  {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Other Dangerous';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Other Dangerous', 'Other Dangerous'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;        
    }

    public List<selectOption> getBuidingDangereousReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Building Dangerous';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        /* Commenting for support ticket fix 09009915        
        options.add(new selectOption('Building Dangerous Historical', 'Building Dangerous Historical')); */
        options.add(new selectOption('Building Dangerous Occupied', 'Building Dangerous Occupied')); 
        options.add(new selectOption('Building Dangerous Vacant', 'Building Dangerous Vacant')); 
        options.add(new selectOption('Emergency Façade Repair', 'Emergency Façade Repair'));         
        options.add(new selectOption('Emergency Transfer', 'Emergency Transfer'));   
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getDayCareReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Daycare Residential or Commercial';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Daycare Commercial', 'Daycare Commercial'));
        options.add(new selectOption('Daycare Residential', 'Daycare Residential')); 
        options.add(new selectOption('Service Not Needed', 'Service Not Needed')); 
        return options;
    }

    public List<selectOption> getFireResidentialReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Fire Residential or Commercial';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Fire Commercial', 'Fire Commercial'));
        options.add(new selectOption('Fire Residential', 'Fire Residential'));
         options.add(new selectOption('Emergency Transfer', 'Emergency Transfer')); 
        options.add(new selectOption('Service Not Needed', 'Service Not Needed')); 
        return options;
    }

    public List<selectOption> getLicenseResidentialReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'License Residential';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('License Residential', 'License Residential'));        
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getMaintenanceResidentialReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Maintenance Residential or Commercial';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Maintenance Residential', 'Maintenance Residential'));
        options.add(new selectOption('Maintenance Commercial', 'Maintenance Commercial'));      
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getEmergencyAirReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Emergency Air Conditioning';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Emergency Air Conditioning', 'Emergency Air Conditioning'));  
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getZoningBusinessReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Zoning Business';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Zoning Business', 'Zoning Business'));    
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getZoningResidentialReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Zoning Residential';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Zoning Residential', 'Zoning Residential'));  
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));    
        return options;
    }

    public List<selectOption> getConstructionSiteTaskForceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Construction Site Task Force';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Construction Site Task Force', 'Construction Site Task Force'));
        options.add(new selectOption('Demolition', 'Demolition'));  
        options.add(new selectOption('License Contractor', 'License Contractor'));  
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getInfestationResidential() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Infestation Residential';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Infestation Residential', 'Infestation Residential'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getVacantHouse() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Vacant House or Commercial';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Vacant House', 'Vacant House'));
        options.add(new selectOption('Vacant Commercial', 'Vacant Commercial'));    
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getBuildingConstruction() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'License & Inspections';
        cs.Case_Record_Type__c = 'Building Construction';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Building Construction', 'Building Construction'));
        options.add(new selectOption('Electrical Construction', 'Electrical Construction'));
        options.add(new selectOption('Plumbing Construction', 'Plumbing Construction'));
        options.add(new selectOption('Zoning Construction', 'Zoning Construction'));

        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    /******* L & I SR Type Picklist code for Partner Pages End *****/

    /******* Streets Department SR Type Picklist code for Partner Pages Start *****/ 

    public List<selectOption> getDangerousSidewalk() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Dangerous Sidewalk';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Dangerous Sidewalk', 'Dangerous Sidewalk'));
        options.add(new selectOption('ADA Curb Ramp', 'ADA Curb Ramp'));    
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getAbandonedBike() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Abandoned Bike';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Abandoned Bike', 'Abandoned Bike'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getDeadAnimal() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Dead Animal in Street';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Dead Animal in Street', 'Dead Animal in Street'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getSanitationDumpster() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Sanitation / Dumpster Violation';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Sanitation Violation', 'Sanitation Violation'));
        options.add(new selectOption('Dumpster Violation', 'Dumpster Violation'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getLineStriping() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Line Striping';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Line Striping', 'Line Striping'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getManhole() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Manhole Cover';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Manhole Cover Missing', 'Manhole Cover Missing'));
        options.add(new selectOption('Manhole Other Problem', 'Manhole Other Problem'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getNewsstand() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Newsstand/Outdoor Café';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Newsstand Outdoor Café', 'Newsstand Outdoor Café'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getOtherStreets() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Other (Streets)';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Other (Streets)', 'Other (Streets)'));        
        return options;
    }

    public List<selectOption> getSalting() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Salting';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Icy Road Surface', 'Icy Road Surface'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));        
         options.add(new selectOption('Snow Removal', 'Snow Removal'));  
        return options;
    }

    public List<selectOption> getShoveling() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Shoveling';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Shoveling', 'Shoveling'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getStopSign() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Stop Sign Repair';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Stop Sign Repair', 'Stop Sign Repair'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getStreetPaving() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Street Paving';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Street Paving', 'Street Paving'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getTrafficOther() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Traffic (Other)';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Traffic (Other)', 'Traffic (Other)'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getTrafficSignalEmergency() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Traffic Signal Emergency';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Traffic Signal Emergency', 'Traffic Signal Emergency'));
        options.add(new selectOption('Traffic (Other)', 'Traffic (Other)'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getAlleyLightOutage() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Alley Light Outage';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Alley Light Outage', 'Alley Light Outage'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getComplaintStreets() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Complaint (Streets)';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Complaint (Streets)', 'Complaint (Streets)'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getStreetDefect() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Street Defect';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Pothole Repair', 'Pothole Repair'));
        options.add(new selectOption('Ditch Repair', 'Ditch Repair'));
        options.add(new selectOption('Cave-In Repair', 'Cave-In Repair'));
        options.add(new selectOption('Push-Up', 'Push-Up'));
        options.add(new selectOption('Depression', 'Depression'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    /***** Water Department Service Requests *****/

    public List<selectOption> getInletCleaning() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Water Department(PWD)';
        cs.Case_Record_Type__c = 'Inlet Cleaning';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Inlet Cleaning', 'Inlet Cleaning'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getHydrantKnockedDown() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Water Department(PWD)';
        cs.Case_Record_Type__c = 'Hydrant Knocked Down (No Water)';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Hydrant Knocked Down', 'Hydrant Knocked Down'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    /**** Fire Department *****/

    public List<selectOption> getSmokeDetector() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Fire Department';
        cs.Case_Record_Type__c = 'Smoke Detector';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Smoke Detector', 'Smoke Detector'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getComplaintsagainstFire() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Fire Department';
        cs.Case_Record_Type__c = 'Complaints against Fire or EMS';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        /* Code change related to support ticket fix 09071661 start */
        //options.add(new selectOption('Complaints against Fire or EMS', 'Complaints against Fire or EMS'));
        options.add(new selectOption('Complaint against Fire or EMS', 'Complaint against Fire or EMS'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed')); 
        /* Code change related to support ticket fix 09071661 end */
        return options;
    }

    /***** Police Complaint ****/

    public List<selectOption> getPoliceComplaint() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Police Department';
        cs.Case_Record_Type__c = 'Police Complaint';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Police Complaint', 'Police Complaint'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getVacantLotCleanUp() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Community Life Improvement Program';
        cs.Case_Record_Type__c = 'Vacant Lot Clean-Up';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Vacant Lot Clean-Up', 'Vacant Lot Clean-Up'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getStreetTrees() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Parks & Recreation';
        cs.Case_Record_Type__c = 'Street Trees';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Street Trees', 'Street Trees'));
        options.add(new selectOption('Emergency Transfer', 'Emergency Transfer'));
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        return options;
    }

    public List<selectOption> getParksandRec() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Parks & Recreation';
        cs.Case_Record_Type__c = 'Parks and Rec Safety and Maintenance';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
      
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));  
        options.add(new selectOption('Mechanical Maintenance','Mechanical Maintenance'));
        options.add(new selectOption('Janitorial Maintenance','Janitorial Maintenance'));
        options.add(new selectOption('Grounds Maintenance','Grounds Maintenance'));
        options.add(new selectOption('Tree Maintenance','Tree Maintenance'));
        options.add(new selectOption('Programs', 'Programs'));
        options.add(new selectOption('Emergencies', 'Emergencies'));
        
        return options;
    }



    /******* SR Type Picklist code for Partner Pages End *****/  

    public List<selectOption> getOrigin() {

        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Communities', 'Communities'));  

        return options;
    } 

    public List<selectOption> getInformation() {

        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Information Request', 'Information Request'));  

        return options;
    } 

    public List<selectOption> getServiceType() {

        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Information Request', 'Information Request'));  

        return options;
    } 

    public List<selectOption> getMiscellaneousServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = '311 Contact Center';
        cs.Case_Record_Type__c = 'Miscellaneous';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Miscellaneous', 'Miscellaneous'));    
        return options;
    }

    public List<selectOption> getInformationServiceReq() {
        cs.Type = 'Information Request Type';
        cs.Department__c = '311 Contact Center';
        cs.Case_Record_Type__c = 'Information Request';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Information Request', 'Information Request'));    
        return options;
    }

    public List<selectOption> getStreetServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Street Light Outage';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('Street Light Outage', 'Street Light Outage'));
        options.add(new selectOption('Street Light(Other)', 'Street Light(Other)'));  
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));              
        return options;
    }     

    public List<selectOption> getRubbishRecyclableServiceReq() {
        cs.Type = 'Service Request Type';
        cs.Department__c = 'Streets Department';
        cs.Case_Record_Type__c = 'Rubbish/Recyclable Material Collection';
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        options.add(new selectOption('Rubbish Collection', 'Rubbish Collection')); 
        options.add(new selectOption('Recyclables Collection', 'Recyclables Collection')); 
        options.add(new selectOption('Service Not Needed', 'Service Not Needed'));              
        return options;
    }

    public pageReference CaseRecordTypeChange() {
       
       if(cs.RecordTypeId != null) {
            RecordType rd = [Select name,id from RecordType where id =: cs.RecordTypeId];
            if(rd != null)
                cs.Case_Record_Type__c = rd.Name;
        }

        System.debug('CaseRecordType method Starts');
        System.debug('Department: ' + cs.Department__c);
        System.debug('Standard Case Record Type: ' + cs.RecordType.Name);
        System.debug('Custom Case Record Type: ' + cs.Case_Record_Type__c);
        System.debug('Custom Service Request Type: ' + cs.Service_Request_Type__c);

        // Police Department Starts
        if(cs.Case_Record_Type__c=='Police Complaint' && cs.Fire_Dept_or_EMS_Complaint__c== 'Yes') {
            cs.Case_Record_Type__c='Complaints Against Fire or EMS';
            cs.Service_Request_Type__c='Complaint Against Fire or EMS';
            cs.RecordTypeId='012J0000000DESj';
            rsChange();
            srtChange();
        } 

        else if(cs.Case_Record_Type__c=='Police Complaint' && cs.Streets_Dept_Complaint__c== 'Yes') {
            cs.Case_Record_Type__c='Complaint (Streets)'; 
            cs.Service_Request_Type__c='Complaint (Streets)';
            rsChange();
            srtChange();
        } 
        // Police Department Ends

        // Illegal Dumping Starts
        if(cs.Case_Record_Type__c=='Illegal Dumping' && cs.Trash_Include_Commercial_Hazardous_Waste__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Fire Residential or Commercial'; 
            rschange();
            srtChange();
        }
        else if(cs.Case_Record_Type__c=='Illegal Dumping' && cs.Is_Trash_on_Vacant_Lot__c== 'Yes') {
            cs.Department__c='Community Life Improvement Program';
            cs.Case_Record_Type__c='Vacant Lot Clean-Up'; 
            cs.Service_Request_Type__c='Vacant Lot Clean-Up';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        else if(cs.Case_Record_Type__c=='Illegal Dumping' && cs.Is_there_active_construction_at_the_site__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Construction Site Task Force'; 
            cs.Service_Request_Type__c='Construction Site Task Force';
            rschange();
            srtChange();
        }
        else if(cs.Case_Record_Type__c == 'Illegal Dumping' && cs.Is_Trash_on_Street_or_Sidewalk__c == 'No') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Sanitation / Dumpster Violation'; 
            cs.Service_Request_Type__c='Sanitation Violation';
            rschange();
            srtChange();
        }   
        // Illegal Dumping Ends

        if(cs.Case_Record_Type__c=='Rubbish/Recyclable Material Collection' && cs.Is_Trash_in_a_Wastebasket__c == 'Yes') {
            cs.Case_Record_Type__c='Other (Streets)'; 
            pr1 = recordTypeChange('Other (Streets)');
        }
        if(cs.Case_Record_Type__c=='Shoveling' && cs.Problem_Type__c == 'Salting or Plowing a Street') {
            cs.Case_Record_Type__c='Salting'; 
            cs.Service_Request_Type__c='Salting';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Sanitation / Dumpster Violation' && cs.Vacant_or_Abandoned_Property__c== 'Yes') {
            cs.Department__c='Community Life Improvement Program';
            cs.Case_Record_Type__c='Vacant Lot Clean-Up'; 
            cs.Service_Request_Type__c='Vacant Lot Clean-Up';

            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Sanitation / Dumpster Violation'&& (cs.Dumpster_on_Private_Property__c== 'Yes' || cs.Dumpster_Overflowing__c== 'Yes')) {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';

            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Shoveling' && cs.Snow_Ice_at_Park_or_Rec_Center__c == 'Yes') {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Parks and Rec Safety and Maintenance'; 
            cs.Service_Request_Type__c='Parks and Rec Safety and Maintenance';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        /* if(cs.Case_Record_Type__c=='Parks and Rec Safety and Maintenance' && cs.Location_Type__c== 'Other') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
           //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }*/


        //WF 2 --- Other Dangerous
        if(cs.Case_Record_Type__c=='Other Dangerous' && cs.Under_Construction_or_Demolition__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Construction Site Task Force'; 
            cs.Service_Request_Type__c='Construction Site Task Force';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }   

        if(cs.Case_Record_Type__c=='Street Light Outage' && cs.Is_the_Light_in_a_Park__c == 'Yes') {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Parks and Rec Safety and Maintenance'; 
            cs.Service_Request_Type__c='Parks and Rec Safety and Maintenance';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Inlet Cleaning' && cs.Inlet_or_Manhole__c == 'Manhole') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Manhole Cover'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Inlet Cleaning' && cs.Pothole_Cave_In_or_Ditch__c== 'Yes') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Street Defect'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Inlet Cleaning' && cs.Rear_of_Property__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Alley Light Outage' && cs.Light_Type__c== 'Street Light') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Street Light Outage'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Complaint (Streets)' && cs.Rubbish_Issue__c== 'Missed') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Rubbish/Recyclable Material Collection'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Complaint (Streets)' && cs.Rubbish_Issue__c== 'Other') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Other (Streets)'; 
            cs.Service_Request_Type__c='Other (Streets)';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Police Complaint' && cs.Fire_Dept_or_EMS_Complaint__c== 'Yes') {
            cs.Department__c='Fire Department';
            cs.Case_Record_Type__c='Complaint Against Fire or EMS'; 
            cs.Service_Request_Type__c='Complaint Against Fire or EMS';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Police Complaint' && cs.Streets_Dept_Complaint__c== 'Yes') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Complaint (Streets)'; 
            cs.Service_Request_Type__c='Complaint (Streets)';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Police Complaint' && cs.Abandoned_Vehicle_Complaint__c== 'Yes') {
            cs.Department__c='Police Department';
            cs.Case_Record_Type__c='Abandoned Vehicle'; 
            cs.Service_Request_Type__c='Abandoned Vehicle';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Vacant Lot Clean-Up' && (cs.Lot_Type__c== 'Yard'||cs.Lot_Type__c== 'Parking Lot')) {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Tree Dangerous' && (cs.Tree_Between_Sidewalk_and_Curb_TreeDange__c== 'Yes' || cs.Tree_on_Side_Street__c== 'Yes')) {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Street Trees'; 
            cs.Service_Request_Type__c='Street Trees';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Tree Dangerous' && cs.Overgrown_or_Aready_Fallen__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Tree Dangerous' && cs.Growing_in_Vacant_Building__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Building Dangerous'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Tree Dangerous' && (cs.Branches_Break_Easily__c== 'No'|| cs.Leaves_in_Spring_and_Summer__c== 'Yes' || cs.Animals_Living_in_Tree__c== 'Yes')|| cs.Dead_or_Alive_Tree__c == 'Alive') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Boarding Room House' && cs.Rental_License__c== 'No') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='License Residential'; 
            cs.Service_Request_Type__c='License Residential';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Vacant Lot Clean-Up' && cs.Lot_Type__c== 'Park') {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Parks and Rec Safety and Maintenance'; 
            cs.Service_Request_Type__c='Parks and Rec Safety and Maintenance';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Vacant Lot Clean-Up' && cs.Is_this_a_tree_issue__c== 'Yes') {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Street Trees'; 
            cs.Service_Request_Type__c='Street Trees';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        //Building construction WFs
        if(cs.Case_Record_Type__c=='Building Construction' && (cs.Valid_Permit__c== 'Yes'|| cs.Unsafe_Conditions__c=='Yes')) {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Construction Site Task Force'; 
            cs.Service_Request_Type__c='Construction Site Task Force';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Building Construction' && cs.Sparking_Wires_or_Illegal_Hookups__c== 'Yes') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Fire Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Traffic (Other)' && cs.Traffic_Signal__c == 'Yes') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Traffic Signal Emergency'; 
            rschange();
            srtChange();
            // pr1 = recordTypeChange('Traffic Signal Emergency');
        }
        if(cs.Case_Record_Type__c=='Traffic (Other)' && cs.Stop_Sign__c== 'Yes'){
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Stop Sign Repair';
            cs.Service_Request_Type__c='Stop Sign Repair';
            rsChange();
            srtChange();
            //  pr1 = recordTypeChange('Stop Sign Repair');
        }
        if(cs.Case_Record_Type__c=='Traffic (Other)' && cs.Sign_Regulating_Traffic__c== 'No'){
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Zoning Business';
            cs.Service_Request_Type__c='Zoning Business';
            // pr1 = recordTypeChange('Zoning Business');

        }


        if(cs.Case_Record_Type__c=='Other (Streets)' && ( cs.Problem_Type_Highways__c== 'Push-Up' || cs.Problem_Type_Highways__c== 'Wear Out')){
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Street Defect';
            // cs.Service_Request_Type__c='Street Defect';
            // pr1 = recordTypeChange('Zoning Business');
            rsChange();
            srtChange();

        }

        if(cs.Case_Record_Type__c=='Other (Streets)' && cs.Problem_Type_Sanitation__c == 'Leaf Collection'){
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Rubbish/Recyclable Material Collection';
            // cs.Service_Request_Type__c='Street Defect';
            // pr1 = recordTypeChange('Zoning Business');
            rsChange();
            srtChange();

        }


        if(cs.Case_Record_Type__c=='Stop Sign Repair' && (cs.Stop_Sign_Type__c== 'Street Name'|| cs.Stop_Sign_Type__c== 'One Way')){
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Traffic (Other)';
            cs.Service_Request_Type__c='Traffic (Other)';
            rsChange();
            srtChange();
            // pr1 = recordTypeChange('Zoning Business');

        }

        if(cs.Case_Record_Type__c=='Building Dangerous' && cs.Under_Construction_or_Demolition__c== 'Yes'){
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Construction Site Task Force';
            cs.Service_Request_Type__c='';
            rsChange();
            srtChange();
            // pr1 = recordTypeChange('Zoning Business');

        }
        if(cs.Case_Record_Type__c=='Parks and Rec Safety and Maintenance' && cs.Location_Type__c== 'Not Parks Related') {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Parks and Rec Safety and Maintenance' && cs.Tree_Between_Sidewalk_and_Curb__c== 'Yes') {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c='Street Trees'; 
            cs.Service_Request_Type__c='Street Trees';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }
        if(cs.Case_Record_Type__c=='Street Defect' && cs.Utility_Company__c== 'Not Known') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Other (Streets)'; 
            cs.Service_Request_Type__c='Other (Streets)';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Street Defect' && (cs.Crack_in_Street_Depression_or_a_Hole_i__c== 'Crack' || cs.Crack_in_Street_Depression_or_a_Hole_i__c== 'Depression')) {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Other (Streets)'; 
            cs.Service_Request_Type__c='Other (Streets)';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Street Trees' && cs.Sidewalk_Repair__c== 'Yes') {
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Dangerous Sidewalk'; 
            cs.Service_Request_Type__c='Dangerous Sidewalk';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Street Trees' && ((cs.Tree_in_Alley_Frontyard_or_Backyard__c== 'Yes') && (cs.Property_Owner_Street_Trees__c == 'No'))) {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c ='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting'); 
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Street Trees' && (cs.Tree_Inside_Park_or_at_Rec_Center__c == 'Yes' )) {
            cs.Department__c='Parks & Recreation';
            cs.Case_Record_Type__c ='Parks and Rec Safety and Maintenance'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting'); 
            rschange();
            srtChange();
        }


        if(cs.Case_Record_Type__c=='Graffiti Removal' &&  (cs.Floor__c== '3rd or above' && cs.Property_Owner__c== 'No' &&  (cs.Center_City_District__c == NULL || cs.Center_City_District__c== '' ))) {
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';   
            rschange();
            srtChange();
        }

        if(cs.Case_Record_Type__c=='Maintenance Residential or Commercial' &&  (cs.Problem_Location_at_House_or_Unit__c== 'Public Right of Way')){
            cs.Department__c='Streets Department';
            cs.Case_Record_Type__c='Illegal Dumping'; 
            cs.Service_Request_Type__c='Illegal Dumping';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }

        //WF implementation for Smoke detector
        if(cs.Case_Record_Type__c=='Smoke Detector' &&  (cs.Do_you_have_a_working_smoke_detector__c== 'No')){
            cs.Department__c='License & Inspections';
            cs.Case_Record_Type__c='Maintenance Residential or Commercial'; 
            cs.Service_Request_Type__c='';
            //pr1 = recordTypeChange('Salting');
            rschange();
            srtChange();
        }


        if(cs.Case_Record_Type__c=='Street Light Outage' && cs.Is_the_Light_a_Traffic_Signal__c =='Yes') {
            cs.Case_Record_Type__c= 'Traffic Signal Emergency';
            //  pr1 = recordTypeChange('Traffic Signal Emergency');
        }
        else if(cs.Case_Record_Type__c=='Street Light Outage' && cs.Is_Light_Illuminating_an_Alley__c == 'Yes') {
            cs.Case_Record_Type__c= 'Alley Light Outage';
            // pr1 = recordTypeChange('Alley Light Outage');
        }
        else  if(cs.Case_Record_Type__c=='Street Light Outage' && cs.Is_the_Light_in_a_Park__c == 'Yes' ) {
            cs.Case_Record_Type__c= 'Park Conditions Safety and Maintenance';
            // pr1 = recordTypeChange('Park Conditions Safety and Maintenance');
        }
        else if((cs.Case_Record_Type__c=='Street Light Outage')&&(cs.Problem_Type__c == 'Other' || cs.Problem_Type__c == 'Request for New Lighting') ) {
            cs.Case_Record_Type__c= 'Street Light (Other)';
            //pr1 = recordTypeChange('Street Light (Other)');
        }
        else if((cs.Case_Record_Type__c=='Street Light Outage') && (cs.Problem_Type__c !='' && (cs.Problem_Type__c != 'Other' || cs.Problem_Type__c != 'Request for New Lighting' ))) {
            cs.Case_Record_Type__c= 'Street Light Outage';
            //pr1 = recordTypeChange('Street Light Outage');    
        } 
       

        return rsChange();
    }

    public PageReference EmergencyTransfer() {
        cs.Service_Request_Type__c ='Emergency Transfer';
        cs.Reason='Emergency Transfer';
        return SaveAndClose();
    }

    public PageReference Emergency() {
        cs.Service_Request_Type__c ='Emergencies';
        cs.Reason='Service Not Needed';
        return SaveAndClose();
    }


    //Implementation of Case created in Novo
    public PageReference SaveAndCaseCreatedinNovo() {
        cs.Reason='Case Created in Novo';
        cs.Status='Closed';
        cs.Service_Request_Type__c ='Case Created in Novo';
        return stdController.Save();
        // return SaveAndClose();
    } 


    public PageReference CloseCase() {
        cs.Status='Closed';
        return stdController.Save();
    }
    public PageReference SaveAndServiceNotNeededLI06() {
        cs.Service_Request_Type__c='Service Not Needed';
        cs.Reason='Service Not Needed';  
        return SaveAndClose();
    }    

    //Implementation of Service Not Needed button
    public PageReference SaveAndServiceNotNeeded() {
        cs.Service_Request_Type__c ='Service Not Needed';
        cs.Reason='Service Not Needed';
        return SaveAndClose();

    }

    public Void SaveAndServiceNotNeededCaseOpened() {
        cs.Service_Request_Type__c ='Service Not Needed';
        cs.Status = 'Open';
        //return CustomSave();

    }

    //Implemented for Redress Cases
    public PageReference SaveNewRedressCase() {
        Case newCase = cs.clone();
        newCase.Status = 'New';
        newCase.Streets_request_Id__c = null;
        insert newCase; 
        return new PageReference('/'+ newCase.Id);
        // return SaveAndClose();
    } 
    public PageReference redressStatusSet(){
        cs.Status='Redress';
        return stdController.Save();
    }

    public PageReference Cancel1(){

        //added by Sai...
        system.debug('inside the cancel method');
        return new PageReference('/console');
    }


    public PageReference SaveAndServiceNotNeeded1() {
        cs.Service_Request_Type__c ='Service Not Needed';
        cs.Reason='Referred to another organization';
        return SaveAndClose();
        //  return new PageReference('https://www.google.com');
    }    

    //Implementation of Save and Close button
    public PageReference SaveAndClose() {
        cs.Status='Closed';
        return stdController.Save();
    }

    public PageReference SaveAndClose1() {
        if(cs.Case_Record_Type__c == 'Information Request')  {
            cs.Status='Closed';
            cs.Reason ='Question Answered';
            CaseComment com = new CaseComment();
            if(stdController.save() == null) 
                return null;
            if (String.IsNotBlank(Comment))  {
                com.commentBody = Comment;
                cs.addError('Comment: '+ Comment + ' Case Id:' + stdController.getId() );
                com.ParentId = stdController.getId();
                insert com;
            }
            return new PageReference('/' + stdController.getId());   
        }
        else {
            if(stdController.save()==null) 
                return null;       
            CaseComment com = new CaseComment();
            if (String.IsNotBlank(Comment))  {
                com.commentBody = Comment;
                com.ParentId = stdController.getId();
                insert com;
            } 
            Apexpages.currentPage().setRedirect(true);
            //return new PageReference('/'+controller.getRecord().getSObjectType().getDescribe().getKeyPrefix()+'/e');
            return new PageReference('/'+ stdController.getId()+'/s'+'?retURL=%2F'+ stdController.getId());
        }
    }

    public integer getDate()    {
        integer d =0;
        Date currentDate = System.now().Date();
        if(stdController.getId() == null)
            return 0;   
        Case cn = [Select id,Status, ClosedDate from Case where id =:stdController.getId()];
        if(cn.Status == 'Closed')    {
            d = currentDate.daysBetween(date.valueof(cn.ClosedDate));      
            if(d<0)
                d = d* -1;    
        }
        return d; 
    }
    public integer getDate1()    {
        integer d =0;
        Date currentDate = System.now().Date();
        if(stdController.getId() == null)
            return 0;   
        Case cn = [Select id,Status, CreatedDate,service_Request_Type__c from Case where id =:stdController.getId()];
        if(cn.Status == 'Closed' && cn.service_Request_Type__c == 'Illegal Dumping')    {
            d = currentDate.daysBetween(date.valueof(cn.CreatedDate));      
            if(d<0)
                d = d* -1;    
        }
        return d; 
    }

    // Handling Redress Case
    webservice static String redress(ID caseId)    {

        System.debug('Redress Button Clicked');
        // Building the Select Query
        String soql = 'SELECT ';        
        String objectName = 'Case';
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }

        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                soql += s + ',';
            }
            if (soql.endsWith(',')){soql = soql.substring(0,soql.lastIndexOf(','));}

        }

        soql += ' FROM Case WHERE id=\''+ caseId +'\' ';

        System.debug('SQL Query Generated: ' + soql);
        Case oldCase = (Case)Database.query(soql);
        Case temp = [Select id, CaseNumber,description,createddate,reason,Streets_Request_ID__c ,Water_Request_ID__c from Case where id =: caseId];
        if(oldCase != null)    {
            Case newCase = oldCase.clone(false,true);

            // Updating some fields in the new Cloned Case
            newCase.Streets_Request_Id__c = null;
            newCase.Water_Request_Id__c = null;
            newCase.Status = 'New';
            if(newCase.Department__c == 'Streets Department')
                newCase.Redressed_Street_Request_Id__c = temp.Streets_Request_ID__c ;
            else if(newCase.Department__c == 'Water Department (PWD)')
                newCase.Redressed_Street_Request_Id__c = temp.Water_Request_ID__c ;
            newCase.Finish_Date__c = null;
            newCase.FinishDate__c = null;
            newCase.Redress_Case__c = TRUE;
            newCase.ByPass_VR_WF__c = TRUE;
            newCase.Redressed_Case_Number__c = temp.CaseNumber;  
            /* Support ticket fix for ticket number 08867031 start */
            newCase.Redressed_Case_Comments__c = temp.description; 
            newCase.Redressed_Case_Date_Time_Open__c = temp.createddate;
            newCase.Redressed_Case_Reason__c = temp.reason; 
            /* Support ticket fix for ticket number 08867031 end */
            newCase.ParentID = temp.Id;
            newCase.Ticket__c = null; //added by kousik to remove duplicate novo ticket becasue it is unique.
            newCase.Status_Update__c = 'Customer reported issue closed and not resolved (Redress)';
            try{                            
                insert newCase;                            
                Set<ID> i = new Set<ID>();
                i.add(newCase.Id);
                CaseAssignmentProcessor.processCases(i);
                System.debug('New Redress Case Created with ID: ' + newCase.id); 
                return newCase.id;                
            }
            catch(Exception ex)    {
                System.debug('Error thrown: ' + ex.getMessage());
                return 'Error: ' + ex.getMessage();
            }    
        }     
        else 
            return 'Error';   
    }

    // Custom Case Save   
    public PageReference CustomSave()
    {        

        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        String CurrentId = ApexPages.currentPage().getParameters().get('id');
        PageReference redirectPG = null;    
        String commentId = null;
        String casId = null;
        if(CurrentId == null && (cs.Service_Request_Type__c == 'Rubbish Collection' || cs.Service_Request_Type__c == 'Recyclables Collection') && cs.Type_of_Rubbish_Missed__c == 'Both')
            cs.Service_Request_Type__c = 'Rubbish Collection';
        if(stdController.Save() ==null) 
            return null;     
        casId = stdController.getId();      
        Case cas = [Select id, ContactId from Case WHERE id =: casId ];    
        if(cas !=null && cas.ContactId != null)
            Contact c = [SELECT Name, ID FROM Contact where id =: cas.ContactId FOR VIEW];    
        CaseComment com = new CaseComment();

        if(Comment != null && Comment.Length() > 0)   {
            com.commentBody = Comment;
            com.ParentId = casId ;
            insert com;
            commentId = com.Id;
        } 
        Case cs1 = [Select id, CaseNumber, Subject from Case where id =: stdController.getId()]; 
        if(sendEmailNotification == true && cs.ContactId != null)  {
            Contact con = [Select email, id, Name from Contact where id =: cs.ContactId];
            if(con.email != null){
                String[] toAddresses = new String[] {con.email}; 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //   mail.setBccAddresses(new String[] {'manasa.a@in.unisys.com'});              
                mail.setTargetObjectId(con.Id);
                // mail.setSenderDisplayName('Salesforce Support');
                OrgWideEmailAddress ow = [select Id from OrgWideEmailAddress LIMIT 1];
                if(ow.Id != null)
                    mail.setOrgWideEmailAddressId(ow.Id);
              //  mail.setReplyTo('brindha.s@in.unisys.com');    
                mail.setUseSignature(false);
                //mail.setBccSender(true); This line is commented to solve the support ticket 08977531 
                mail.setSaveAsActivity(false);
                mail.setWhatId(cs1.id);               
                EmailTemplate et=[Select id, developerName from EmailTemplate where developerName='SUPPORTCaseCreation'];
                mail.setTemplateId(et.id);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                System.debug('Contact Id:' + con.Id + ' Case Id:'+ cs.id);

                /* String[] mailRecipient = null;
                  mailRecipient.add(con.email); 
                  mail.setToAddresses(mailRecipient );
                  mail.setSubject('stackforce answer');
                 */
            }    
        }
        System.debug('Checking if Case is for Rubbish/Recyclable Material Collection Record Type');
        Case caseCreated = [Select id, Case_Record_Type__c,Type_of_Rubbish_Missed__c from Case WHERE id =: casId ];
        System.debug('Case Record Type: ' + caseCreated.Case_Record_Type__c +'Type 0f Rubbish:' + caseCreated.Type_of_Rubbish_Missed__c );
        if(caseCreated.Case_Record_Type__c == 'Rubbish/Recyclable Material Collection' && caseCreated.Type_of_Rubbish_Missed__c == 'Both' && CurrentId == null && (cs.Service_Request_Type__c == 'Rubbish Collection' || cs.Service_Request_Type__c == 'Recyclables Collection') )    {
            System.debug('Condition entered');           
            Set<Id> id = new Set<id>();    
            System.debug('Origincal Case' + stdController.getId());
            // Case newCase = caseCreated.clone(false,true);
            Case newCase = cs.clone();
            newCase.ParentId = stdController.getId();
            newCase.Service_Request_Type__c = 'Recyclables Collection';
            try {
                insert newCase;
                id.add(newCase.id);
                CaseAssignmentProcessor.processCases(id);
                System.debug('New case:' + newCase.id);
            }
            catch (Exception e) {
                System.debug(e);
            }        
            if(commentId != null)    {
                CaseComment createdComment = [Select CommentBody,id from CaseComment where id =:commentId ];
                CaseComment newComment = createdComment.clone(false,true);
                newComment.ParentId = newCase.Id;
                insert newComment;
            }   
            return new PageReference('/' + newCase.id); 
        }

        Case caseCreated1 = [Select id, Case_Record_Type__c,Violation_Type__c from Case WHERE id =: casId  ];

        if(caseCreated1.Case_Record_Type__c == 'Sanitation / Dumpster Violation' && caseCreated1.Violation_Type__c == 'Both' && CurrentId == null && (cs.Service_Request_Type__c == 'Sanitation Violation' || cs.Service_Request_Type__c == 'Dumpster Violation') )    {
            System.debug('Condition entered');           
            Set<Id> id = new Set<id>();    
            System.debug('Origincal Case' + stdController.getId());
            // Case newCase = caseCreated.clone(false,true);
            Case newCase1 = cs.clone();
            newCase1.ParentId = stdController.getId();
            newCase1.Service_Request_Type__c =  'Dumpster Violation';
            try {
                insert newCase1;
                id.add(newCase1.id);
                CaseAssignmentProcessor.processCases(id);

            }
            catch (Exception e) {
                System.debug(e);
            }        
            if(commentId != null)    {
                CaseComment createdComment1 = [Select CommentBody,id from CaseComment where id =:commentId ];
                CaseComment newComment = createdComment1.clone(false,true);
                newComment.ParentId = newCase1.Id;
                insert newComment;
            }   
            return new PageReference('/' + newCase1.id); 
        }
        redirectPG = new PageReference('/' + stdController.getId());    
        return redirectPG; 
    } 

    public static string getCreatableFieldsSOQL(String objectName, String id){

        String selects = '';
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }

        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}

        }
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE id =:\'' + id +'\'';
    }   

    public PageReference rsChange() {
        return recordTypeChange(cs.Case_Record_Type__c);
    }   

    public PageReference srtChange() {
        return recordTypeChange(cs.Service_Request_Type__c);
    }   

    public PageReference recordTypeChange(string rtName) {
        rt=getRecordType(rtName);
        if (rt!=null) {
            cs.RecordTypeId=rt.Id;
        }
        return getRecordTypePage(rt);
    }   

    public PageReference redir() {
        Map<String, String> params=ApexPages.currentPage().getParameters();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        PageReference pr =null;

        // if recordtypeid was passed in, use that, else look for the x311rt parameter which contains the developer name
        rt=getRecordType(cs.RecordTypeId!=null ? (string) cs.RecordTypeId : params.get('x311rt'));            
        pr=getRecordTypePage(rt);     

        if (pr!=null) {
            // add these in case they weren't passed
            /*    pr.getParameters().put('ekp','500');
            pr.getParameters().put('ent','Case');
            pr.getParameters().put('RecordType',rt.Id); */

            // copy over what was passed
            for (String key : params.keyset()) {
                pr.getParameters().put(key, params.get(key));
            } 
            pr.setRedirect(true);
        }     
        return pr;
    }


    public RecordType getRecordType(string idOrName) {

        List<RecordType> lstRT=[SELECT Id, DeveloperName, Name FROM RecordType WHERE Id=:idOrName OR Name LIKE :(idOrName + '%') OR DeveloperName = :idOrName];
        RecordType rt=null;
        if (lstRT.size()>0) {
            rt=lstRT[0];
        }
        return rt;

    }   

    public PageReference getRecordTypePage(RecordType rt) {
        PageReference pr= null;

        if (rt!=null) {
            rtDevName=rt.DeveloperName;            
            if (rtDevName=='Abandoned_Vehicle') {
                pr = Page.X311CaseEditPD01Ab2;

            } else if (rtDevName=='Illegal_Dumping') {
                pr = Page.X311CaseEditST02IllDump;
            } else if (rtDevName=='Rubbish_Collection') {
                pr = Page.X311CaseEditST03RbColl;
            } else if (rtDevName=='Street_Light_Outage') {
                pr = Page.X311CaseEditST04LightOut;
            } else if (rtDevName=='Graffiti') {
                pr = Page.X311CaseEditNS01Graffiti;
            } else if (rtDevName=='Information_Request') {
                pr = Page.X311InformationRequest;
            } 
            else if (rtDevName=='Directory_Assistance_IR') {
                pr = Page.X311DirectoryServices;
            }
            else if (rtDevName=='Miscellaneous') {
                pr = Page.X311CaseEdit;
            } else if (rtDevName=='Support_Case') {
                pr = Page.X311Support;
            } else if (rtDevName=='Abandoned_Bike') {
                pr = Page.X311CaseEditSRST05Abandoned_Bike;
            } else if (rtDevName=='Construction_Site_Task_Force') {
                pr = Page.X311CaseEditCSTF;
            } else if (rtDevName=='Dead_Animal_in_Street') {
                pr = Page.X311CaseEditST10DeadAnimal;
            } else if (rtDevName=='Traffic_Signal_Emergency') {
                pr = Page.X311CaseEditSRST25TrafSig;
            } else if (rtDevName=='Alley_Light_Outage') {
                pr = Page.X311CaseEditSRST06Alley_Light_Outage;
            } else if (rtDevName=='Building_Construction') {
                pr = Page.X311CaseEditSRLI02Building_Construction;
            } else if (rtDevName=='Complaint_Streets') {
                pr = Page.X311CaseEditSRST08Compaint;
            } else if (rtDevName=='Line_Striping') {
                pr = Page.X311CaseEditST13LineStriping;
            } else if (rtDevName=='Sanitation_Dumpster_Violation') {
                pr = Page.X311CaseEditST19SanitationDumpster;
            } else if (rtDevName=='Newsstand_Outdoor_Cafe') {
                pr = Page.X311CaseEditST15NewsstandOutdoorCafe;
            } else if (rtDevName=='Manhole_Cover') {
                pr = Page.X311CaseEditSRST14Manhole;
            } else if (rtDevName=='Traffic_Other') {
                pr = Page.X311CaseEditSRST24TrafficOther;
            } else if (rtDevName=='Street_Paving') {
                pr = Page.X311CaseEditSRST23StreetPaving;
            } else if (rtDevName=='Hydrant_Knocked_Down_No_Water') {
                pr = Page.X311CaseEditWD02HydrantKnockedDown;
            } else if (rtDevName=='Vacant_Lot_Clean_Up') {
                pr = Page.X311CaseEditNS03VacantLotCleanUp;
            }else if (rtDevName=='Complaints_Against_Fire_or_EMS') {
                pr = Page.X311CaseEditFD01Fire_EMS;
            } else if (rtDevName=='Smoke_Detector') {
                pr = Page.X311CaseEditFD02SmokeDetector;
            }  else if (rtDevName=='Street_Trees') {
                pr = Page.X311CaseEditPR08StreetTrees;
            }
            else if (rtDevName=='Shoveling') {
                pr = Page.X311CaseEditSRST20Shoveling;
            }   
            else if (rtDevName=='Salting') {
                pr = Page.X311CaseEditSRST18Salting;
            }     
            else if (rtDevName=='Other_Streets') {
                pr = Page.X311CaseEditSRST16OtherStreets;
            }    
            else if (rtDevName=='Stop_Sign_Repair') {
                pr = Page.X311CaseEditSRST21StopSignRepair;
            }    
            else if (rtDevName=='Street_Defect') {
                pr = Page.X311CaseEditSRST01StreetDefect;
            }  
            else if (rtDevName=='Zoning_Residential') {
                pr = Page.X311CaseEditSRLI30ZoningResidential;
            }   
            else if (rtDevName=='Vacant_House_or_Commercial') {
                pr = Page.X311CaseEditSRLI27VacantHouseOrCom;
            }     
            else if (rtDevName=='Tree_Dangerous') {
                pr = Page.X311CaseEditSRLI25TreeDangerous;
            }
            else if (rtDevName=='Daycare_Residential_or_Commercial') {
                pr = Page.X311CaseEditSRLI08Daycare;
            }
            else if (rtDevName=='Boarding_Room_House') {
                pr = Page.X311CaseEditSRLI01Boardingroom;
            }  
            else if (rtDevName=='Maintenance_Residential_or_Commercial') {
                pr = Page.X311CaseEditSRLI21MaintResComm;
            } 

            else if (rtDevName=='Building_Dangerous') {
                pr = Page.X311CaseEditSRLI03BuildingDangerous;
            }  
            else if (rtDevName=='Zoning_Business') {
                pr = Page.X311CaseEditSRLI28ZoningBusiness;
            } 

            else if (rtDevName=='Other_Dangerous') {
                pr = Page.X311CaseEditSRLI23OtherDangerous;
            } 
            else if (rtDevName=='Fire_Residential_or_Commercial') {
                pr = Page.X311CaseEditSRLI16Fire1;
            } 
            else if (rtDevName=='License_Residential') {
                pr = Page.X311CaseEditSRLI19LicenseResidential;
            } 
            else if (rtDevName=='Infestation_Residential') {
                pr = Page.X311CaseEditSRLI17Infestation;
            }
            else if (rtDevName=='No_Heat_Residential') {
                pr = Page.X311CaseEditSRLI22NoHeat;
            }
            else if (rtDevName=='Emergency_Air_Conditioning') {
                pr = Page.X311CaseEditSRLI13EmergencyAir;
                
            }            
            else if (rtDevName=='Traffic_Signal_Emergency') {
                pr = Page.X311CaseEditSRST25TrafSig;
            } 
            else if (rtDevName=='Police_Complaint') {
                pr = Page.X311CaseEditSRPD02POLICECOMP;
            } 
            else if (rtDevName=='Parks_and_Rec_Safety_and_Maintenance') {
                pr = Page.X311CaseEditSRPR01ParksAndRec;
            } 
            else if (rtDevName=='Inlet_Cleaning') {
                pr = Page.X311CaseEditWD01InletCleaning;
            } 
            else if (rtDevName=='Dangerous_Sidewalk') {
                pr = Page.X311CaseEditSRST09DangerousSidewalk;
            } 

            else {
                pr = Page.X311CaseEdit;
                //  pr = Page.X311InformationRequest;
            }

        }
        if(rt == null){
            List<Profile> PROFILE1 = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    /*  */        if(((PROFILE1.get(0).name == 'Department Liaisons') || (PROFILE1.get(0).name == 'Police Department Liaisons')||PROFILE1.get(0).name == 'City Department Heads')|| (PROFILE1.get(0).name == 'Department Field Worker')||(PROFILE1.get(0).name == 'Customer community')|| (PROFILE1.get(0).name == 'Customer Community Login User')||(PROFILE1.get(0).name == 'Neighborhood Liaison')||(PROFILE1.get(0).name == 'City Council')||(PROFILE1.get(0).name == 'State Reps')||(PROFILE1.get(0).name == 'Various Civic City Groups, Kensignton CDC, Northern Liberties CDC')||(PROFILE1.get(0).name == 'Neighborhood Liaisons1')) {

                RecordType rs = [Select Id,name,DeveloperName from RecordType Where DeveloperName = 'Information_Request'];
                pr = Page.X311InformationRequest;
                pr.getParameters().put('RecordType',rs.Id);            
            }
        }

        return pr;  
    }

    public String getScriptName() {
        String scriptName=null;
        if (rt!=null) {
            rtDevName=rt.DeveloperName;
            if (rtDevName=='Abandoned_Vehicle') {
                scriptName = 'Abandoned_Vehicle1';
            } else if (rtDevName=='Illegal_Dumping') {
                scriptName = 'Illegal_Dumping';
            } else if (rtDevName=='Rubbish_Collection') {
                scriptName = 'RubbishCollections';
            } else if (rtDevName=='Street_Light_Outage') {
                scriptName = 'StreetLightOutage';
            } else if (rtDevName=='Graffiti') {
                scriptName = 'Graffiti';
            } else if (rtDevName=='Information_Request') {
                scriptName = 'Script_Standard_IR';
            } else if (rtDevName=='Miscellaneous') {
                scriptName = 'Script_Standard_SR';
            } else if (rtDevName=='Dead_Animal_in_Street') {
                scriptName = 'Dead_Animal_in_Street';
            } else if (rtDevName=='Construction_Site_Task_Force') {
                scriptName = 'Construction_Site_Task_Force';
            } else if (rtDevName=='Alley_Light_Outage') {
                scriptName = 'Alley_Light_Outage';
            } else if (rtDevName=='Building_Construction') {
                scriptName = 'Building_Construction';
            } else if (rtDevName=='Traffic_Signal_Emergency') {
                scriptName = 'Traffic_Signal_Emergency';
            } else if (rtDevName=='Complaint_Streets') {
                scriptName = 'Complaint_Streets';
            } else if (rtDevName=='Manhole_Cover') {          // To be changed with correct script
                scriptName = 'Manhole_Cover';
            } else if (rtDevName=='Line_Striping') {          
                scriptName = 'Line_Striping';
            } else if (rtDevName=='Sanitation_Dumpster_Violation') {          
                scriptName = 'SanitationDumpsterViolation';
            } else if (rtDevName=='Newsstand_Outdoor_Cafe') {          
                scriptName = 'Newsstand_Outdoor_Cafe';
            } else if (rtDevName=='Street_Paving') {         
                scriptName = 'Street_Paving';
            } else if (rtDevName=='Traffic_Other') {         
                scriptName = 'Traffic_Other';
            } else if (rtDevName=='Hydrant_Knocked_Down_No_Water') {         
                scriptName = 'Hydrant_Knocked_Down';
            } else if (rtDevName=='Vacant_Lot_Clean_Up') {
                scriptName = 'Vacant_Lot_Clean_Up';
            } else if (rtDevName=='Inlet_Cleaning') {
                scriptName = 'Inlet_Cleaning';
            } else if (rtDevName=='Complaints_Against_Fire_or_EMS') {
                scriptName = 'ComplaintAgainstFireorEMS';
            } else if (rtDevName=='Smoke_Detector') {
                scriptName = 'Smoke_Detector';
            } else if (rtDevName=='Street_Trees') {
                scriptName = 'Street_Trees';
            } 
            else if (rtDevName=='Stop_Sign_Repair') {         
                scriptName = 'Stop_Sign_Repair';
            }
            else if (rtDevName=='Shoveling') {         
                scriptName = 'Shoveling';
            }
            else if (rtDevName=='Salting') {         
                scriptName = 'Salting';
            }
            else if (rtDevName=='Other_Streets') {         
                scriptName = 'Other_Streets';
            }
            else if (rtDevName=='Street_Defect') {         
                scriptName = 'Street_Defect';
            }
            else if (rtDevName=='Zoning_Residential') {         
                scriptName = 'Zoning_Residential';
            }
            else if (rtDevName=='Vacant_House_or_Commercial') {         
                scriptName = 'Vacant_House_or_Commercial';
            }
            else if (rtDevName=='Tree_Dangerous') {         
                scriptName = 'Tree_Dangerous';
            }
            else if (rtDevName=='Daycare_Residential_or_Commercial') {         
                scriptName = 'DaycareResidential';
            }
            else if (rtDevName=='Boarding_Room_House') {         
                scriptName = 'Boarding_Room_House';
            }
            else if (rtDevName=='Maintenance_Residential_or_Commercial') {         
                scriptName = 'Maintenance_Residential_or_Commercial';
            }
            else if (rtDevName=='Building_Dangerous') {         
                scriptName = 'Building_Dangerous';
            }
            else if (rtDevName=='Zoning_Business') {         
                scriptName = 'Zoning_Business';
            }
            else if (rtDevName=='Other_Dangerous') {         
                scriptName = 'Other_Dangerous';
            }
            else if (rtDevName=='Fire_Residential_or_Commercial') {         
                scriptName = 'Fire_Residential_or_Commercial';
            }
            else if (rtDevName=='License_Residential') {         
                scriptName = 'License_Residential';
            }
            else if (rtDevName=='Infestation_Residential') {         
                scriptName = 'InfestationResidential';
            }
            else if (rtDevName=='No_Heat_Residential') {         
                scriptName = 'NoHeat';
            }
            else if (rtDevName=='Emergency_Air_Conditioning') {         
                scriptName = 'Emergency_Air_Conditioning';
            }
            else if (rtDevName=='Police_Complaint') {         
                scriptName = 'Police_Complaint';
            }
            else if (rtDevName=='Traffic_Signal_Emergency') {         
                scriptName = 'Traffic_Signal_Emergency';
            }
            else if (rtDevName=='Parks_and_Rec_Safety_and_Maintenance') {         
                scriptName = 'ParksandRecSafetyandMaintenance';
            }
            else if (rtDevName=='Inlet_Cleaning') {         
                scriptName = 'Inlet_Cleaning';
            }else if(rtDevName=='Dangerous_Sidewalk') {
                scriptName= 'Dangerous_Sidewalk';
            }
            else {
                scriptName = 'Script_Standard_SR';
            } 

        }
        return scriptName;    
    }
    public String getFlow1Name() {
        String scriptName=null;
        try {
            system.debug('recordtype Id before loop' + cs.recordTypeID);
            RecordType rd = [select developerName from recordtype where Id =: cs.recordTypeId];
            system.debug('recordtype Id before loop' + cs.recordTypeID);
            system.debug('recordtype before loop' + rd.developerName);
            if (rd!=null) {
                rtDevName=rd.DeveloperName;
                system.debug('inside loop' + rtDevName);
                if (rtDevName=='Abandoned_Vehicle') {
                    scriptName = 'Abandoned_Vehicle1';
                } else if (rtDevName=='Illegal_Dumping') {
                    scriptName = 'Illegal_Dumping';
                } else if (rtDevName=='Rubbish_Collection') {
                    scriptName = 'RubbishCollections';
                } else if (rtDevName=='Street_Light_Outage') {
                    scriptName = 'StreetLightOutage';
                } else if (rtDevName=='Graffiti') {
                    scriptName = 'Graffiti';
                } else if (rtDevName=='Information_Request') {
                    scriptName = 'Script_Standard_IR';
                } else if (rtDevName=='Miscellaneous') {
                    scriptName = 'Script_Standard_SR';
                } else if (rtDevName=='Dead_Animal_in_Street') {
                    scriptName = 'Dead_Animal_in_Street';
                } else if (rtDevName=='Construction_Site_Task_Force') {
                    scriptName = 'Construction_Site_Task_Force';
                } else if (rtDevName=='Alley_Light_Outage') {
                    scriptName = 'Alley_Light_Outage';
                } else if (rtDevName=='Building_Construction') {
                    scriptName = 'Building_Construction';
                } else if (rtDevName=='Traffic_Signal_Emergency') {
                    scriptName = 'Traffic_Signal_Emergency';
                } else if (rtDevName=='Complaint_Streets') {
                    scriptName = 'Complaint_Streets';
                } else if (rtDevName=='Manhole_Cover') {          // To be changed with correct script
                    scriptName = 'Manhole_Cover';
                } else if (rtDevName=='Line_Striping') {          
                    scriptName = 'Line_Striping';
                } else if (rtDevName=='Sanitation_Dumpster_Violation') {          
                    scriptName = 'SanitationDumpsterViolation';
                } else if (rtDevName=='Newsstand_Outdoor_Cafe') {          
                    scriptName = 'Newsstand_Outdoor_Cafe';
                } else if (rtDevName=='Street_Paving') {         
                    scriptName = 'Street_Paving';
                } else if (rtDevName=='Traffic_Other') {         
                    scriptName = 'Traffic_Other';
                } else if (rtDevName=='Hydrant_Knocked_Down_No_Water') {         
                    scriptName = 'Hydrant_Knocked_Down';
                } else if (rtDevName=='Vacant_Lot_Clean_Up') {
                    scriptName = 'Vacant_Lot_Clean_Up';
                } else if (rtDevName=='Inlet_Cleaning') {
                    scriptName = 'Inlet_Cleaning';
                } else if (rtDevName=='Complaints_Against_Fire_or_EMS') {
                    scriptName = 'ComplaintAgainstFireorEMS';
                } else if (rtDevName=='Smoke_Detector') {
                    scriptName = 'Smoke_Detector';
                } else if (rtDevName=='Street_Trees') {
                    scriptName = 'Street_Trees';
                } 
                else if (rtDevName=='Stop_Sign_Repair') {         
                    scriptName = 'Stop_Sign_Repair';
                }
                else if (rtDevName=='Shoveling') {         
                    scriptName = 'Shoveling';
                }
                else if (rtDevName=='Salting') {         
                    scriptName = 'Salting';
                }
                else if (rtDevName=='Other_Streets') {         
                    scriptName = 'Other_Streets';
                }
                else if (rtDevName=='Street_Defect') {         
                    scriptName = 'Street_Defect';
                }
                else if (rtDevName=='Zoning_Residential') {         
                    scriptName = 'Zoning_Residential';
                }
                else if (rtDevName=='Vacant_House_or_Commercial') {         
                    scriptName = 'Vacant_House_or_Commercial';
                }
                else if (rtDevName=='Tree_Dangerous') {         
                    scriptName = 'Tree_Dangerous';
                }
                else if (rtDevName=='Daycare_Residential_or_Commercial') {         
                    scriptName = 'DaycareResidential';
                }
                else if (rtDevName=='Boarding_Room_House') {         
                    scriptName = 'Boarding_Room_House';
                }
                else if (rtDevName=='Maintenance_Residential_or_Commercial') {         
                    scriptName = 'Maintenance_Residential_or_Commercial';
                }
                else if (rtDevName=='Building_Dangerous') {         
                    scriptName = 'Building_Dangerous';
                }
                else if (rtDevName=='Zoning_Business') {         
                    scriptName = 'Zoning_Business';
                }
                else if (rtDevName=='Other_Dangerous') {         
                    scriptName = 'Other_Dangerous';
                }
                else if (rtDevName=='Fire_Residential_or_Commercial') {         
                    scriptName = 'Fire_Residential_or_Commercial';
                }
                else if (rtDevName=='License_Residential') {         
                    scriptName = 'License_Residential';
                }
                else if (rtDevName=='Infestation_Residential') {         
                    scriptName = 'InfestationResidential';
                }
                else if (rtDevName=='No_Heat_Residential') {         
                    scriptName = 'NoHeat';
                }
                else if (rtDevName=='Emergency_Air_Conditioning') {         
                    scriptName = 'Emergency_Air_Conditioning';
                }
                else if (rtDevName=='Police_Complaint') {         
                    scriptName = 'Police_Complaint';
                }
                else if (rtDevName=='Traffic_Signal_Emergency') {         
                    scriptName = 'Traffic_Signal_Emergency';
                }
                else if (rtDevName=='Parks_and_Rec_Safety_and_Maintenance') {         
                    scriptName = 'ParksandRecSafetyandMaintenance';
                }
                else if (rtDevName=='Inlet_Cleaning') {         
                    scriptName = 'Inlet_Cleaning';
                }else if(rtDevName=='Dangerous_Sidewalk') {
                    scriptName= 'Dangerous_Sidewalk';
                }else if(rtDevName=='Abandoned_Bike') {
                    scriptName= 'Abandoned_Bike';
                }else if(rtDevName=='Directory_Assistance_IR') {
                    scriptName= 'Directory_IR';
                }else if(rtDevName=='Directory_Assistance_SR') {
                    scriptName= 'Directory_SR';
                }
                else if(rtDevName=='Support_Case') {
                    scriptName= 'Support_Flow';
                }
                else {
                    scriptName = 'Script_Standard_SR';
                } 

            }else scriptName = 'Script_Standard_SR';
        }catch( Exception e) {
            System.Debug('Exception Occured'+ e.getMessage()); 
            return 'Script_Standard_SR';
        }
        return scriptName;
    }


    public void contactChange() {
        system.debug('the contact id is '+cs.ContactID);
        List<Contact> lst=[SELECT Id,lastname,MailingPostalCode,AccountId,Phone FROM Contact WHERE Id=:cs.ContactId ];
        if (!lst.IsEmpty()) {
            Contact theContact=lst[0];
            //cs.contactID = theContact.Id;
            // cs.Zip_code__c=(cs.Zip_code__c==null ? theContact.MailingPostalCode : cs.Zip_code__c);
            cs.Zip_code__c = theContact.MailingPostalCode;

            cs.Phone_Number__c = theContact.Phone;
            //  if(cs.Zip_code__c == null) 
            //    cs.Zip_code__c='Declined';
            cs.AccountId = theContact.AccountId;
        }
    }

    public void addAcc() {
        List<Contact> lst1=[SELECT Id,AccountId FROM Contact WHERE Id=:cs.ContactId ];
        if (!lst1.IsEmpty()) {
            Contact theContact=lst1[0];              
            if(cs.AccountId == null) {
                theContact.AccountId = null;
            }
            else {    
                theContact.AccountId = cs.AccountId;
            } 
            update theContact;
        }
    }
}