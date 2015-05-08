@isTest
private class GISMockTest {

    static testMethod void customSettingsTest() {
		GISMock.Bootstrap();
		
		system.assertEquals(GISMock.GISRestEndpoint, GIS.GetGISRestEndpoint());
		system.assertEquals(GISMock.GeometryServerEndpoint, GIS.GetGeometryServer());
    }
}