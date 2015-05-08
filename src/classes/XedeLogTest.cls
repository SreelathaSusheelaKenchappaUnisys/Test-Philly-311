@isTest
private class XedeLogTest {

    static testMethod void myUnitTest() {
        system.assertEquals(0, XedeLog.Size());
        
        XedeLog.Write('Hello, world!');
        system.assertEquals(1, XedeLog.Size());
        system.assert(XedeLog.GetLog()[0].endsWith('Hello, world!'));
        
        system.assertEquals('1', XedeLog.Write('{0}', 1));
        system.assertEquals(2, XedeLog.Size());
        
        system.assertEquals('12', XedeLog.Write('{0}{1}', 1, 2));
        system.assertEquals('123', XedeLog.Write('{0}{1}{2}', 1, 2, 3));
        system.assertEquals('1234', XedeLog.Write('{0}{1}{2}{3}', 1, 2, 3, 4));
        system.assertEquals('12345', XedeLog.Write('{0}{1}{2}{3}{4}', 1, 2, 3, 4, 5));
        system.assertEquals('123456', XedeLog.Write('{0}{1}{2}{3}{4}{5}', 1, 2, 3, 4, 5, 6));
        
        XedeLog.WriteLimits();
        
        system.debug(XedeLog.getLogString());
    }
    
    static testMethod void logLimitsTest() {
    	system.assertEquals(0, XedeLog.Size());
    	XedeLog.WriteLimits();
    	system.assertNotEquals(0, XedeLog.Size());
    }
}