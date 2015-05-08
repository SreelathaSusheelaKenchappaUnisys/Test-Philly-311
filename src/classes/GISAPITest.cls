@isTest
private class GISAPITest {

    static testMethod void myUnitTest() {
        RestRequest aRequest = new RestRequest();
        aRequest.addParameter('action', 'address');
        aRequest.addParameter('street', '10 s broad st');
        aRequest.addParameter('srid', '2272');  
        
        GISMock.SetAnswerAddress1();
        
        RestResponse aResponse = new RestResponse();
        GISAPI api = new GISAPI();
        XedeRemoteResponse apiResponse = api.handleRequest(aRequest, aResponse);
        system.assertEquals('true', apiResponse.successful);
    }
}