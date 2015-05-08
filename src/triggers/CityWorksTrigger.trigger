trigger CityWorksTrigger on Case (before insert,before update, before delete, after update, after insert) {

    // Trigger is called on Delete event
    if (Trigger.isDelete) {
        for (Case c : Trigger.old) {
            if(c.Streets_Request_ID__c != null || c.Water_Request_ID__c != null)
                 c.addError('Cases integrated with CityWorks cannot be deleted');  
        } 
    }
    
    // not a delete  
    else {  

        // If Before Event
        if (Trigger.isBefore)  {   
            System.debug('CityWorks Trigger.');
            System.debug('Trigger Size: ' + Trigger.new.size());
            String details = null;
            integer len = 0;
            
         //  if(Trigger.isInsert )    {
                IntegrationRelatedTask  i = new IntegrationRelatedTask();
                for(Case cs:Trigger.new) {      
                
                   /* Commenting as this has been handled in isAfter condition
                   // Support Ticket #08973863 If Comment is null for case coming from PS then it is not flowing to Cityworks.
                   
                       if(cs.Customer_request_ID__c != null && (cs.Description == null || cs.Description == '' ))
                           cs.Description = 'None';
                   
                   */
                   
                   System.debug('Case Details: ' + cs.CaseNumber + ', '+ cs.Status + ', ' + cs.RecordType.Name + ', ' + cs.Type + ', ' + cs.Case_Record_Type__c +', ' + cs.Service_request_Type__c);                     
                  
                    // Removing the text 'Address verification not done' from the description, if the address is verified
                   if((cs.Description != null && cs.Description != '' ) && (cs.Centerline_2272x__c != 0.0) && (cs.Centerline_2272x__c != NULL) && ((cs.Department__c == 'Streets Department' || cs.Department__c == 'Water Department (PWD)')) && (cs.Description.contains('Address verification not done'))) {
                        while(cs.Description.contains('Address verification not done')) {
                                cs.Description = cs.Description.replaceAll('Address verification not done','');               
                        }

                    }
                  
                   details = cs.Description;
                   
                   if(trigger.isInsert) {
                   if(cs.Customer_Request_Id__c != null)
                       i.parseDetailsFieldfromPS(cs); 
                   }
                   // CityWorks Integration
                   if(cs.Department__c == 'Streets Department' || cs.Department__c == 'Water Department (PWD)')    {
                      
                       i.updateDetailsField(cs);
                   }
                   
                    // Added Code for Hansen integration
                    else if((cs.Department__c == 'License & Inspections') || (cs.Department__c == 'Community Life Improvement Program' && cs.Case_Record_Type__c == 'Vacant Lot Clean-Up' ))   {
                       //Fix For Support Ticket #08993566 
                        if(cs.contactId == null && userInfo.getUserType() == 'Standard' )  {
                            Contact newCon =[Select id, Name from Contact where name = 'ANON ANON' LIMIT 1];
                            // added to sync with standards
                            cs.Customer_Declined__c = false;
                            if(newCon != null)
                                cs.contactId = newCon.id;
                        }
                       
                        if(cs.Customer_request_id__c == null)
                            details += 'Custom Fields:  ';
                            
                        if(cs.Case_Record_Type__c == 'Boarding Room House')   {
                            if(cs.Number_of_Unrelated_Tenants__c != null)
                                details +=  ' Number of Unrelated Tenants : ' + cs.Number_of_Unrelated_Tenants__c  + '. ';
                            if(cs.Rental_License__c != null)
                                details +=  ' ,  Rental License : ' + cs.Rental_License__c + '. ';
                            if(cs.Zoning_Permit__c != null)
                                details +=  ',   Zoning Permit : ' + cs.Zoning_Permit__c  + '. ';                            
                            if(cs.Customer_is_a_Tenant__c != null)
                                details +=  ',    Customer is a Tenant : ' + cs.Customer_is_a_Tenant__c + '. ';                            
                            if(cs.Does_Owner_Reside_at_Property__c != null)
                                details +=  ',   Does Owner Reside at Property : ' + cs.Does_Owner_Reside_at_Property__c + '. ';                            
                            if(cs.Property_Owner_Name__c != null)
                                details +=  ',    Property Owner Name : ' + cs.Property_Owner_Name__c + '. ';                            
                            if(cs.Property_Owner_Phone_Number__c != null)
                                details +=  ',   Property Owner Phone Number : ' + cs.Property_Owner_Phone_Number__c + '. ';                            
                            if(cs.L_I_District__c != null)
                                details +=  ',  L&I District : ' + cs.L_I_District__c + '. ';                            
                            if(cs.L_I_Address__c != null)
                                details +=  ',   L&I Address : ' + cs.L_I_Address__c + '. ';                            
                        }    
                        else if(cs.Case_Record_Type__c == 'Building Construction'){
                            if(cs.Type_of_Work_Being_Done__c != null)
                                details +=  ' Type of Work Being Done : ' + cs.Type_of_Work_Being_Done__c + '. ';
                            if(cs.Valid_Permit__c != null)
                                details +=  ' Valid Permit : ' + cs.Valid_Permit__c + '. ';
                            if(cs.Unsafe_Conditions__c != null)
                                details +=  ' Unsafe Conditions : ' + cs.Unsafe_Conditions__c + '. ';
                            if(cs.Where_is_Work_Being_Done__c != null)
                                details +=  ' Where is Work Being Done : ' + cs.Where_is_Work_Being_Done__c + '. ';
                            if(cs.Day_of_Week_Work_Being_Done__c != null)
                                details +=  ' Day of Week Work Being Done : ' + cs.Day_of_Week_Work_Being_Done__c + '. ';
                            if(cs.Contractor_Company_Name__c != null)
                                details +=  ' Contractor/Company Name : ' + cs.Contractor_Company_Name__c+ '. ';
                            if(cs.Sparking_Wires_or_Illegal_Hookups__c != null)
                                details +=  ' Sparking Wires or Illegal Hookups : ' + cs.Sparking_Wires_or_Illegal_Hookups__c+ '. ';
                            if(cs.Fence_Paved_Area_or_Shed__c!= null)
                                details +=  ' Fence, Paved Area, or Shed : ' + cs.Fence_Paved_Area_or_Shed__c+ '. ';
                            if(cs.Fence_Location__c != null)
                                details +=  ' Fence Location : ' + cs.Fence_Location__c+ '. ';
                            if(cs.Fence_Height_Feet__c!= null)
                                details +=  ' Fence Height (Feet) : ' + cs.Fence_Height_Feet__c+ '. ';
                            if(cs.Storage_Shed_Location__c!= null)
                                details +=  ' Storage Shed Location : ' + cs.Storage_Shed_Location__c+ '. ';
                            if(cs.Storage_Shed_Size_Square_Feet__c != null)
                                details +=  ' Storage Shed Size (Square Feet) : ' + cs.Storage_Shed_Size_Square_Feet__c+ '. ';
                            if(cs.Paved_Area_to_Create_Parking_Space__c!= null)
                                details +=  ' Paved Area to Create Parking Space : ' + cs.Paved_Area_to_Create_Parking_Space__c+ '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }                       
                        else if(cs.Case_Record_Type__c == 'Building Dangerous'){
                            if(cs.Building_Collapsing__c != null)
                                details +=  ' Building Collapsing : ' + cs.Building_Collapsing__c + '. ';
                            if(cs.Under_Construction_or_Demolition__c != null)
                                details +=  ' Under Construction or Demolition : ' + cs.Under_Construction_or_Demolition__c + '. ';
                            if(cs.Emergency_Repairs_for_Facade__c != null) 
                                details +=  ' Emergency Repairs for FaÃ§ade : ' + cs.Emergency_Repairs_for_Facade__c + '. ';
                            if(cs.Location_of_Dangerous_Condition__c != null) 
                                details +=  ' Location of Dangerous Condition : ' + cs.Location_of_Dangerous_Condition__c + '. ';
                            if(cs.Historical_Building__c != null) 
                                details +=  ' Historical Building : ' + cs.Historical_Building__c + '. ';
                            if(cs.Vacant_or_Occupied__c != null) 
                                details +=  ' Vacant or Occupied : ' + cs.Vacant_or_Occupied__c + '. ';
                            if(cs.Residential_or_Commerical__c != null) 
                                details +=  ' Residential or Commercial : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.House_or_Apartment_Complex__c != null) 
                                details +=  ' House or Apartment Complex : ' + cs.House_or_Apartment_Complex__c + '. ';
                            if(cs.Single_or_Multi_Family__c != null) 
                                details +=  ' Single or Multi-Family : ' + cs.Single_or_Multi_Family__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }    
                        else if(cs.Case_Record_Type__c == 'Construction Site Task Force'){
                            if(cs.Building_Collapsing__c != null) 
                                details +=  ' Building Collapsing : ' + cs.Building_Collapsing__c + '. ';
                            if(cs.Permit_Visible_And_Or_Displayed__c != null) 
                                details +=  ' Permit Visible or Displayed : ' + cs.Permit_Visible_And_Or_Displayed__c + '. ';
                            if(cs.Building_Under_Construction_or_Demolitio__c != null) 
                                details +=  ' Construction or Demolition : ' + cs.Building_Under_Construction_or_Demolitio__c + '. ';
                            if(cs.Type_of_Work_Being_Done__c != null) 
                                details +=  ' Type of Work Being Done : ' + cs.Type_of_Work_Being_Done__c + '. ';
                            if(cs.Vallid_Permit__c != null) 
                                details +=  ' Valid Permit : ' + cs.Vallid_Permit__c + '. ';
                            if(cs.Contractor_Company_Name__c != null) 
                                details +=  ' Contractor/Company Name : ' + cs.Contractor_Company_Name__c + '. ';
                            if(cs.Unlicensed_Contractors_Performing_Work__c != null) 
                                details +=  ' Unlicensed Contractors : ' + cs.Unlicensed_Contractors_Performing_Work__c + '. ';
                            if(cs.Demolition_or_Construction__c != null) 
                                details +=  ' Demolition or Construction : ' + cs.Demolition_or_Construction__c + '. ';
                            if(cs.Threatening_Public_Safety__c != null) 
                                details +=  ' Threatening Public Safety : ' + cs.Threatening_Public_Safety__c + '. ';
                            if(cs.Private_Demolition__c != null) 
                                details +=  ' Private Demolition : ' + cs.Private_Demolition__c + '. ';
                            if(cs.Construction_or_Demolition_Debris_Causin__c != null) 
                                details +=  ' Construction or Demolition Debris : ' + cs.Construction_or_Demolition_Debris_Causin__c + '. ';
                            if(cs.Demolition_State__c != null) 
                                details +=  ' Demolition State : ' + cs.Demolition_State__c + '. ';
                            if(cs.Sidewalk_Blocked_Without_Permission__c != null) 
                                details +=  ' Sidewalk Blocked : ' + cs.Sidewalk_Blocked_Without_Permission__c + '. ';
                            if(cs.Work_Performed_Before_After_Hours_Withou__c != null) 
                                details +=  ' Work Performed Before/After Hours : ' + cs.Work_Performed_Before_After_Hours_Withou__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Daycare Residential or Commercial'){
                            if(cs.Residential_or_Commerical__c != null) 
                                details +=  ' Residential or Commerical : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.Daycare_Business_Name__c != null) 
                                details +=  ' Daycare Business Name : ' + cs.Daycare_Business_Name__c + '. ';
                            if(cs.One_or_Two_Family_Dwelling__c != null) 
                                details +=  ' One or Two Family Dwelling : ' + cs.One_or_Two_Family_Dwelling__c + '. ';
                            if(cs.Hours_of_Operation__c != null) 
                                details +=  ' Hours of Operation : ' + cs.Hours_of_Operation__c + '. ';
                            if(cs.Violation_Type_Daycare__c != null) 
                                details +=  ' Violation Type : ' + cs.Violation_Type_Daycare__c + '. ';
                            if(cs.Family_Daycare_License__c != null) 
                                details +=  ' Family Daycare License : ' + cs.Family_Daycare_License__c + '. ';
                            if(cs.Food_Preparation_and_Service_License__c != null) 
                                details +=  ' Food Preparation and Service License : ' + cs.Food_Preparation_and_Service_License__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Emergency Air Conditioning'){
                            if(cs.Heat_Emergency__c != null) 
                                details +=  ' Heat Emergency : ' + cs.Heat_Emergency__c + '. ';
                            if(cs.Residential_Windows_Inoperable__c != null) 
                                details +=  ' Residential Windows Inoperable : ' + cs.Residential_Windows_Inoperable__c + '. ';
                            if(cs.Nursing_Personal_Care_Home_Hospital__c != null) 
                                details +=  ' Nursing/Personal Care Home/Hospital : ' + cs.Nursing_Personal_Care_Home_Hospital__c + '. ';
                            if(cs.How_Many_Days_Without_Air_Conditioning__c != null) 
                                details +=  ' How Many Days Without Air Conditioning : ' + cs.How_Many_Days_Without_Air_Conditioning__c + '. ';
                            if(cs.Health_Care_Facility_Name__c != null) 
                                details +=  ' Health Care Facility Name : ' + cs.Health_Care_Facility_Name__c + '. ';
                            if(cs.Name_if_Not_Verified__c != null) 
                                details +=  ' Name if Not Verified : ' + cs.Name_if_Not_Verified__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Fire Residential or Commercial'){
                            if(cs.Hazardous_Materials_Spill__c != null) 
                                details +=  ' Hazardous Materials Spill : ' + cs.Hazardous_Materials_Spill__c + '. ';
                            if(cs.Specific_Location_of_Fire_Code_Violation__c != null) 
                                details +=  ' Specific Location of Fire Code Violation : ' + cs.Specific_Location_of_Fire_Code_Violation__c + '. ';
                            if(cs.Residential_or_Commerical__c != null) 
                                details +=  ' Residential or Commerical : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.Residential_Property_Type__c != null) 
                                details +=  ' Residential Property Type : ' + cs.Residential_Property_Type__c + '. ';
                            if(cs.Unit_Number__c != null) 
                                details +=  ' Unit Number : ' + cs.Unit_Number__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Infestation Residential'){
                            if(cs.Residential_or_Commerical__c != null) 
                                details +=  ' Residential or Commerical : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.Unit_Number__c != null) 
                                details +=  ' Unit Number : ' + cs.Unit_Number__c + '. ';
                            if(cs.Infestation_Type__c != null) 
                                details +=  ' Infestation Type : ' + cs.Infestation_Type__c + '. ';
                            if(cs.Tenant_in_Single_Family_Dwelling__c != null) 
                                details +=  ' Tenant in Single Family Dwelling : ' + cs.Tenant_in_Single_Family_Dwelling__c + '. ';
                            if(cs.Report_Type__c != null) 
                                details +=  ' Report Type : ' + cs.Report_Type__c + '. ';
                            if(cs.Residential_Property_Type__c != null) 
                                details +=  ' Residential Property Type : ' + cs.Residential_Property_Type__c + '. ';   
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'License Residential'){
                            if(cs.License_to_Rent__c != null) 
                                details +=  ' License to Rent : ' + cs.License_to_Rent__c + '. ';
                            if(cs.Property_Owner_Name__c != null) 
                                details +=  ' Property Owner Name : ' + cs.Property_Owner_Name__c + '. ';
                            if(cs.Zoning_Permit__c != null) 
                                details +=  ' Zoning Permit : ' + cs.Zoning_Permit__c + '. ';
                            if(cs.Property_Owner_Contact_Information__c != null) 
                                details +=  ' Property Owner Contact Information : ' + cs.Property_Owner_Contact_Information__c + '. ';
                            if(cs.Property_Type__c != null) 
                                details +=  ' Property Type : ' + cs.Property_Type__c + '. ';
                            if(cs.Apartment_Number__c != null) 
                                details +=  ' Apartment Number : ' + cs.Apartment_Number__c + '. '; 
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Maintenance Residential or Commercial'){
                            if(cs.Residential_or_Commerical__c != null) 
                                details +=  ' Residential or Commerical : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.Exterior_or_Interior__c != null) 
                                details +=  ' Exterior or Interior : ' + cs.Exterior_or_Interior__c + '. ';
                            if(cs.Property_Owner_Name__c != null) 
                                details +=  ' Property Owner Name : ' + cs.Property_Owner_Name__c + '. ';
                            if(cs.Property_Owner_Contact_Information__c != null) 
                                details +=  ' Property Owner Contact Information : ' + cs.Property_Owner_Contact_Information__c + '. ';
                            if(cs.Residential_Property_Type__c != null) 
                                details +=  ' Residential Property Type : ' + cs.Residential_Property_Type__c + '. ';
                            if(cs.Drainage_Problem__c != null) 
                                details +=  ' Drainage Problem : ' + cs.Drainage_Problem__c + '. ';
                            if(cs.Unit_Number__c != null) 
                                details +=  ' Unit Number : ' + cs.Unit_Number__c + '. ';
                            if(cs.Flooded_Residential_Basement__c != null) 
                                details +=  ' Flooded Residential Basement : ' + cs.Flooded_Residential_Basement__c + '. ';
                            if(cs.Problem_Location_at_House_or_Unit__c != null) 
                                details +=  ' Problem Location at House or Unit : ' + cs.Problem_Location_at_House_or_Unit__c + '. ';
                            if(cs.Adult_Present_to_Provide_Access_to_Inspe__c != null) 
                                details +=  ' Provide Access to Inspector : ' + cs.Adult_Present_to_Provide_Access_to_Inspe__c + '. ';  
                            if(cs.Is_Customer_the_Property_Owner__c != null) 
                                details +=  ' Is Customer the Property Owner : ' + cs.Is_Customer_the_Property_Owner__c + '. ';     
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'No Heat (Residential)'){
                            if(cs.Residential_or_Commerical__c != null)
                                details +=  ' Structure Collapsing : ' + cs.Residential_or_Commerical__c+ '. ';
                            if(cs.Residential_Property_Type__c != null)
                                details +=  ' Structure Collapsing : ' + cs.Residential_Property_Type__c + '. ';
                            if(cs.Unit_Number__c != null)
                                details +=  ' Unit Number : ' + cs.Unit_Number__c + '. ';
                            if(cs.Heat_Type__c != null)
                                details +=  ' Heat Type : ' + cs.Heat_Type__c + '. ';
                            if(cs.Number_of_Days_Without_Heat__c != null)
                                details +=  ' Number of Days Without Heat : ' + cs.Number_of_Days_Without_Heat__c+ '. ';
                            if(cs.Owner_Name__c != null)
                                details +=  ' Owner Name : ' + cs.Owner_Name__c + '. ';
                            if(cs.Owner_Address__c!= null)
                                details +=  ' Owner Address : ' + cs.Owner_Address__c+ '. ';
                            if(cs.Owner_Phone_Number__c != null)
                                details +=  ' Owner Phone Number : ' + cs.Owner_Phone_Number__c+ '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';

                        }
                        else if(cs.Case_Record_Type__c == 'Other Dangerous'){
                            if(cs.Structure_Collapsing__c!= null)
                                details +=  ' Structure Collapsing : ' + cs.Structure_Collapsing__c+ '. ';
                            if(cs.Under_Construction_or_Demolition__c != null)
                                details +=  ' Under Construction or Demolition : ' + cs.Under_Construction_or_Demolition__c + '. ';
                            if(cs.Structure_Type__c != null)
                                details +=  ' Structure Type : ' + cs.Structure_Type__c+ '. ';
                            if(cs.Location_of_Dangerous_Condition__c != null) 
                                details +=  ' Location of Dangerous Condition : ' + cs.Location_of_Dangerous_Condition__c + '. ';
                            if(cs.Vacant_or_Occupied__c != null) 
                                details +=  ' Vacant or Occupied : ' + cs.Vacant_or_Occupied__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }                        
                        else if(cs.Case_Record_Type__c == 'Tree Dangerous'){
                            if(cs.Life_Threatening_Condition__c!= null)
                                details +=  ' Life Threatening Condition : ' + cs.Life_Threatening_Condition__c + '. ';
                            if(cs.Tree_Between_Sidewalk_and_Curb__c != null)
                                details +=  ' Tree Between Sidewalk and Curb : ' + cs.Tree_Between_Sidewalk_and_Curb__c + '. ';
                            if(cs.Tree_on_Side_Street__c != null)
                                details +=  ' Tree on Side Street : ' + cs.Tree_on_Side_Street__c + '. ';
                            if(cs.Tree_on_Power_Lines_No_Smoke_Fire__c != null)
                                details +=  ' Tree on Power Lines, No Smoke/Fire : ' + cs.Tree_on_Power_Lines_No_Smoke_Fire__c + '. ';
                            if(cs.Blocked_Street_Sidewalk_Home_Access__c!= null)
                                details +=  ' Blocked Street, Sidewalk, Home Access : ' + cs.Blocked_Street_Sidewalk_Home_Access__c+ '. ';
                            if(cs.On_Property_of_Person_Making_Report__c!= null)
                                details +=  ' On Property of Person Making Report : ' + cs.On_Property_of_Person_Making_Report__c+ '. ';
                            if(cs.Overgrown_or_Aready_Fallen__c != null)
                                details +=  ' Overgrown or Already Fallen : ' + cs.Overgrown_or_Aready_Fallen__c + '. ';
                            if(cs.Growing_in_Vacant_Building__c != null)
                                details +=  ' Growing in Vacant Building : ' + cs.Growing_in_Vacant_Building__c + '. ';
                            if(cs.Branches_Break_Easily__c != null)
                                details +=  ' Branches Break Easily : ' + cs.Branches_Break_Easily__c + '. ';
                            if(cs.Leaves_in_Spring_and_Summer__c != null)
                                details +=  ' Leaves in Spring and Summer : ' + cs.Leaves_in_Spring_and_Summer__c + '. ';
                            if(cs.Animals_Living_in_Tree__c!= null)
                                details +=  ' Animals Living in Tree : ' + cs.Animals_Living_in_Tree__c+ '. ';
                            if(cs.Dead_or_Alive_Tree__c != null)
                                details +=  ' Dead or Alive Tree : ' + cs.Dead_or_Alive_Tree__c + '. ';
                            if(cs.How_Many_Trees__c != null)
                                details +=  ' How Many Trees : ' + cs.How_Many_Trees__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                        else if(cs.Case_Record_Type__c == 'Vacant House or Commercial'){
                            if(cs.Residential_or_Commerical__c != null)
                                details +=  ' Residential or Commercial : ' + cs.Residential_or_Commerical__c + '. ';
                            if(cs.Unsafe_Violations__c != null)
                                details +=  ' Unsafe Violations : ' + cs.Unsafe_Violations__c+ '. ';
                            if(cs.Valid_License__c != null)
                                details +=  ' Valid License : ' + cs.Valid_License__c + '. ';
                            if(cs.Property_Open_to_Trespass_on_First_or_Gr__c != null)
                                details +=  ' Property Open to Trespass on First or Grade Floor : ' + cs.Property_Open_to_Trespass_on_First_or_Gr__c+ '. ';
                            if(cs.Access_to_Rear_of_Property_for_Inspectio__c != null)
                                details +=  ' Access to Rear of Property for Inspection : ' + cs.Access_to_Rear_of_Property_for_Inspectio__c + '. ';
                            if(cs.How_to_Access_Rear_of_Property__c != null)
                                details +=  ' How to Access Rear of Property : ' + cs.How_to_Access_Rear_of_Property__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';

                        }
                        else if(cs.Case_Record_Type__c == 'Zoning Business'){
                            if(cs.Request_Type__c != null)
                                details +=  ' Request Type : ' + cs.Request_Type__c + '. ';
                            if(cs.Property_Improperly_Used_as_Residential__c != null)
                                details +=  ' Property Improperly Used as Residential : ' + cs.Property_Improperly_Used_as_Residential__c + '. ';
                            if(cs.Commercial_or_Residential__c != null)
                                details +=  ' Commercial or Residential : ' + cs.Commercial_or_Residential__c + '. ';
                            if(cs.Current_Property_Use__c != null)
                                details +=  ' Commercial or Residential : ' + cs.Current_Property_Use__c + '. ';
                            if(cs.Business_Hours_of_Operation__c != null)
                                details +=  ' Business Hours of Operation : ' + cs.Business_Hours_of_Operation__c + '. ';
                            if(cs.Business_Type__c != null)
                                details +=  ' Business Type : ' + cs.Business_Type__c + '. ';
                            if(cs.Sign_on_Street_Pole_Median_or_Curb__c != null)
                                details +=  ' Sign on Street Pole, Median or Curb : ' + cs.Sign_on_Street_Pole_Median_or_Curb__c+ '. ';
                            if(cs.Sign_Location__c != null)
                                details +=  ' Sign Location : ' + cs.Sign_Location__c + '. ';
                            if(cs.Honor_Box_Outside_Regulated_Area__c != null)
                                details +=  ' Honor Box Outside Regulated Area : ' + cs.Honor_Box_Outside_Regulated_Area__c + '. ';
                            if(cs.Honor_Box_Improperly_Maintained__c != null)
                                details +=  ' Honor Box Improperly Maintained : ' + cs.Honor_Box_Improperly_Maintained__c + '. ';
                            if(cs.Seeking_Refund_for_Vehicle_Not_Released__c != null)
                                details +=  ' Seeking Refund for Vehicle Not Released : ' + cs.Seeking_Refund_for_Vehicle_Not_Released__c + '. ';
                            if(cs.Towing_Business_Name__c != null)
                                details +=  ' Towing Business Name : ' + cs.Towing_Business_Name__c+ '. ';
                            if(cs.Location_Vehicle_Towed_From__c != null)
                                details +=  ' Towing Business Name : ' + cs.Location_Vehicle_Towed_From__c + '. ';
                            if(cs.Towing_Fees_Complaint__c != null)
                                details +=  ' Towing Fees Complaint : ' + cs.Towing_Fees_Complaint__c + '. ';
                            if(cs.Towing_Company_Hours_of_Operation__c != null)
                                details +=  ' Towing Company Hours of Operation : ' + cs.Towing_Company_Hours_of_Operation__c + '. ';
                            if(cs.Zoning_Permit_text__c != null)
                                details +=  ' Zoning_Permit_text__c : ' + cs.Zoning_Permit_text__c + '. ';
                            if(cs.Zoning_License__c != null)
                                details +=  ' Zoning License : ' + cs.Zoning_License__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';

                        }                        
                        else if(cs.Case_Record_Type__c == 'Zoning Residential'){
                            if(cs.Property_Type_multi__c != null)
                                details +=  ' Property Type : ' + cs.Property_Type_multi__c + '. ';
                            if(cs.Owner_Occupied__c != null)
                                details +=  ' Owner Occupied : ' + cs.Owner_Occupied__c + '. ';
                            if(cs.L_I_District__c != null)
                                details +=  ' L&I District : ' + cs.L_I_District__c + '. ';
                            if(cs.L_I_Address__c != null)
                                details +=  ' L&I Address : ' + cs.L_I_Address__c+ '. ';
                        }
                         // Added to add custom fields value for Vacant Lot Clean-Up as per Support Ticket #09036693 
                        else if (cs.Case_Record_Type__c == 'Vacant Lot Clean-Up' )    {
                            if(cs.Lot_Type__c!= null)
                                details +=  ' Lot Type : ' + cs.Lot_Type__c+ '. ';
                            if(cs.Are_there_any_other_issues_with_the_lot__c != null)
                                details +=  ' Are there any other issues with Lot : ' + cs.Are_there_any_other_issues_with_the_lot__c + '. ';
                            if(cs.Is_this_a_tree_issue__c != null)
                                details +=  ' Is this a treet issue : ' + cs.Is_this_a_tree_issue__c+ '. ';                            
                        }
                        cs.Details__c = details;                        
                    }
                   //Added to get Comments from Public Stuff for Sr's other than Cityworks and Hansen 
                    else {
                       cs.Details__c = cs.Description ;                      
                       }                
                }
          //  }
             
            System.debug('Code for Redress Cases Starting');
            integer days = 0 ;
            Case oldCase = null;
            System.debug(Trigger.new.size());
          //  System.debug(Trigger.new);
             
            for(Case cs1:Trigger.new) {
                System.debug('Case Details: ');
                System.debug('Case Details: ' + cs1.CaseNumber + ', '+ cs1.Status + ', ' + cs1.RecordType.Name + ', ' + cs1.Type + ', ' + cs1.Case_Record_Type__c +', ' + cs1.Service_request_Type__c);                     
                System.debug('Id: ' + cs1.id + 'ClosedDate: ' + cs1.ClosedDate + 'Status: ' + cs1.Status);
               //  oldCase = System.Trigger.oldMap.get(cs1.Id);
                if(cs1.ClosedDate != null)  {
                    days = Date.today().daysBetween(date.valueof(cs1.ClosedDate));
                    if(days < 0 )
                        days = days * -1;
                    if((cs1.Department__c == 'Streets Department' || cs1.Department__c == 'Water Department (PWD)' || cs1.Department__c == 'License & Inspections' )&& cs1.Status == 'Redress' && days < 30)    {
                        System.debug('New Case is getting created for Redress Case.');
                        Case newCase = cs1.clone();
                        newCase.Streets_Request_ID__c = null;
                        newCase.Water_Request_ID__c = null;
                        if(newCase.Department__c == 'Streets Department')
                            newCase.Redressed_Street_Request_Id__c = cs1.Streets_Request_ID__c ;
                        else if(newCase.Department__c == 'Water Department (PWD)')
                            newCase.Redressed_Street_Request_Id__c = cs1.Water_Request_ID__c ;
                        newCase.Finish_Date__c = null;
                        newCase.Redressed_Case_Number__c = cs1.CaseNumber;                        
                        insert newCase;
                        System.debug('New Case created.');
                        System.debug('Case Id: ' + newCase.id);
                        cs1.Status = 'Closed'; 
                        cs1.ParentId = newCase.id;                       
                        System.debug('Old case is closed and parent case is assigned');
                    }                   
                }
            }  
            System.debug('Code for Redress Cases Ends');
            String oldStatus = '', newStatus = '';
            String cwRequestID = null;
            
            // For handling forward Status mapping for Streets
            if(Trigger.isUpdate && Trigger.isBefore )   {
                System.debug('Code for Forward Status Mapping');
                for(Case cs : Trigger.new)  {
                    System.debug('Case Details: ' + cs.CaseNumber + ', '+ cs.Status + ', ' + cs.RecordType.Name + ', ' + cs.Type + ', ' + cs.Case_Record_Type__c +', ' + cs.Service_request_Type__c);                     

                    oldCase = System.Trigger.oldMap.get(cs.Id);
                    newStatus = cs.Status;
                    oldStatus = oldCase.Status;
                    if(cs.Streets_Request_ID__c != null && cs.Streets_Request_ID__c != '' )
                        cwRequestID = cs.Streets_Request_ID__c;
                    else if(cs.Water_Request_ID__c != null && cs.Water_Request_ID__c != '' )
                        cwRequestID = cs.Water_Request_ID__c;   
                    System.debug('Old Status: ' + oldStatus + ' Updated Status: ' + newStatus);
                    System.debug('CityWorks Request ID: ' + cwRequestID);
                    if(!oldStatus.equals(newStatus) && cwRequestID != null) {
                        if(oldStatus.equals('Closed'))
                            cs.Status = 'Closed';
                        else if(oldStatus.equals('In-Progress'))    
                            if(!newStatus.equals('Closed'))
                                cs.Status = oldStatus;
                        else if(oldStatus.equals('Open'))          
                            if(newStatus.equals('New'))
                                cs.Status = oldStatus;
                    } 
                }
            }
            //  Forward Status Mapping Code End
            
         }  
    }
}