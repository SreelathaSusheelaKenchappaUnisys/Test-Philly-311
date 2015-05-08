@isTest
private class ContactWrapperTest {

        static testMethod void goodTest() {
                GISMock.Bootstrap();
                
                Account philly = new Account(name = 'City of Philadelphia');
                insert philly;
                
                list<sobject> sobjectList = new list<sobject>();
        
                Contact aContact = new Contact(firstName = 'first', lastName = 'last', mailingStreet = '21 n juniper', accountid = philly.id);
                
                Test.StartTest();
                GISMock.SetAnswerContact();
                
                insert aContact;
                
                Test.StopTest();
                
                aContact = [ select id, mailingStreet, PhillyRisingArea__c from Contact where id = :aContact.id limit 1 ];
                
                system.assertEquals('Germantown', aContact.PhillyRisingArea__c);
        }
}