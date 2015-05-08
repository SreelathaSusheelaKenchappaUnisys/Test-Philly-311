@isTest
private class GISControllerTest {

    static testMethod void addressTest() {
        XedeRemoteResponse response = GISController.Address('990 spring garden', '2272');
        system.assertNotEquals(null, response);
    }
    
    static testMethod void httpGetTest() {
        Test.setMock(HttpCalloutMock.class, new GISAPIMock('{ "xyzzy" : "Nothing happens." }'));
        XedeRemoteResponse response = GISController.HttpGet('http://google.com');
        system.assertNotEquals(null, response);
        system.debug(response);
        system.assertEquals('OK', response.message[0]);
    }
    
    static testMethod void getRecentCasesTest() {
        system.debug('GetRecentCasesTest()');
        
        RecordType rt = [ select id, name, developerName from RecordType where developerName = 'Miscellaneous' limit 1 ];
        system.assertNotEquals(null, rt);
        system.assertEquals('Miscellaneous', rt.name);
        
        list<Case> caseList = new list<Case>();
        
        caseList.add(
            new Case(
                Description = 'Test Description',
                Street__c = '1234 Market',
                Subject = 'Test Subject',
                Centerline_2272x__c = 10,
                Centerline_2272y__c = 20,
                Origin='Email',
                RecordTypeId = rt.Id
            )
        );
        
        caseList.add(caseList[0].clone());
        caseList.add(caseList[0].clone());
        
        system.debug(caseList);
        
        insert caseList;
        
        for (Case each : caseList)
            system.assert(String.IsNotBlank(each.id));
        
        system.debug(caseList);
        
        caseList = GISController.GetRecentCases(3, caseList[0].id);
        system.debug(caseList);
        
        system.assertEquals(2, caseList.size());
    }
    
    static testMethod void queryTest() {
        XedeRemote.Response response = GISController.Query('select name from apexClass');
        system.assertNotEquals(null, response);
        system.debug(response);
        system.assert(response.size() > 0);
        
        //system.assertEquals('OK', response.message[0]);
    }
    
    static testMethod void constructorTest() {
        GISController c = new GISController();
        c = new GISController(new XedeController());
        c = new GISController(new ApexPages.StandardController(new Case()));
    }
}