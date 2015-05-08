@isTest
public with sharing class CasePurgeJob3Test{
       
    static testmethod void m1() {
     
        Test.StartTest();
        CasePurgeJob3 sync = new CasePurgeJob3();
        ID batchprocessid = Database.executeBatch(sync);
        Test.StopTest();  
    }

}