@isTest (SeeAllData=true) // reports are only visible with SeeAllData=true

private class XedeReportTabularControllerTest {

    static testMethod void nonTabularExceptionTest() {
        PageReference aPage = Page.XedeReportCSV;
        
        aPage.getParameters().put('report', 'SampleReportActiveUsers');
        Test.setCurrentPage(aPage);
        try {
        	XedeReportTabularController xtc = new XedeReportTabularController();
			system.assert(false, 'Should have thrown exception.');
        }
        catch (XedeException ex) {
        	// ignore
        }
    }
    
    static testMethod void tabularTest() {
        list<Report> aList = [ Select Name, Format, DeveloperName From Report where format = 'tabular' ];
        if (aList.isEmpty())
        	return;
        
        PageReference aPage = Page.XedeReportCSV;
        
        aPage.getParameters().put('report', aList[0].DeveloperName);
        
        Test.setCurrentPage(aPage);
        
        XedeReportTabularController xtc = new XedeReportTabularController();
        system.assertNotEquals(0, xtc.aReport.getHeader().size());
        system.assertNotEquals(null, xtc.aReport.getRow());
    }
    
    static testMethod void remoteReportTypes() {
    	system.assertNotEquals(0, [ select count() from Report ]);
    	
        list<map<string, string>> aMapList = XedeReportTabularController.TabularReport('XedeReportTypes');
        system.assertNotEquals(null, aMapList);
        system.debug(aMapList);
        system.debug(JSON.SerializePretty(aMapList));
    }
}