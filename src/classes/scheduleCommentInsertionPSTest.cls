@isTest
private class scheduleCommentInsertionPSTest {

    static testmethod void testSync() {
        Test.StartTest();
        List<Case_Comment_Insertion_Failed__c> ca = new List<Case_Comment_Insertion_Failed__c>();
        for(integer i = 1; i<3; i++){
            Case_Comment_Insertion_Failed__c c = new Case_Comment_Insertion_Failed__c(Name='Test'+i,Case_ID__c='123',Case_Number__c='123',Customer_Request_ID__c='123',Case_Comment_Body_1__c = 'Test Comment'); 
            ca.add(c);
        }
        
        String CRON_EXP = '0 0 23 * * ?'; 
        insert ca;
        
        scheduleCommentInsertionPS sync = new scheduleCommentInsertionPS();

        // Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP,sync);

        // Get the information from the CronTrigger API object
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same    
        System.assertEquals(CRON_EXP, ct.CronExpression);
                System.assertEquals(0, ct.TimesTriggered);
               // System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
               

        Test.StopTest();
    }

}