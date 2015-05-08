@isTest(SeeAllData = true)
public with sharing class SelectContactMailControllerTest {
    public static testMethod void SelectContactMailControllerTestMethod1() {
        Test.setCurrentPage(Page.SelectContactMail);
        Contact con = new Contact();
        con.lastName = 'Test Contact';
        con.email = 'test@test.comm';
        con.email2__c = 'test@test.com';
        con.email3__c = 'test@test.com1';
        con.email4__c = 'test@test.com2';
        con.email5__c = 'test@test.com3';
        
        insert con;
        System.currentPageReference().getParameters().put('id',con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SelectContactMailController c = new SelectContactMailController (sc);
        c.getFields();
        
        c.chkbox1 = true;
        c.getEmails();
        system.debug('email 1 '+ c.getEmails());
        
        c.chkbox2 = true;
        c.getEmails();
        system.debug('email 2 '+ c.getEmails());
        
        c.chkbox3 = true;
        c.getEmails();
          
        c.chkbox4 = true;
        c.getEmails();
        
        c.chkbox5 = true;
        c.getEmails();
    }




}