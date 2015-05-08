global class BatchUpdateCase implements Database.Batchable<sObject>, Database.Stateful    {

    global Map<String, Boolean> createdByMap = new Map<String, Boolean>();    
    global integer ticketReturned;
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC)  {
        
        System.Debug('Start Method');
        String query = 'Select id, CaseNumber, Severity__c, Status, Action_Item__c, CreatedDate, CreatedBy.Name from Case WHERE RecordType.Name =\'Support Case\' and Status = \'New\' and Type_of_Issue__c IN (\'Issue\',\'Defect\') and CreatedDate > YESTERDAY order by Severity__c';
        // and CreatedDate > YESTERDAY 
        return Database.getQueryLocator(query);
    }
       
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Case>scope){
         
         System.Debug('Execute Method'); 
         Boolean val = null; 
         List<Case> updatedTicket = new List<Case>();     
         ticketReturned = scope.size();
         System.Debug('List Size: ' + ticketReturned);
         for(Case c : scope)    {
             
             val = createdByMap.get(c.CreatedBy.Name);    
             System.Debug('Map returned for Key '+ c.CreatedBy.Name + ' :' + val);
             if(val == null) {
             
                 createdByMap.put(c.CreatedBy.Name, true);         
                 val = false;
                 System.debug('Assigning value to map');
             }
             if(!val)    {    
                 if(c.Severity__c == '1 - Critical') {   
                     c.Action_Item__c = 'Unisys is looking into the issue';
                     c.Status = 'Under Investigation/In Progress';
                 }
                 else if(c.Severity__c == '2 - Urgent' && c.CreatedDate.addMinutes(59) < System.Now()) { 
                     c.Action_Item__c = 'Unisys is analyzing the issue';
                     c.Status = 'Under Investigation/In Progress';
                 }
                 else if(c.Severity__c == '3 - High' && c.CreatedDate.addMinutes(109) < System.Now() ) { 
                     c.Action_Item__c = 'Unisys is looking into the issue';
                     c.Status = 'Under Investigation/In Progress';
                 }
                 else if(c.Severity__c == '4 - Medium'  && c.CreatedDate.addMinutes(129) < System.Now()) { 
                     c.Action_Item__c = 'Unisys is looking into the issue';
                     c.Status = 'Under Investigation/In Progress';
                 }
             updatedTicket.add(c);
             System.debug('Updated Case: ' + c);
             }
             System.debug('Map: ' + createdByMap);
         }
         
         if(updatedTicket != null && updatedTicket.size() > 0)
             Database.Update(updatedTicket);
    }
     
    global void finish(Database.BatchableContext BC){
        System.Debug('Finish Method');
        System.Debug('Ticket Size: ' + ticketReturned );
        if(ticketReturned > 0)    {
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                              FROM AsyncApexJob WHERE Id =
                              :BC.getJobId()];
                              
           // Send an email to the Apex job's submitter notifying of job completion.
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {'Saurav.Sharma@in.unisys.com', 
                                                'HariKrishna.Ogirala@in.unisys.com',
                                                'Brindha.S@in.unisys.com',
                                                'Sreelatha.SusheelaKenchappa@in.unisys.com'};
           mail.setToAddresses(toAddresses);
           mail.setSubject('Support Ticket Status Update ' + a.Status);
           mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                                   ' batches with '+ a.NumberOfErrors + ' failures.');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
         }   
}