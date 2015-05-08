@isTest
public with sharing class CommentInsertionPSTest{

        static testmethod void method1() {

                List<Case_Comment_Insertion_Failed__c> ca = new List<Case_Comment_Insertion_Failed__c>();
                for(integer i = 1; i<3; i++){
                        Case_Comment_Insertion_Failed__c c = new Case_Comment_Insertion_Failed__c(Name='Test'+i,Case_ID__c='123',Case_Number__c='123',Customer_Request_ID__c='123',Case_Comment_Body_1__c = 'Test Comment'); 
                        ca.add(c);
                }

                Test.StartTest();
                insert ca;
                CommentInsertionPS sync = new CommentInsertionPS();
                sync.query =  'Select Id, Name,Case_ID__c, Case_Number__c, Customer_Request_ID__c,Case_Comment_Body_Size__c, Case_Comment_Body_1__c, Case_Comment_Body_2__c, Case_Comment_Body_3__c, Case_Comment_Body_4__c, Case_Comment_Body_5__c, Case_Comment_Body_6__c, Case_Comment_Body_7__c, Case_Comment_Body_8__c, Case_Comment_Body_9__c, Case_Comment_Body_10__c, Case_Comment_Body_11__c, Case_Comment_Body_12__c, Case_Comment_Body_13__c, Case_Comment_Body_14__c, Case_Comment_Body_15__c, Case_Comment_Body_16__c from Case_Comment_Insertion_Failed__c';
                ID batchprocessid = Database.executeBatch(sync);
                Test.StopTest();        
        }

}