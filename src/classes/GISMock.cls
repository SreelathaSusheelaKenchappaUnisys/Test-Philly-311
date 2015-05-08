public with sharing class GISMock {
	public static void Bootstrap() {
		CreateGIS();
	}
	
	static void CreateGIS() {
		GIS__C aGis = new GIS__c(
			Name = 'Default',
			GISRestEndpoint__c = GISRestEndpoint,
			GeometryServer__c = GeometryServerEndpoint
		);
		
		insert aGis;
	}
	
	public static void SetAnswerAddress1()
	{
		XedeTestData testData = new XedeTestData('GISTestData');

		Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
			testData.find('Address1'), 
			testData.find('Topic1'),
			testData.find('ServiceAreasCourtyard'),
			testData.find('Projection1')
		}));
	}
	
	public static void SetAnswerAddress2()
	{
		// address2 test data comes from http://geo.phila.gov/ULRSvTEST/addresses/4901%20PULASKI%20AVE?format=json&srid=4326&geocodetype=SnapNearCenterline
        // serviceAreas2 comes from      http://geo.phila.gov/ULRSvTEST/addresses/4901%20PULASKI%20AVE/service-areas?format=json
        
        XedeTestData testData = new XedeTestData('GISTestData');

		Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
			testData.find('Address2'), 
			testData.find('Topic1'), 
			testData.find('ServiceAreasCourtyard'),
			testData.find('Projection1')
		}));
	}
	
	public static void SetAnswer1200Yerkes()
	{
		// address http://geo.phila.gov/ULRSvTEST/addresses/1200%20yerkes?format=json&srid=4326&client=CRM&geocodetype=CenterlineOnly
        // topics http://geo.phila.gov/ULRSvTEST/addresses/1200%20YERKES%20ST/topics?format=json&client=CRM
        // areas http://geo.phila.gov/ULRSvTEST/addresses/1200%20YERKES%20ST/service-areas?format=json&client=CRM
        // projection http://gis.phila.gov/arcgis/rest/services/Geometry/GeometryServer/project?inSR=4326&outSR=2272&geometries=-75.1725044104416%2C40.0596694889302&transformation=&transformForward=false&f=json
        
        XedeTestData testData = new XedeTestData('GISTestData');

		Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
			testData.find('YerkesAddress'), 
			testData.find('YerkesTopics'), 
			testData.find('YerkesServiceAreas'),
			testData.find('YerkesProject')
		}));
	}
	
	public static void SetAnswerContact()
	{
		XedeTestData testData = new XedeTestData('GISTestData');

		Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
			testData.find('Address1'),
			testData.find('Topic1'),  
			testData.find('ServiceAreas2')
		}));
	}
	
	public static void SetAnswerNotFound()
	{
		Test.setMock(HttpCalloutMock.class, new GISAPIMock('{"error":"The address \'1234 Missing\' could not be found."}', 404));
	}
	
	public static void SetAnswerReverseGeocode()
	{
		// address2 test data comes from http://geo.phila.gov/ULRSvTEST/addresses/4901%20PULASKI%20AVE?format=json&srid=4326&geocodetype=SnapNearCenterline
        // serviceAreas2 comes from      http://geo.phila.gov/ULRSvTEST/addresses/4901%20PULASKI%20AVE/service-areas?format=json
        
        XedeTestData testData = new XedeTestData('GISTestData');

		Test.setMock(HttpCalloutMock.class, new GISAPIMock(new string[] { 
			testData.find('AddressRange1'),
			testData.find('Projection1'),
			testData.find('Locations1'),
			testData.find('Topics1234Market'),
			testData.find('ServiceAreasCourtyard'),
			testData.find('Projection1')
		}));
	}
	public static final string GeometryServerEndpoint = 'http://gis.phila.gov/arcgis/rest/services/Geometry/GeometryServer';
	public static final string GISRestEndpoint = 'http://geo.phila.gov/ULRSvR';
}