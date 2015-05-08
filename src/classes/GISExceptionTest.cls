@isTest
private class GISExceptionTest {

    static testMethod void raiseTest() {
        try {
        	GISException.Raise('Hello, world!');
        	system.assert(false, 'should have thrown exception');
        }
        catch (GISException gex) {
        	system.assertEquals('Hello, world!', gex.getMessage());
        }
        catch (Exception ex) {
        	system.assert(false, 'should have thrown GISException');
        }
    }
}