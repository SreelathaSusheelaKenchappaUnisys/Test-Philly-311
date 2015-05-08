@isTest(SeeAllData = True)
//Test class for testing the trigger on cases
private class PdfTemplateControllerTest {
    static testMethod void PdfTemplateControllerTest1() { 
        PageReference pageRef = Page.CaseAbandonedVehicle;
        Test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('id','' );
        //Case c = new Case(Street__c='21 N Juniper st',Status='New',Translator_Required__c='No',Origin='Web',Is_there_a_busted_steering_column__c='No',General_Condition__c='Appears Drivable');
        Case c = [select id from case where Service_Request_Type__c = 'Abandoned Vehicle' LIMIT 1];
        ApexPages.currentPage().getParameters().put('id',c.id );
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        PdfTemplateController pdfTemplateObject = new PdfTemplateController (sc);
        system.assertEquals(Datetime.now().format('MMMM d,  yyyy'),pdfTemplateObject.getDate());
        
    }    
}