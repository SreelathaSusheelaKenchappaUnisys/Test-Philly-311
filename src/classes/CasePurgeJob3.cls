global class CasePurgeJob3 implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    
    // Headers for CSV file to be exported .
   
    Global string img = 'CaseNumber,Department,Is Light a Traffic Signal,Is Light Illuminating an Alley,Is Light Illuminating a Parking Lot,Is Light in a Park,Problem Type\n';
    Global string header='Department\n';           
    Global string img2 ='';
    Global string img3 = 'CaseNumber,Department,Stop Sign Type,Request for New Stop Sign,Not Visible,Issue,Hazardous\n';
    Global string img4 = '';
    Global string img5 = 'CaseNumber,Department,Light Type,Alley Passable,Alley Gated or Locked,Is there a key location,Alley Type,Problem Type\n';
    Global string img6 = '';
    // Get the current date-time
    Global DateTime dt= system.now();
    // Substract 30 days from current date-time.
    Global DateTime dt2= dt.addMonths(-1);
    
    Global Database.QueryLocator start(Database.BatchableContext bc) {
        string status='closed';
        
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Case.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        String theQuery='SELECT ';
        String theName = null;
        
        for(Schema.SObjectField s : fldObjMapValues){
            theName = s.getDescribe().getName();
            theQuery += theName + ', ';
        }
        // Remove comma from the last field.
        theQuery = theQuery.subString(0, theQuery.length() - 2);
        //Format Date-time to String 
        string dt3= dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        string dt4=dt2.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        theQuery += ' FROM Case' ;
        
        // Case Record type NOT EQUALS  Support Case
        theQuery += ' where closedDate <'+dt4 + 'And IsClosed=true And RecordType.Name != \'Support Case\' ';
        System.debug('Created Date: ' + System.now());
        system.debug('Final Query'+Database.query(theQuery));
        
        // Query for metadata of all the fields on the case object whose case record type is not equal to Support Case 
        return Database.getQueryLocator(theQuery);    
    }
    
    global void execute(Database.BatchableContext bc, list<Case> aList) {
      
        for(Case c : aList) {
            if(c.Case_Record_Type__c == 'Street Light Outage'){
                  system.debug('department is '+ c.department__c);
                  img2 += c.caseNumber+','+c.department__c+','+c.Is_the_Light_a_Traffic_Signal__c+','+c.Is_Light_Illuminating_an_Alley__c+','+c.Is_the_Light_Illuminating_a_Street__c+','+c.Is_the_Light_in_a_Park__c+','+c.Problem_Type__c+'\n';
            }        
        }
        
        for(Case c : aList) {
            if(c.Case_Record_Type__c=='Stop Sign Repair'){
              img4 += c.caseNumber+','+c.department__c+','+c.Stop_Sign_Type__c+','+c.Request_for_New_Stop_Sign__c+','+c.Not_Visible__c+','+c.Issue__c+','+c.Hazardous__c+'\n';
            }
        }
        
        for(Case c : aList) {    
            if(c.Case_Record_Type__c=='Alley Light Outage'){
              img6 += c.caseNumber+','+c.department__c+','+c.Light_Type__c+','+c.Alley_Passable__c+','+','+c.Is_there_a_key_location__c+','+c.How_can_access_to_the_alley_be_obtained__c+','+c.Alley_Type__c+','+c.Problem_Type__c+'\n';        
             }
        }
        
        try {
            //delete aList;
            //database.emptyRecycleBin(aList);
        }
        catch (system.Dmlexception dex) {
            System.debug('Exception Thrown: ' + dex.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc){
       
       //Attach as separate CSV for each Case Record Type 
       //Street Light Outage
       Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
       efa.setFileName('CaseExportStLightOutage.csv');
       efa.setBody(blob.valueOf(img+img2));
       efa.setInline(false);
       system.debug(img+img2); 
       
       //stop sign repair
       Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
       efa2.setInline(false);
       efa2.setBody(blob.valueOf(img3+img4));
       efa2.setFileName('CaseExportStSignRepair.csv');
       system.debug(img3+img4); 
       
       //Alley Light Outage
       Messaging.EmailFileAttachment efa3 = new Messaging.EmailFileAttachment();
       efa3.setBody(blob.valueOf(img5+img6));
       efa3.setFileName('CaseExportAlleyLightOutage.csv');
       efa3.setInline(false);
       system.debug(img5+img6); 
       list<String> mlist = new List<String>{'harikrishna.ogirala@in.unisys.com','Hemalatha.HolalurShanthappa@in.unisys.com'};
       
       //Send Final Mail
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(mlist);
       mail.setSubject('job test');
       mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa,efa2,efa3});
       mail.setPlainTextBody('The Case list is attached as a document ');
       
       if (Test.isRunningTest())
           system.debug('Test Is Running');
           
       else    {
           // Send Email for the user with attached files as CSV 
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
    }
    
    global void execute(SchedulableContext sc){
        Database.ExecuteBatch(new CasePurgeJob3());
    } 
}