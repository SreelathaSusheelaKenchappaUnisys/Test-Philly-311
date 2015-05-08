/*
    This trigger is used to do following things:
        -- Closing the Case to Service Not Needed and updated other fields
        -- For Calculating Business Hours Ages.
        -- Update the Case Owner of the Case according to the Case Assignment Rule.
*/

trigger triggerOnCases on Case (before insert, before update, after insert, after update) {
    
    if(Trigger.isBefore)    {
    
       
        
        // For Closing the Case to Service Not Needed and other fields update
        for (Case c : Trigger.New) {
        /*
     // Added to update SLA Type Field support ticket #08951763                   
            if(c.SLA_Type1__c == null){
           
                c.SLA_Type_Temp__c = c.SLA_Type2__c;
            }        
        else      
         c.SLA_Type_Temp__c = c.SLA_Type1__c;
       */
            System.debug('Case Details: ' + c.CaseNumber + ', '+ c.Status + ', ' + c.RecordType.Name + ', ' + c.Type + ', ' + c.Case_Record_Type__c +', ' + c.Service_request_Type__c);
            if(c.Type == 'Information Request Type') {
                if(c.Status == 'Closed')  
                    c.Reason = 'Question Answered';
            }
            
            if(c.Service_Request_Type__c == 'Directory Assistance - IR'){            
                    c.Status = 'Closed';
                    c.Reason = 'Information Provided';
            }
            
            
            // Workflow Implementation for Abandoned Vehicle.
            else if(c.Case_Record_Type__c == 'Abandoned Vehicle')  {
                if(c.Is_there_a_busted_steering_column__c == 'Yes') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Referred to another organization';
                }
             /*else if(c.Make__c == 'None' || c.Color__c == 'None') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                } */
            }
            
            
            // Workflow Implementation for Police Complaint.
            else if(c.Case_Record_Type__c == 'Police Complaint')  {
                if(c.Complaint_or_Compliment__c=='Compliment' || (c.Physical_or_Verbal_Abuse__c=='Physical Abuse' || c.Physical_or_Verbal_Abuse__c=='Verbal Abuse'|| c.Physical_or_Verbal_Abuse__c=='Both')|| c.City_of_Philadelphia_Police__c=='No'|| c.Officer_Breaking_Law__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation for Graffiti Removal.
            else if(c.Case_Record_Type__c == 'Graffiti Removal')  {
                  if(c.Center_City_District__c == 'In')    {
                    
                        //c.Case_Record_Type__c = 'Information Request';
                        c.Service_Request_Type__c = 'Service Not Needed';
                        c.Status = 'Closed';
                        c.Reason = 'Service Not Needed';
                    }  
                    else if(c.Floor__c == '3rd or above' && c.Property_Owner__c == 'Yes')  { 
                        //c.Case_Record_Type__c = 'Information Request';
                        c.Service_Request_Type__c = 'Service Not Needed';
                        c.Status = 'Closed';
                        c.Reason = 'Service Not Needed';
                    } 
               
                   else {
                       if(c.Rail_Corridor__c == 'Yes')    {
                           c.Service_Request_Type__c = 'Service Not Needed';
                           c.Status = 'Closed';
                           c.Reason = 'Service Not Needed';
                       }
                   }                 
               
             }
             
              // Workflow Implementation for Smoke Detector.
            else if(c.Case_Record_Type__c == 'Smoke Detector')  {
                if(c.Philadelphia_Resident__c=='No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            } 
           // Workflow Implementation for Boarding Room House.
            else if(c.Case_Record_Type__c == 'Boarding Room House')  {
              /*  Commenting as per new requirements Case Number 05012710
              if((c.Rental_License__c== 'Yes' && c.Zoning_Permit__c== 'Yes') || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
              if((c.Rental_License__c== 'Yes' && c.Zoning_Permit__c== 'Yes')){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
                         
       
            // Workflow Implementation for Building Construction.
            else if(c.Case_Record_Type__c == 'Building Construction')  {
            /*    Commenting as per new requirements Case Number 05012710
              if(((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4')&& c.Fence_Location__c== 'Front') || ((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4'|| c.Fence_Height_Feet__c== '5' || c.Fence_Height_Feet__c== '6') && c.Fence_Location__c== 'Back') || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */ 
            
                if(((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4')&& c.Fence_Location__c== 'Front') || ((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4'|| c.Fence_Height_Feet__c== '5' || c.Fence_Height_Feet__c== '6') && c.Fence_Location__c== 'Back'))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Type_of_Work_Being_Done__c == 'Building')
                    c.Service_Request_Type__c = 'Building Construction';
                else if(c.Type_of_Work_Being_Done__c == 'Electrical')
                    c.Service_Request_Type__c = 'Electrical Construction';
                else if(c.Type_of_Work_Being_Done__c == 'Plumbing')
                    c.Service_Request_Type__c = 'Plumbing Construction';
                else if(c.Type_of_Work_Being_Done__c == 'Zoning')
                    c.Service_Request_Type__c = 'Zoning Construction';            
            }
            
            
            // Workflow Implementation for Building Dangerous.
         /*   Commenting as per new requirements Case Number 05012710
         else if(c.Case_Record_Type__c == 'Building Dangerous')  {
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }  */ 
            
            
            // Workflow Implementation for Construction Site Task Force.
            else if(c.Case_Record_Type__c == 'Construction Site Task Force')  {
            /* Commenting as per new requirements Case Number 05012710
                if(c.Building_Collapsing__c == 'Yes' || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                if(c.Building_Collapsing__c == 'Yes'){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation DayCare Residential or Commercial.
            
            else if(c.Case_Record_Type__c == 'Daycare Residential or Commercial')  {
             /* Commenting as per new requirements Case Number 05012710
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                } */
                if(c.Residential_or_Commerical__c=='Residential')
                    c.Service_Request_Type__c = 'Daycare Residential';
                else if(c.Residential_or_Commerical__c=='Commercial')
                    c.Service_Request_Type__c = 'Daycare Commercial';
            } 
            
            
            // Workflow Implementation for Emergency Air Conditioning.
            else if(c.Case_Record_Type__c == 'Emergency Air Conditioning')  {
            /* Commenting as per new requirements Case Number 05012710
                if((c.Heat_Emergency__c== 'No'|| c.Nursing_Personal_Care_Home_Hospital__c== 'No')|| ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))*/
                if((c.Heat_Emergency__c== 'No'|| c.Nursing_Personal_Care_Home_Hospital__c== 'No')){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation Fire Residential or Commercial.
            else if(c.Case_Record_Type__c == 'Fire Residential or Commercial')  {
            /*Commenting as per new requirements Case Number 05012710
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                } */
                if(c.Residential_or_Commerical__c=='Residential')
                    c.Service_Request_Type__c = 'Fire Residential';
                else if(c.Residential_or_Commerical__c=='Commercial')
                    c.Service_Request_Type__c = 'Fire Commercial';
            }  
            
            
            // Workflow Implementation for Infestation Residential.
            else if(c.Case_Record_Type__c == 'Infestation Residential')  {
            /*Commenting as per new requirements Case Number 05012710
                if((c.Residential_or_Commerical__c== 'Commercial' || c.Infestation_Type__c== 'Rats'|| c.Infestation_Type__c== 'Fleas' || c.Infestation_Type__c== 'Bedbugs' || c.Report_Type__c== 'Own Residence' || c.Tenant_in_Single_Family_Dwelling__c== 'Yes') ||((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                    if((c.Residential_or_Commerical__c== 'Commercial' || c.Infestation_Type__c== 'Rats'|| c.Infestation_Type__c== 'Fleas' || c.Infestation_Type__c== 'Bedbugs' || c.Report_Type__c== 'Own Residence' || c.Tenant_in_Single_Family_Dwelling__c== 'Yes')){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for License Residential.
            else if(c.Case_Record_Type__c == 'License Residential')  {
            /*Commenting as per new requirements Case Number 05012710           
                if((c.License_to_Rent__c== 'Yes' && c.Zoning_Permit__c== 'Yes') || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))*/
                if((c.License_to_Rent__c== 'Yes' && c.Zoning_Permit__c== 'Yes') ){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Maintenance Residential or Commercial.
            else if(c.Case_Record_Type__c == 'Maintenance Residential or Commercial')  {
            /*Commenting as per new requirements Case Number 05012710       
                if(c.Flooded_Residential_Basement__c== 'Yes' || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                 if(c.Flooded_Residential_Basement__c== 'Yes'){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                if(c.Residential_or_Commerical__c=='Residential')
                    c.Service_Request_Type__c = 'Maintenance Residential';
                else if(c.Residential_or_Commerical__c=='Commercial')
                    c.Service_Request_Type__c = 'Maintenance Commercial';
            } 
            
            
            // Workflow Implementation for No Heat (Residential).
            else if(c.Case_Record_Type__c == 'No Heat (Residential)')  {
            /*Commenting as per new requirements Case Number 05012710   
                if(c.Residential_or_Commerical__c== 'Commercial' || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                 if(c.Residential_or_Commerical__c== 'Commercial'){
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation for Other Dangerous.
            else if(c.Case_Record_Type__c == 'Other Dangerous')  {
            /*Commenting as per new requirements Case Number 05012710   
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL) || c.Structure_Collapsing__c == 'Yes')*/
                if(c.Structure_Collapsing__c == 'Yes'){                  
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            } 
            
            // Workflow Implementation for Tree Dangerous.
            else if(c.Case_Record_Type__c == 'Tree Dangerous')  {
               /* Commenting as per new requirements Case Number 05012710
               if(c.Tree_on_Power_Lines_No_Smoke_Fire__c=='Yes' || c.Blocked_Street_Sidewalk_Home_Access__c=='Yes' || c.On_Property_of_Person_Making_Report__c=='Yes' || ((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                 if(c.Tree_on_Power_Lines_No_Smoke_Fire__c=='Yes' || c.Blocked_Street_Sidewalk_Home_Access__c=='Yes' || c.On_Property_of_Person_Making_Report__c=='Yes'){
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

             // Workflow Implementation for Vacant House or Commercial.
            else if(c.Case_Record_Type__c == 'Vacant House or Commercial')  {
               /* Commenting as per new requirements Case Number 05012710 
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }*/
                 if(c.Residential_or_Commerical__c=='Residential')
                    c.Service_Request_Type__c = 'Vacant House';
                else if(c.Residential_or_Commerical__c=='Commercial')
                    c.Service_Request_Type__c = 'Vacant Commercial';
            }
            
            // Workflow Implementation for Zoning Business.
            else if(c.Case_Record_Type__c == 'Zoning Business')  {
            /* Commenting as per new requirements Case Number 05012710
                if((c.Sign_on_Street_Pole_Median_or_Curb__c== 'Yes' || c.Honor_Box_Outside_Regulated_Area__c== 'Yes' ||  c.Seeking_Refund_for_Vehicle_Not_Released__c== 'Yes') ||((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL)) */
                
                if((c.Sign_on_Street_Pole_Median_or_Curb__c== 'Yes' || c.Honor_Box_Outside_Regulated_Area__c== 'Yes' ||  c.Seeking_Refund_for_Vehicle_Not_Released__c== 'Yes')) {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Zoning Residential.
          /*  else if(c.Case_Record_Type__c == 'Zoning Residential')  {
                if(((c.L_I_Address__c== NULL || c.L_I_Address__c == '') && c.Centerline_2272x__c!=NULL))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            } */
            
            // Workflow Implementation for Parks Recreation safety and Maintenance.
            else if(c.Case_Record_Type__c == 'Parks and Rec Safety and Maintenance')  {
                if(c.Reported_to_911__c == 'No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Emergency';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
         
         
            // Workflow Implementation for Street Defect.
            else if(c.Case_Record_Type__c == 'Street Defect')  {
                if(c.Running_Water__c == 'Yes' || c.On_State_Highway__c == 'Yes' || (c.Utility_Company__c != null && c.Utility_Company__c != '' && c.Utility_Company__c != 'Not Known')) {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                 if(c.Crack_in_Street_Depression_or_a_Hole_i__c == 'Depression')
                    c.Service_Request_Type__c = 'Depression';
                else if(c.Crack_in_Street_Depression_or_a_Hole_i__c == 'Push-Up')
                    c.Service_Request_Type__c = 'Push-Up';    
                
            }
            
   
            
            // Workflow Implementation for Rubbish Collection.
            else if(c.Case_Record_Type__c == 'Rubbish/Recyclable Material Collection')  {
            /* support Case Number Fix - Case Number - 05013038
                if(c.Set_Out_in_Time__c == 'No' || c.Where_Was_Trash_Set_Out__c == 'Other' || c.Not_More_than_Maximum_Number_of_Receptac__c  == 'No' || c.Construction_Bulk_Items__c == 'Yes' || c.Not_More_than_Maximum_Weight__c == 'No' || c.Proper_Recycling_Container__c == 'No' || c.Are_Materials_Hazardous__c == 'Household Hazardous Waste' || c.Are_Materials_Hazardous__c == 'Commercial Hazardous Waste') */
                  if(c.Set_Out_in_Time__c == 'No' || c.Where_Was_Trash_Set_Out__c == 'Other' || c.Not_More_than_Maximum_Number_of_Receptac__c  == 'Yes' || c.Construction_Bulk_Items__c == 'Yes' || c.Not_More_than_Maximum_Weight__c == 'Yes' || c.Proper_Recycling_Container__c == 'No' || c.Are_Materials_Hazardous__c == 'Household Hazardous Waste' || c.Are_Materials_Hazardous__c == 'Commercial Hazardous Waste') { 
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Type_of_Rubbish_Missed__c == 'Both' || c.Type_of_Rubbish_Missed__c == 'Rubbish') {
                    c.Service_Request_Type__c = 'Rubbish Collection';                
                }
                else if(c.Type_of_Rubbish_Missed__c == 'Recycling')
                    c.Service_Request_Type__c = 'Recyclables Collection';
               
            }
            
              // Workflow Implementation for Street Light Outage.
            else if(c.Case_Record_Type__c == 'Street Light Outage') {
               if(c.Private_Property__c == 'Yes') {
                     c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Is_the_Light_Illuminating_a_Street__c == 'Yes') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }                
                else if(c.Problem_Type__c== 'Other' || c.Problem_Type__c== 'Request for New Lighting' ) {
                    c.Service_Request_Type__c = 'Street Light(Other)';
                }
                else {
                    c.Service_Request_Type__c = 'Street Light Outage';
                }
                
                if(c.Service_Request_Type__c == 'Street Light Outage')    {
                 
                if(c.Problem_Type__c== 'Bulb Hanging' || c.Problem_Type__c== 'Pole Down' || c.Problem_Type__c== 'Wire Down' || c.Problem_Type__c== 'Wires Sparking' ) {
                    c.Hazardous__c = 'Yes';
                }
                else 
                    c.Hazardous__c = 'No';  
                }
            }
            
            // Workflow Implementation for Abandoned Bike.
             else if(c.Case_Record_Type__c == 'Abandoned Bike')  {
                if(c.Tagged_With_Yellow_Alert_Notice__c=='Yes' || (c.Tagged_With_Yellow_Alert_Notice__c=='No' && c.Missing_Damaged_Parts__c=='No' && c.Unusable__c=='No'&& (c.Time_Locked_in_Same_Location__c=='Less than One Month' || c.Time_Locked_in_Same_Location__c=='Not Locked')))  {
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

            // Workflow Implementation for Alley Light Outage.
            else if(c.Case_Record_Type__c == 'Alley Light Outage')  {
                if(c.Alley_Type__c=='New Alley' || c.Alley_Type__c=='New Driveway')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            
            // Workflow Implementation for Complaint (Streets).
            else if(c.Case_Record_Type__c == 'Complaint (Streets)')  {
                if(c.Previous_Case_found__c=='Yes' || c.Rubbish_Issue__c=='Noise' || c.Property_Loss_Claim__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            
            // Workflow Implementation for Dead Animal in Street.
            else if(c.Case_Record_Type__c == 'Dead Animal in Street')  {
                if((c.Animal_Location__c=='Private Property' || c.Animal_Location__c=='Sidewalk' || c.Animal_Location__c=='Alley' || c.Animal_Location__c=='State Highway' || c.Animal_Location__c=='In Home')|| c.Animal_is_Visible_and_Accessible__c== 'No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                    
                }
            }
            
             // Workflow Implementation for Manhole Cover.
            else if(c.Case_Record_Type__c == 'Manhole Cover')  {
                if(c.Property_Owner_Manhole__c=='PWD' || c.Property_Owner_Manhole__c=='PGW' || c.Property_Owner_Manhole__c=='PECO' || c.Property_Owner_Manhole__c=='SEPTA' || c.Property_Owner_Manhole__c=='VERIZON')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation for NewsStand Outdoor Cafe.
            else if(c.Case_Record_Type__c == 'Newsstand Outdoor Cafe')  {
                if(c.On_the_City_s_Public_Right_Of_Way__c=='No' || (c.Required_Amount_of_Sidewalk_Space__c=='Yes' && c.Caf_Tables_and_Chair_Out_Before7_PM__c=='No') || c.Caf_Tables_and_Chair_Out_Before7_PM__c=='No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Stop Sign Repair.
            else if(c.Case_Record_Type__c == 'Stop Sign Repair')  {
                if(c.Not_Visible__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';                    
                }
                if(c.Issue__c=='Knocked Down' || c.Not_Visible__c=='Yes' || c.Issue__c=='Missing') {
                    c.Hazardous__c = 'Yes';
                }
                else
                    c.Hazardous__c = 'No';
            }
            
            // Workflow Implementation for Street Paving.
            else if(c.Case_Record_Type__c == 'Street Paving')  {
                if(c.Resurfacing_Request__c=='No' && c.Resurfacing_defect__c == 'No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            
            // Workflow Implementation for Street Trees.
            else if(c.Case_Record_Type__c == 'Street Trees')  {
                if((c.Tree_in_Alley_Frontyard_or_Backyard__c=='Yes' && c.Property_Owner_Street_Trees__c=='Yes')  || (c.Tree_Location__c == 'Other'))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation for Traffic Signal Emergency.
            else if(c.Case_Record_Type__c == 'Traffic Signal Emergency')  {
                if(c.Request_for_New_Traffic_Signal__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if((c.Request_to_Modify_Traffic_Signal_Operati__c == 'Yes') || (c.Signal_Type__c == 'Signal Other') || (c.Blocked_by_Tree_Branches_or_Foliage__c == 'Yes') || ((c.Signal_Type__c != 'Traffic Signal') && (c.Problem_Type__c != 'Knocked Down')))
                    c.Service_Request_Type__c = 'Traffic (Other)';
            }
            
            
             // Workflow Implementation for Salting.
            else if(c.Case_Record_Type__c == 'Salting')  {
                if(c.Problem_Type__c == 'Icy Road Surface')  {
                    c.Service_Request_Type__c = 'Icy Road Surface';                    
                }
                else if(c.Problem_Type__c == 'Snow Removal')
                    c.Service_Request_Type__c = 'Snow Removal'; 
            }
            
            //Workflow implementation for Inlet Cleaning
            else if(c.Case_Record_Type__c == 'Inlet Cleaning')  {
                if(c.Heavy_Rain__c== 'Yes' || c.Flooding__c=='Yes' || c.Obstructing_Traffic__c=='Yes' || c.Bad_Odor__c=='Yes' || c.Cover_Missing_or_Broken__c == 'Yes' || c.Water_in_Basement_or_Cellar__c == 'Yes' || c.Illegal_Dumping__c == 'Yes')  {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';                   
                } 
            }
            
            
            // For Closing Child Case        
            if(c.parentId != null)    {
                Case pCase = [Select id, CaseNumber, Redress_Case__c , Service_Request_Type__c , Type_of_Rubbish_Missed__c , Violation_Type__c from Case where id =: c.parentId ];
                if (c.Status != 'Closed' && c.Redress_Case__c == FALSE && c.Type != null){
                    if(c.Service_Request_Type__c != 'Recyclables Collection' && c.Service_Request_Type__c != 'Dumpster Violation')
                        c.Status = 'Closed';
                    else if(c.Service_Request_Type__c == 'Recyclables Collection')    {
                        if( !(pCase.Service_Request_Type__c == 'Rubbish Collection' && c.Type_of_Rubbish_Missed__c == 'Both' && pCase.Type_of_Rubbish_Missed__c == 'Both'))    {
                            c.Status = 'Closed';
                        }
                            
                    }
                    else if(c.Service_Request_Type__c == 'Dumpster Violation')    {
                        if(!( pCase.Service_Request_Type__c == 'Sanitation Violation' && c.Violation_Type__c == 'Both' && pCase.Violation_Type__c == 'Both'))
                            c.Status = 'Closed';
                    }
                } 
            } 
            
          
           
            //Workflow implementation for Dumpster/Sanitation Violation
             else if(c.Case_Record_Type__c == 'Sanitation / Dumpster Violation')  {
                if(c.Is_Trash_on_Curb_Now__c == 'No'|| c.Can_With_Secure_Lid_Against_House__c == 'Yes' || c.Property_with_Private_Trash_Collection__c == 'Yes' || c.Dumpster_at_Restaurant__c == 'Yes' || c.Dumpster_Open_to_Public__c == 'No' || c.Dumpster_on_Private_Property__c=='Yes' || (c.Dumpster_on_Private_Property__c=='Yes' && c.Dumpster_Overflowing__c == 'Yes') ||(c.Dumpster_Type__c == 'Construction' && c.Dumpster_Blocking_Street__c == 'Yes' && c.Right_of_Way_Permit__c == 'Yes' && c.Dumpster_Public_Right_of_Way_License__c == 'yes')|| (c.Dumpster_Blocking_Sidewalk__c == 'Yes' && c.Dumpster_Enclosed_in_Fence__c == 'Yes'))  {
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Violation_Type__c=='Both' || c.Violation_Type__c=='Sanitation') 
                    c.Service_Request_Type__c = 'Sanitation Violation';
                else if(c.Violation_Type__c=='Dumpster')    
                     c.Service_Request_Type__c = 'Dumpster Violation';
            } 
           
          
            
          }   
        //For Calculating Business Hours Ages
    /*    if (Trigger.isInsert) {
            for (Case updatedCase:System.Trigger.new) {
                updatedCase.Last_Status_Change__c = System.now();
                updatedCase.Time_With_Customer__c = 0;
                updatedCase.Time_With_Support__c = 0;
            }
        } 
        else {
            //Get the stop statuses
            Set<String> stopStatusSet = new Set<String>();
            for (Stop_Status__c stopStatus:[Select Name From Stop_Status__c]) {
                stopStatusSet.add(stopStatus.Name);
            }

            //Get the default business hours (we might need it)
            BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true];

            //Get the closed statuses (because at the point of this trigger Case.IsClosed won't be set yet)
            Set<String> closedStatusSet = new Set<String>();
            for (CaseStatus status:[Select MasterLabel From CaseStatus where IsClosed=true]) {
                closedStatusSet.add(status.MasterLabel);
            }

            //For any case where the status is changed, recalc the business hours in the buckets
            for (Case updatedCase:System.Trigger.new) {
                Case oldCase = System.Trigger.oldMap.get(updatedCase.Id);

                if (oldCase.Status!=updatedCase.Status && updatedCase.Last_Status_Change__c!=null) {
                    //OK, the status has changed
                    if (!oldCase.IsClosed) {
                        //We only update the buckets for open cases

              //On the off-chance that the business hours on the case are null, use the default ones instead
                        Id hoursToUse = updatedCase.BusinessHoursId!=null?updatedCase.BusinessHoursId:defaultHours.Id;

                        //The diff method comes back in milliseconds, so we divide by 3600000 to get hours.
                        Double timeSinceLastStatus = BusinessHours.diff(hoursToUse, updatedCase.Last_Status_Change__c, System.now())/3600000.0;
                        System.debug(timeSinceLastStatus);

                        //We decide which bucket to add it to based on whether it was in a stop status before
                        if (stopStatusSet.contains(oldCase.Status)) {
                            updatedCase.Time_With_Customer__c += timeSinceLastStatus;
                        } else {
                            updatedCase.Time_With_Support__c += timeSinceLastStatus;
                        }

              if (closedStatusSet.contains(updatedCase.Status)) {
                          updatedCase.Case_Age_In_Business_Hours__c = updatedCase.Time_With_Customer__c + updatedCase.Time_With_Support__c;
              }
                    }

                    updatedCase.Last_Status_Change__c = System.now();
                }
            }
        }*/
    }
     
    //For changing Case Owner
    //  Updated the code for Support ticket #00005373
    else if(Trigger.isAfter)        {
        Set<Id> CaseId = new Set<Id>();
        if(Trigger.isInsert)    {   
            if (!CaseFieldUpdate.inFutureContext) {
                for (Case c : Trigger.new) {
                    System.debug('Case Details: ' + c.CaseNumber + ', '+ c.Status + ', ' + c.RecordType.Name + ', ' + c.Type + ', ' + c.Case_Record_Type__c +', ' + c.Service_request_Type__c);
                    CaseId.add(c.id);
                }    
            
                if (!CaseId.isEmpty())
                    CaseAssignmentProcessor.processCases(CaseId);
            }         
        }    
         if(Trigger.isUpdate)    { 
            if (!CaseFieldUpdate.inFutureContext) {
                System.debug('After Update Assignment Rule.');
                for (Case c : Trigger.new) {
                    System.debug('Case Details: ' + c.CaseNumber + ', '+ c.Status + ', ' + c.RecordType.Name + ', ' + c.Type + ', ' + c.Case_Record_Type__c +', ' + c.Service_request_Type__c);
                    Case oldCase = Trigger.oldMap.get(c.Id);
                    system.debug('old case is'+oldCase);
                    List<Group> g = [Select id, Name from Group where id =: c.OwnerId LIMIT 1];    
                    String ownerName = '';                
                    if(g != null && g.size() == 1)
                        ownerName = g[0].Name;
                    System.debug('Old Service Request Type: ' + oldCase.Service_Request_Type__c);
                    System.debug('New Service Request Type: ' + c.Service_Request_Type__c);
                    System.debug('Status: ' + c.Status);
                    
                    if(c.Department__c != 'Streets Department' && c.Department__c != 'Water Department (PWD)')    {
                    
                        if(c.Status == 'Closed' || c.Service_Request_Type__c  != oldCase.Service_Request_Type__c )
                            CaseId.add(c.id);
                        else if(ownerName != null && ownerName == 'CitiWorks Reject')
                            CaseId.add(c.id);
                    }
                    else  {        
                        if(ownerName != null && ownerName == 'CitiWorks Reject' && c.Centerline_2272x__c != null && c.Centerline_2272x__c != 0 && c.Centerline_2272x__c != 0.0)
                            CaseId.add(c.id);  
                        else if(c.Status == 'Closed' || c.Service_Request_Type__c  != oldCase.Service_Request_Type__c )
                            CaseId.add(c.id);                        
                    }        
                }
                
                if (!CaseId.isEmpty())
                    CaseAssignmentProcessor.processCases(CaseId);
            }                 
        } 
       //For support ticket 08990209-  change done for concatenation of 'None' string to comments field in salesforce whenever they are null from all the sources.
         //For support ticket 08990209-  change done for concatenation of 'None' string to comments field in salesforce whenever they are null from all the sources.
         for(Case c:Trigger.new) {
              if(!test.IsRunningTest()) {
                  Case cs = [Select id, Description from case where id =: c.Id LIMIT 1];  
                  if (String.isBlank(c.description) ) {    //c.Description == null || c.Description == ''
                         //For support ticket 09097824  - change done to replace 'None' with a period '.' - start
                         //cs.Description = 'None';
                         cs.Description = '.';
                          //For support ticket 09097824  - change done to replace 'None' with a period '.' - start
                         update cs;
                  }
              
                  
              }
        }            
    }
}