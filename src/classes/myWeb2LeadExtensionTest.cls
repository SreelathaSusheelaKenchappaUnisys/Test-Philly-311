@isTest (seeAllData = true)
public class myWeb2LeadExtensionTest {

    static  testmethod void testCampaign(){
     //   Campaign c = new Camapaign();
        Lead l = new Lead(FirstName = 'Kousik', LastName = 'Ogirala', Campaign_Name__c = 'TestP');        
        ApexPages.currentPage().getParameters().put('CampaignName', 'TestP');
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        myWeb2LeadExtension web2Lead = new myWeb2LeadExtension(sc);
        web2Lead.getStoryItems();
        web2Lead.getStories();
        web2Lead.getunSelectedValues();        
        List<String> listL = new List<String>();
        listL.add('element');
        listL.add('element1');
        web2Lead.leftselected = listL ;
        List<String> listR = new List<String>();
        listR.add('element');
        listR.add('element1');
        web2Lead.rightselected = listR;
        web2Lead.setStories(listL);
        web2Lead.setcampName('TestP');
        web2Lead.selectclick();
        listR.add('element');
        listR.add('element1');
        web2Lead.rightselected = listR;
        web2Lead.getSelectedValues();
        web2Lead.unselectclick();        
        PageReference  p = web2Lead.saveLead();
        System.assertEquals('System.PageReference[https://citywide-philadelphia.cs10.force.com/campaign/CampaignRegistrationSuccess]', String.valueOf(p));
    }    
}