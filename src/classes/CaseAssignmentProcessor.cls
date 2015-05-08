/* This Class is used by Trigger on Case Object to update 
 * the Case Owner according to the Case Assignment Rule.
 * Updated the code for Support ticket #00005373
 */

public class CaseAssignmentProcessor {
     
     public static void processCases(Set<Id> id) {
          List<Case> casesToUpdate = new List<Case>();
          
            for(Case tempObj : [Select id,CaseNumber, Department__c, Centerline_2272x__c, Centerline_2272y__c, Owner.Name, Status, Service_request_Type__c, Case_Record_Type__c, RecordType.Name, Ambulance_Color__c, Ambulance_Emblem__c from Case where id IN :id])    {                
                
                System.debug('Assignment Rule called');
                System.debug('Case details: ' +   tempObj.CaseNumber + '  ' + tempObj.Department__c + '  ' + tempObj.Service_request_Type__c + '  ' + tempObj.Owner.Name  + '  ' +  tempObj.Status + '  ' +  tempObj.Ambulance_Color__c + '  ' +  tempObj.Ambulance_Emblem__c + '  ' + tempObj.RecordType.Name);               
                //Assignment Rule
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true; 
                tempObj.setOptions(dmo);
                casesToUpdate.add(tempObj);     
                System.debug('Case details after Assignment Rule: ' +   tempObj.CaseNumber + '  ' + tempObj.Department__c + '  ' + tempObj.Service_request_Type__c + '  ' + tempObj.Owner.Name  + '  ' +  tempObj.Status + '  ' +  tempObj.Ambulance_Color__c + '  ' +  tempObj.Ambulance_Emblem__c  + '  ' + tempObj.RecordType.Name );               
           }
          try    {
              CaseFieldUpdate.inFutureContext = true;
              Database.upsert(casesToUpdate);
          }
          catch (DMLException ex)    {
              System.debug('Error Occured: ' + ex.getMessage());
          }    
     } 
 
}