/* 
 *       Checking if the email entered is unique or not.
 */


trigger ValidateEmail on Contact (before insert, before update) {
    
     List<Contact> conList = new List<Contact>();
     Set<string> conSet = new Set<string>();
     try{
         for (Contact con : Trigger.new) {
             
             System.debug('Contact Id: ' + con.id);
             if(con.Email != null)    {
                System.debug('Contact Email: ' + con.Email); 
                conList = [Select id from Contact where email =: con.Email and id !=: con.Id and accountId =: Con.account.id  LIMIT 1];
                System.debug('Contact with same email id: ' + conList.size());
                System.debug(conList);
                if(ConList.size() > 0){
                    con.email.addError('Unique Email-id need to be entered!');
                    
                }
             }
                if(con.email != null ){     
                    if(con.email == con.email2__c || con.email == con.email3__c || con.email == con.email4__c || con.email == con.email5__c) {
                        con.email.addError('Unique Email-id need to be entered!');
                    }    
                }
                if(con.email2__c != null ){     
                    if(con.email2__c == con.email || con.email2__c == con.email3__c || con.email2__c == con.email4__c || con.email2__c == con.email5__c) {
                        con.email2__c.addError('Unique Email-id need to be entered!');
                    }    
                }
                if(con.email3__c != null ) {
                
                    if(con.email3__c == con.email2__c || con.email3__c == con.email || con.email3__c == con.email4__c || con.email3__c == con.email5__c) {
                        con.email3__c.addError('Unique Email-id need to be entered!');
                    }
                }
                if(con.email4__c !=null) { 
                    if(con.email4__c == con.email || con.email4__c == con.email2__c || con.email4__c == con.email3__c || con.email4__c == con.email5__c) {
                        con.email4__c.addError('Unique Email-id need to be entered!');
                    }
                }
                if(con.email5__c != null ) {
                 
                     if(con.email5__c == con.email || con.email5__c == con.email3__c || con.email5__c == con.email4__c || con.email5__c == con.email2__c) {
                        con.email5__c.addError('Unique Email-id need to be entered!');
                    }    
               }
            
         }
      }
      catch(Exception ex)    {
          System.debug('Error Occurred: ' + ex.getMessage());
      }
}