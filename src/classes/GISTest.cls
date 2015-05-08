@isTest
private class GISTest {

    static testMethod void urlEncodingTest() {
        system.assertEquals('one+two', EncodingUtil.urlEncode('one two', 'UTF-8'));
    }
    
    static testMethod void reverseGeocodeTest() {
        return;
        
        GisMock.Bootstrap();
        GIS aGIS = new GIS();
        
        Test.StartTest();
        
        GISMock.SetAnswerReverseGeocode();
        string aString = aGIS.address('1299-1357 Market Street', new GIS.XyPair(-75.160471535927, 39.951971218798));
        Test.StopTest();
        
        GIS.AddressResponse anAddressResponse = (GIS.AddressResponse) Json.Deserialize(aString, GIS.AddressResponse.class);
        system.assertEquals(4, anAddressResponse.addresses.size());
        system.debug(anAddressResponse.addresses[0]);
    }
    
    static testMethod void serviceAreasTest() {
        GisMock.Bootstrap();
        GIS aGIS = new GIS();
        
        Test.StartTest();
        XedeTestData testData = new XedeTestData('GISTestData');

        Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { testData.find('ServiceAreasCourtyard') }));
        
        map<string, string> areas = aGIS.serviceAreas('21 N JUNIPER ST');
        Test.StopTest();
        
        system.assertEquals('In', areas.get('SA_CENTER_CITY_DISTRICT'));
    }
}