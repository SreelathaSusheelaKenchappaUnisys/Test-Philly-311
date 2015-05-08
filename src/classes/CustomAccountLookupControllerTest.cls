@isTest(SeeAllData=true)
public class CustomAccountLookupControllerTest{
    
        public static testMethod void testLookupController() {
        
                contact con = new Contact(
                LastName = 'Test Contact',
                MailingState = 'Pennsylvania',
                MailingCountry = 'United States'
                );
            
                insert con;
        
                Test.setCurrentPage(new pageReference('apex/CustomAccountLookup?txt=j_id0%3Aj_id1%3AmainForm%3Aedit%3Apbs%3AAccount&frm=&lksearch=&lksrch=Test Contact'));
                string searchString = con.lastName;
                CustomAccountLookupController c = new CustomAccountLookupController();
                c.runSearch();
                list<Contact> conlist2 = c.performSearch(searchString);
                system.debug('search result is '+ c.performSearch(searchString));
                c.search();
                string textbox = c.getTextBox();
                String formTag = c.getFormTag();
                pageReference pr = c.saveAccount();
                system.debug('pageReference is 1'+ pr);
                
                for (Contact c1 : conlist2) {
                
                        system.debug(c1);
                        system.assertEquals('Test Contact', c1.Name);
                      //system.assertEquals('Pennsylvania', c1.MailingState);
                        system.assertEquals('United States', c1.MailingCountry);    
                }
        }
        
        public static testMethod void testLookupController2() {
        
                contact con = new contact();
                con.lastName='test contact';
                con.Email = 'sad@asdf.csa';
                insert con;
                ApexPages.StandardController sc = new ApexPages.StandardController(con);
                CustomAccountLookupController  testObj = new CustomAccountLookupController (sc);
                //CustomAccountLookupController c = new CustomAccountLookupController();
                string searchString = '';
                testObj.runSearch();
                testObj.performSearch(searchString);
                testObj.search();
                string textbox = testObj.getTextBox();
                String formTag = testObj.getFormTag();
                pageReference pr = testObj.saveAccount();
                system.debug('pageReference is 1'+ pr);
                testObj.validateEmail();
                
                
                
        }
}