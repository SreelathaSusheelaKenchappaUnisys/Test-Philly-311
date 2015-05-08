@isTest 
private class AccountNameUpdateTest{


        static testMethod void validateAccountNameUpdate() {
                Account at = new Account(Name='City of Philadelphia');
                insert at; 
                Contact con = new Contact(LastName='Tester');
                System.debug('Account before inserting new contact: ' + con.AccountId);
               
                // Insert contact
                insert con;  
                 
                // Retrieve the new contact
                con = [SELECT Id,AccountId FROM Contact WHERE Id =:con.Id];
                System.debug('Account after trigger fired: ' + con.AccountId);
               
                Account[] acc = [select Id from Account where Name = 'City of Philadelphia'];
               
                // Test that the trigger correctly updated the account name
                System.assertEquals(acc[0].Id,con.AccountId);
                                
        }
}