global class CasePurgeJob4 implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    
    Global Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Case.fields.getMap();
    Global List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
    Global list<String> fieldVals= new  List<String>();
    // Headers for CSV file to be exported .
    Global string img = 'CaseNumber,Department,Complaint or Compliment,Physical or Verbal Abuse,City of Philadelphia Police,Officer Breaking Law,Fire Dept. or EMS Complaint,Streets Dept. Complaint,Abandoned Vehicle Complaint,Incident Date and Time,Police Officer or Dispatcher Name,Vehicle Number,Follow Up Contact,Previous Case Number,Previous Contact Date and Time\n';
    Global string header='Department\n'; 
    Global string img2 ='';    
    Global string img3='CaseNumber,Department,Complaint or Compliment,Incident Date and Time,Incident Location,Firefighters or Paramedics Known,Firefighter/Paramedic Names,ID Numbers Known,ID Numbers,Ambulance Color,Ambulance Emblem,EMS Medical Call,Witnesses Known,Witness Contact Information,Patient Name\n';            
    Global string img4 = '';
    Global string img5 = 'CaseNumber,Department,Previous Case,Previous Case found,Type of Feedback (Comments),Rubbish Issue,Property Loss Claim\n';
    Global string img6 = '';       
    Global string img7 = 'CaseNumber,Type,Department,Case Record Type,Service Request Type,Case Owner,Contact Name,Account Name,Status,Case Number,Customer Zip Code,Parent Case,Case Origin,Subject,Comments\n';
    Global string img8 = '';  
    Global String theQuery='';
    // Get the current date-time
    Global DateTime dt= system.now();
    // Substract 30 days from current date-time.
    Global DateTime dt2= dt.addmonths(-1);
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string status='closed';
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Case.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        //Query for all the fields of Case object 
        String theQuery='SELECT ';
        for(Schema.SObjectField s : fldObjMapValues)   {
            String theName = s.getDescribe().getName();
            theQuery += theName + ', ';
        }
        theQuery = theQuery.subString(0, theQuery.length() - 2);
        
        //Format the date time to string 
        string dt3= dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        string dt4=dt2.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        theQuery += ' FROM Case' ;
        
        // Case Record type NOT EQUALS  Support Case .
        theQuery += ' where closedDate<'+dt4 + 'And IsClosed=true And RecordType.Name != \'Support Case\' ';
        System.debug('Created Date: ' + System.now());
        System.debug('Final Query'+Database.query(theQuery));
        return Database.getQueryLocator(theQuery);    
    }
    
    global void execute(Database.BatchableContext bc, list<Case> aList) {
      
        for(Schema.SObjectField s : fldObjMapValues)  {
           
           String theName = s.getDescribe().getName();
           theQuery += theName.replaceAll('__c','') + ', ';
           fieldVals.add(theName);           
        }
        
        //Adding fields for each case Record Type with Complaints
        
        System.debug('field labels are ' + theQuery);
        for(Case c : aList) {
            if(c.Case_Record_Type__c == 'Police Complaint'){
                  system.debug('department is '+ c.department__c);
                  img2 += c.caseNumber+','+c.department__c+','+c.Complaint_or_Compliment__c+','+c.Physical_or_Verbal_Abuse__c+','+c.City_of_Philadelphia_Police__c+','+c.Officer_Breaking_Law__c+','+c.Fire_Dept_or_EMS_Complaint__c+','+c.Streets_Dept_Complaint__c+','+c.Abandoned_Vehicle_Complaint__c+','+c.Incident_Date_and_Time__c+','+c.Police_Officer_or_Dispatcher_Name__c+','+c.Vehicle_Number__c+','+c.Follow_Up_Contact__c+','+c.Previous_Case_Number__c+','+c.Previous_Contact_Date_and_Time__c+'\n';
            }        
        }
        
         Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap();
         for (String str : M.keyset()) { 
            for(case c:aList)           
                System.debug('Field name: '+str);
                //System.debug('Field name: '+str +'. New value: ' + String.valueOf(c.get(str)) +'. Old value: '+String.valueOf(c.get(str)));
          }
          
         for(Case c : aList) {
                if(c.Case_Record_Type__c=='Complaints Against Fire or EMS'){
                  img4 += c.caseNumber+','+c.department__c+','+c.Complaint_or_Compliment__c+','+c.Incident_Date_and_Time__c+','+c.Incident_Location__c+','+c.Firefighters_or_Paramedics_Known__c+','+c.Firefighter_Paramedic_Names__c+','+c.ID_Numbers_Known__c+','+c.ID_Numbers__c+','+c.Ambulance_Color__c+','+c.Ambulance_Emblem__c+','+c.EMS_Medical_Call__c+','+c.Witnesses_Known__c+','+c.Witness_Contact_Information__c+','+c.Patient_Name__c+'\n';
                }
           }
           
        for(Case c : aList) {    
            if(c.Case_Record_Type__c=='Complaint (Streets)'){
              img6 += c.caseNumber+','+c.department__c+','+c.Previous_Case__c+','+c.Previous_Case_found__c+','+c.Type_of_Feedback_Comments__c+','+c.Rubbish_Issue__c+','+c.Property_Loss_Claim__c+'\n';        
                 
             }
        }  
         //Adding fields for Information Request
        for(Case c : aList) {    
            if(c.Case_Record_Type__c=='Information Request'){
              img7 += c.caseNumber+','+c.Type+','+c.department__c+','+c.Case_Record_Type__c+','+c.Service_Request_Type__c+','+c.Owner.name+','+c.Contact+','+c.Account+','+c.Status+','+c.CaseNumber+','+c.Zip_code__c+','+c.Parent+','+c.Origin+','+c.Subject+','+c.Description+'\n';        
             }
        }
        
        try {
        //delete aList;
        //database.emptyRecycleBin(aList);
        }
        catch (system.Dmlexception dex) {}
    }
    
    global void finish(Database.BatchableContext bc){
       
        //Attach as separate CSV for each Case Record Type 
        //For police complaint
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('CaseExportPoliceComplaint.csv');
        efa.setBody(blob.valueOf(img+img2));
        efa.setInline(false);
        System.debug('First Attachment: ' + img +' ' + img2); 
        
        //For complaint against fire or EMS
        Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();       
        efa2.setBody(blob.valueOf(img3+img4));
        efa2.setFileName('CaseExportCompAgaFirorEms.csv');
        efa2.setInline(false);
        System.debug('Second Attachment: ' + img3 + ' ' + img4); 
        
        //For Street Complaints
        Messaging.EmailFileAttachment efa3 = new Messaging.EmailFileAttachment();
        efa3.setBody(blob.valueOf(img5+img6));
        efa3.setFileName('CaseExportStComplaints.csv');
        efa3.setInline(false);
        System.debug('Third Attachment: ' + img5+ ' ' + img6); 
        
        //For information request
        Messaging.EmailFileAttachment efa4 = new Messaging.EmailFileAttachment();
        efa4.setBody(blob.valueOf(img7+img8));
        efa4.setFileName('CaseExportInfRequest.csv');
        efa4.setInline(false);
        system.debug('Forth Attachment: ' + img7 + ' ' + img8); 
        
        list<String> mlist = new List<String>{'Harikrishna.ogirala@in.unisys.com','Hemalatha.HolalurShanthappa@in.unisys.com'};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mlist);
        mail.setSubject('job test');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa,efa2,efa3,efa4});
        mail.setPlainTextBody('The Case list is attached as a document ');
           
        if (Test.isRunningTest())
        system.debug('Test Is Running');
        else{
        // Send Email for the user with attached files as CSV 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    global void execute(SchedulableContext sc){
        Database.ExecuteBatch(new CasePurgeJob4());
    }
}