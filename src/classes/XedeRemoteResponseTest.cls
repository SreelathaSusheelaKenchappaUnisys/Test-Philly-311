@isTest
private class XedeRemoteResponseTest {
	class XRR extends XedeRemoteResponse {
		
	}

    static testMethod void basicTest() {
        // test is extendable
        XRR aSubclass = new XRR();
        system.assertNotEquals(null, aSubclass);
        
        // test construction
        XedeRemoteResponse anxrr = new XedeRemoteResponse(true, 'ok');
        system.assertEquals('true', anxrr.successful);
        system.assertEquals(1, anxrr.message.size());
        
        anxrr.error('Oh oh');
        system.assertEquals('false', anxrr.successful);
        system.assertEquals(2, anxrr.message.size());
        
        anxrr = new XedeRemoteResponse(false, 'something went wrong');
        system.assertEquals('false', anxrr.successful);
        system.assertEquals(1, anxrr.message.size());
        
        anxrr.ok('all better');
        system.assertEquals('true', anxrr.successful);
        system.assertEquals(2, anxrr.message.size());
        
        // test xapi string
        anxrr.setXapi('pattern');
        system.assertEquals('pattern', anxrr.xapi);
        anxrr.setXapi('');
        system.assertEquals('', anxrr.xapi);
        
        // test xapimap
        map<integer, string> testMap = new map<integer, string>();
        testMap.put(1, 'one');
        testMap.put(2, 'two');
        
        anxrr.setXapiMap(Json.Serialize(testMap));
        map<string, object> jmap = anxrr.xapimap;
        system.assertEquals(testMap.size(), jmap.size());
        
        // test debug log
        XedeLog.Write('a debug message');
        anxrr.loadDebugLog();
        system.assertEquals(3, anxrr.debugLog.size());
        
        // test adding messages
        anxrr = new XedeRemoteResponse();
        system.assertEquals(0, anxrr.message.size());
        
        anxrr.addMessage('one');
        system.assertEquals(1, anxrr.message.size());
        
        anxrr.addMessage( new string[] { 'two', 'three' });
        system.assertEquals(3, anxrr.message.size());
    }
}