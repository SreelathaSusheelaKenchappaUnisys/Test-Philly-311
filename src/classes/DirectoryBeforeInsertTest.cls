@isTest 
private class DirectoryBeforeInsertTest{

     static testMethod void testTrigger() {
         Directory__c d = new Directory__c();
         d.Name = 'Test';
         d.Department__c = 'Streets';
         d.Phone__c = '8861516144';
         insert d;
     
     }

}