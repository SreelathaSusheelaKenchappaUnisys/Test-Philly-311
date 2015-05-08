public class CaseWorkflowRules {

    public void triggerWorkflow(Set<Id> caseId) {
      
        List<Case> updatedCase = [Select id, CaseNumber, Type, Status, Reason, Department__c, Case_Record_Type__c, RecordType.Name, Service_Request_Type__c
                                      from Case WHERE id IN: caseId];
          
        for(Case c : updatedCase)    {
        
            if(c.Type == 'Information Request Type') {
                if(c.Status == 'Closed')  
                    c.Reason = 'Question Answered';
            }
            
            if(c.Service_Request_Type__c == 'Directory Assistance - IR'){
            
                c.Status = 'Closed';
                c.Reason = 'Information Provided';
            }
            
            /*
            // Workflow Implementation for Abandoned Vehicle.
            else if(c.Case_Record_Type__c == 'Abandoned Vehicle')  {
                if(c.Is_there_a_busted_steering_column__c == 'Yes') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Stolen';
                }
                else if(c.Make__c == 'None' || c.Color__c == 'None') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Street Defect.
            else if(c.Case_Record_Type__c == 'Street Defect')  {
                if(c.Running_Water__c == 'Yes' || c.On_State_Highway__c == 'Yes' || c.Utility_Company__c != 'Not Known') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
        
            // Workflow Implementation for Illegal Dumping.
            else if(c.Case_Record_Type__c == 'Illegal Dumping')     {
                if((c.Trash_Include_Commercial_Hazardous_Waste__c == 'Yes') || (c.Is_Trash_on_Street_or_Sidewalk__c == 'No') || (c.Trash_Include_Commercial_Hazardous_Waste__c == 'Yes')) {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                }
                else if((c.Is_Trash_on_Vacant_Lot__c == 'Yes') || (c.Is_there_active_construction_at_the_site__c == 'Yes')) {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                }                
            }
        
            // Workflow Implementation for Graffiti Removal.
            else if(c.Case_Record_Type__c == 'Graffiti Removal')  {
                if(c.Center_City_District__c == 'In')    {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                }  
                else if(c.Floor__c == '3rd or above' && c.Property_Owner__c == 'Yes')  { 
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                }
                else {
                    if(c.Rail_Corridor__c == 'Yes')    {
                        c.Service_Request_Type__c = 'Service Not Needed';
                        c.Status = 'Closed';
                    }
                }                 
            }
       

            // Workflow Implementation for Rubbish Collection.
            else if(c.Case_Record_Type__c == 'Rubbish/Recyclable Material Collection')  {
                if(c.Set_Out_in_Time__c == 'No' || c.Where_Was_Trash_Set_Out__c == 'Other' || c.Not_More_than_Maximum_Number_of_Receptac__c  == 'Yes' || c.Construction_Bulk_Items__c == 'Yes' || c.Not_More_than_Maximum_Weight__c == 'Yes' || c.Proper_Recycling_Container__c == 'No' || c.Are_Materials_Hazardous__c == 'Household Hazardous Waste' || c.Are_Materials_Hazardous__c == 'Commercial Hazardous Waste')    {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                }
               
            }

            // Workflow Implementation for Street Light Outage.
            else if(c.Case_Record_Type__c == 'Street Light Outage') {
                if(c.Is_Light_on_Public_Property__c== 'Yes')  {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Private_Property__c == 'Yes') {
                     c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
                else if(c.Is_the_Light_Illuminating_a_Street__c == 'Yes') {
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }                
                if(c.Problem_Type__c== 'Other' || c.Problem_Type__c== 'Request for New Lighting' ) {
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
            */
            if(c.Case_Record_Type__c == 'Traffic Signal Emergency'){
                 
                 if(c.Service_Request_Type__c != 'Traffic (Other)' && c.Service_Request_Type__c != 'Service Not Needed') {
                    c.Emergency__c= 'Yes';}
                 else 
                     c.Emergency__c= 'No';  
                }  
          /*
          else if(c.Case_Record_Type__c == 'Sanitation / Dumpster Violation' || c.RecordTypeId == '012J0000000918h' )  {
                if(c.Is_Trash_on_Curb_Now__c == 'Yes'|| c.Can_With_Secure_Lid_Against_House__c == 'Yes' || c.Property_with_Private_Trash_Collection__c == 'Yes' || c.Dumpster_at_Restaurant__c == 'Yes' || c.Dumpster_Open_to_Public__c == 'No' ||(c.Dumpster_Type__c == 'Construction' && c.Dumpster_Blocking_Street__c == 'Yes' && c.Right_of_Way_Permit__c == 'Yes' && c.Dumpster_Public_Right_of_Way_License__c == 'yes')|| (c.Dumpster_Blocking_Sidewalk__c == 'Yes' && c.Dumpster_Enclosed_in_Fence__c == 'Yes'))  {
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            } 
         
         
            // Workflow Implementation for Building Dangerous.
            else if(c.Case_Record_Type__c == 'Building Dangerous' || c.RecordTypeId == '012J00000000XIe' )  {
                if(c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }   
            
           // Workflow Implementation DayCare Residential or Commercial.
            else if(c.Case_Record_Type__c == 'Daycare Residential or Commercial' || c.RecordTypeId == '012J00000000XGd' )  {
                if(c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }   
            
           // Workflow Implementation Fire Residential or Commercial.
            else if(c.Case_Record_Type__c == 'Fire Residential or Commercial' || c.RecordTypeId == '012J0000000DCWU' )  {
                if(c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }    

            // Workflow Implementation for License Residential.
            else if(c.Case_Record_Type__c == 'License Residential' || c.RecordTypeId == '012J0000000DDcd' )  {
                if((c.License_to_Rent__c== 'Yes' && c.Zoning_Permit__c== 'Yes') || c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

           // Workflow Implementation for Maintenance Residential or Commercial.
            else if(c.Case_Record_Type__c == 'Maintenance Residential or Commercial' || c.RecordTypeId == '012J0000000DDP0' )  {
                if(c.Problem_Location_at_House_or_Unit__c== 'Public Right of Way' || (c.Drainage_Problem__c== 'Yes' && c.Flooded_Residential_Basement__c== 'Yes'&& c.Property_Owner__c== 'Yes') || c.L_I_Address__c== 'NULL') {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
           

              // Workflow Implementation for Emergency Air Conditioning.
            else if(c.Case_Record_Type__c == '  Emergency Air Conditioning' || c.RecordTypeId == '012J0000000DEKu' )  {
                if((c.Heat_Emergency__c== 'No'|| c.Nursing_Personal_Care_Home_Hospital__c== 'No')|| c.L_I_Address__c== 'NULL') {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

           // Workflow Implementation for Zoning Business.
            else if(c.Case_Record_Type__c == 'Zoning Business' || c.RecordTypeId == '012J0000000DDRG' )  {
                if((c.Sign_on_Street_Pole_Median_or_Curb__c== 'Yes' || c.Honor_Box_Outside_Regulated_Area__c== 'Yes' || c.Honor_Box_Improperly_Maintained__c== 'Yes' || c.Seeking_Refund_for_Vehicle_Not_Released__c== 'Yes') || c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
           // Workflow Implementation for Zoning Residential.
            else if(c.Case_Record_Type__c == 'Zoning Residential' || c.RecordTypeId == '012J0000000DCsG' )  {
                if(c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Construction Site Task Force.
            else if(c.Case_Record_Type__c == 'Construction Site Task Force' || c.RecordTypeId == '012J0000000DCQv' )  {
                if(c.Demolition_Occurred_More_Than_Year_Ago__c == 'Yes'|| c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            // Workflow Implementation for Infestation Residential.
            else if(c.Case_Record_Type__c == 'Infestation Residential' || c.RecordTypeId == '012J0000000DDph' )  {
                if((c.Residential_or_Commerical__c== 'Commercial' || c.Infestation_Type__c== 'Rats'|| c.Infestation_Type__c== 'Fleas' || c.Infestation_Type__c== 'Bedbugs' || c.Report_Type__c== 'Own Residence' || c.Tenant_in_Single_Family_Dwelling__c== 'Yes') || c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            // Workflow Implementation for Vacant House or Commercial.
            else if(c.Case_Record_Type__c == 'Vacant House or Commercial' || c.RecordTypeId == '012J0000000DCsQ' )  {
                if(c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

            // Workflow Implementation for Building Construction.
            else if(c.Case_Record_Type__c == 'Building Construction' || c.RecordTypeId == '012J00000000XyG' )  {
                if(((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4')&& c.Fence_Location__c== 'Front') || ((c.Fence_Height_Feet__c== 'Under 4'|| c.Fence_Height_Feet__c== '4'|| c.Fence_Height_Feet__c== '5' || c.Fence_Height_Feet__c== '6') && c.Fence_Location__c== 'Back') || c.Storage_Shed_Size_Square_Feet__c=='120 or Less' || c.Paved_Area_to_Create_Parking_Space__c=='No' || c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

           // Workflow Implementation for No Heat (Residential).
            else if(c.Case_Record_Type__c == 'No Heat (Residential)' || c.RecordTypeId == '012J00000000Wye' )  {
                if(c.Residential_or_Commerical__c== 'Commercial' || c.L_I_Address__c== 'NULL')  {
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

             // Workflow Implementation for Other Dangerous.
            else if(c.Case_Record_Type__c == 'Other Dangerous' || c.RecordTypeId == '012J0000000DDc9' )  {
                if(c.L_I_Address__c== 'NULL')  {
                  
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

              
       // Workflow Implementation for Tree Dangerous.
            else if(c.Case_Record_Type__c == 'Tree Dangerous' || c.RecordTypeId == '012J0000000DD0o' )  {
                if(c.Tree_on_Power_Lines_No_Smoke_Fire__c=='Yes' || c.Blocked_Street_Sidewalk_Home_Access__c=='Yes' || c.On_Property_of_Person_Making_Report__c=='Yes' || c.L_I_Address__c== 'NULL')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

           
           // Workflow Implementation for Abandoned Bike.
             else if(c.Case_Record_Type__c == 'Abandoned Bike' || c.RecordTypeId == '012J0000000DCcm' )  {
                if(c.Tagged_With_Yellow_Alert_Notice__c=='Yes' || (c.Tagged_With_Yellow_Alert_Notice__c=='No' && c.Missing_Damaged_Parts__c=='No' && c.Unusable__c=='No'&& (c.Time_Locked_in_Same_Location__c=='Less than One Month' || c.Time_Locked_in_Same_Location__c=='Not Locked')))  {
                    
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }

          // Workflow Implementation for Dead Animal in Street.
            else if(c.Case_Record_Type__c == 'Dead Animal in Street' || c.RecordTypeId == '012J0000000DCk2' )  {
                if((c.Animal_Location__c=='Private Property' || c.Animal_Location__c=='Sidewalk' || c.Animal_Location__c=='Alley' || c.Animal_Location__c=='State Highway' || c.Animal_Location__c=='In Home')|| c.Animal_is_Visible_and_Accessible__c== 'No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                    
                }
            }
       
           // Workflow Implementation for Manhole Cover.
            else if(c.Case_Record_Type__c == 'Manhole Cover' || c.RecordTypeId == '012J0000000DCkM' )  {
                if(c.Property_Owner_Manhole__c=='PWD' || c.Property_Owner_Manhole__c=='PGW' || c.Property_Owner_Manhole__c=='PECO' || c.Property_Owner_Manhole__c=='SEPTA' || c.Property_Owner_Manhole__c=='VERIZON')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
       
           // Workflow Implementation for NewsStand Outdoor Cafe.
            else if(c.Case_Record_Type__c == 'Newsstand Outdoor Cafe' || c.RecordTypeId == '012J0000000DCoT')  {
                if(c.On_the_City_s_Public_Right_Of_Way__c=='No' || c.Required_Amount_of_Sidewalk_Space__c=='Yes' || c.Caf_Tables_and_Chair_Out_Before7_PM__c=='No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
       
       // Workflow Implementation for Salting.
            else if(c.Case_Record_Type__c == 'Salting' || c.RecordTypeId == '012J0000000DCnf')  {
                if(c.Supervisor_Notice__c=='No' || c.Street_Type__c=='Secondary')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
           
           // Workflow Implementation for Stop Sign Repair.
            else if(c.Case_Record_Type__c == 'Stop Sign Repair' || c.RecordTypeId == '012J0000000DCnV')  {
                if(c.Not_Visible__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
       
                // Workflow Implementation for Street Paving.
            else if(c.Case_Record_Type__c == 'Street Paving' || c.RecordTypeId == '012J0000000DCkR')  {
                if(c.Resurfacing_Request__c=='No')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            
           // Workflow Implementation for Traffic Signal Emergency.
            else if(c.Case_Record_Type__c == 'Traffic Signal Emergency' || c.RecordTypeId == '012J0000000DCip')  {
                if(c.Request_for_New_Traffic_Signal__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Alley Light Outage.
            else if(c.Case_Record_Type__c == 'Alley Light Outage' || c.RecordTypeId == '012J0000000DCgj')  {
                if(c.Alley_Type__c=='New alley' || c.Alley_Type__c=='New driveway')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            
            // Workflow Implementation for Complaint (Streets).
            else if(c.Case_Record_Type__c == 'Complaint (Streets)' || c.RecordTypeId == '012J0000000DCk7')  {
                if(c.Previous_Case_found__c=='Yes' || c.Rubbish_Issue__c=='Noise' || c.Property_Loss_Claim__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
            // Workflow Implementation for Street Defect.
            else if(c.Case_Record_Type__c == 'Street Defect' || c.RecordTypeId == '012J0000000DCpb')  {
                if(c.Inside_or_Within_18_of_Trolley_Tracks__c=='Yes' || c.On_State_Highway__c=='Yes' || c.Running_Water__c=='Yes'|| c.Private_Road__c=='Yes'|| (c.Utility_Company__c=='PWD'|| c.Utility_Company__c=='PGW'|| c.Utility_Company__c=='PECO'))  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
             // Workflow Implementation for Police Complaint.
            else if(c.Case_Record_Type__c == 'Police Complaint' || c.RecordTypeId == '012J0000000DESj')  {
                if(c.Complaint_or_Compliment__c=='Compliment' || (c.Physical_or_Verbal_Abuse__c=='Physical Abuse' || c.Physical_or_Verbal_Abuse__c=='Verbal Abuse'|| c.Physical_or_Verbal_Abuse__c=='Both')|| c.City_of_Philadelphia_Police__c=='No'|| c.Officer_Breaking_Law__c=='Yes')  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }
            
             // Workflow Implementation for Smoke Detector.
            else if(c.Case_Record_Type__c == 'Smoke Detector' || c.RecordTypeId == '012J00000000Yh1')  {
                if(c.New_Request__c=='No' || c.Philadelphia_Resident__c=='No' || c.Own_or_Rent__c=='Rent' ||c.How_Many_Families__c >2)  {
                    //c.Case_Record_Type__c = 'Information Request';
                    c.Service_Request_Type__c = 'Service Not Needed';
                    c.Status = 'Closed';
                    c.Reason = 'Service Not Needed';
                }
            }*/          
        }      
    }

}