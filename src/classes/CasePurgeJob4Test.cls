@isTest
public with sharing class CasePurgeJob4Test{
       
    static testmethod void m1() {
     
        Test.StartTest();
        CasePurgeJob4 sync = new CasePurgeJob4();
        ID batchprocessid = Database.executeBatch(sync);
        Test.StopTest();  
    }

}