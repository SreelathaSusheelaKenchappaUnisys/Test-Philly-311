/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class XedeExceptionTest {
    
    static testMethod void testOneArg() {
        try {
            XedeException.Raise('one {0}', 'two');
        }
        catch (XedeException ex)
        {
            System.assertEquals('one two', ex.getMessage());
        }
    }
    
    static testMethod void testTwoArgs() {
        try {
            XedeException.Raise('one {0} {1}', 'two', 'three');
        }
        catch (XedeException ex)
        {
            System.assertEquals('one two three', ex.getMessage());
        }
    }
    
    static testMethod void testThreeArgs() {
        try {
            XedeException.Raise('one {0} {1} {2}', 'two', 'three', 'four');
        }
        catch (XedeException ex)
        {
            System.assertEquals('one two three four', ex.getMessage());
        }
    }
    
    static testMethod void testFourArgs() {
        try {
            XedeException.Raise('one {0} {1} {2} {3}', 'two', 'three', 'four', 'five');
        }
        catch (XedeException ex)
        {
            System.assertEquals('one two three four five', ex.getMessage());
        }
    }
    
    static testMethod void testDivideByZero()
    {
        try {
            integer top = 10;
            integer bottom = 0;
            
            integer result = top / bottom;
        }
        catch (Exception ex) {      
            try {
                XedeException.Raise('test exception', ex);
                System.assert(false, 'should have thrown exception');
            }
            catch (XedeException ax) {
                System.assertEquals('test exception', ax.GetMessage());
                System.assertEquals('Divide by 0', ax.getCause().GetMessage());
            }
        }
    }
}