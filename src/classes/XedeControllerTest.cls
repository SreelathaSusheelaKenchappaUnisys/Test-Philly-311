/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class XedeControllerTest {

    static testMethod void messageTest() {
    	PageReference pg = Page.blank;
    	Test.setCurrentPage(pg);
    	
        XedeController xc = new XedeController();
        
        system.assertEquals(false, xc.getHasMessages());
        
        List<XedeController.SimpleMessage> aList = xc.getApexMessages();
        system.assertEquals(0, aList.size());
        
        xc.addErrorMessage('Error');
        aList = xc.getApexMessages();
        system.assertEquals(1, aList.size());
        
        xc.addInfoMessage('Info');
        aList = xc.getApexMessages();
        system.assertEquals(1, aList.size());
        
        xc.setCookie(pg, 'DEBUG', '');
        aList = xc.getApexMessages();
        system.assertEquals(2, aList.size());
        
        for (XedeController.SimpleMessage each : aList) {
        	system.assertEquals(each.getSummary(), each.getDetail());
        	system.assertNotEquals(null, each.getSeverity());
    	}
    	
    	system.assertEquals(true, xc.getHasMessages());
    }
    
    static testMethod void redrawTest() {
    	PageReference pg = Page.blank;
    	pg.getParameters().put('test', 'value');
    	Test.setCurrentPage(pg);
    	
        XedeController xc = new XedeController();
        
        PageReference newPg = xc.redrawCurrentPage();
        system.assertEquals(1, newPg.getParameters().size());
        system.assertEquals('value', newPg.getParameters().get('test'));  
        
        xc.addWarningMessage('warn');
        system.assertEquals(null, xc.redrawCurrentPage(), 'no redraw if messages exist');      
    }
    
    static testMethod void extensionTest() {
    	PageReference pg = Page.blank;
    	Test.setCurrentPage(pg);
    	
        XedeController xc = new XedeController();
        XedeController xcx = new XedeController(xc);
        
        system.assertNotEquals(null, xcx);
    }
}