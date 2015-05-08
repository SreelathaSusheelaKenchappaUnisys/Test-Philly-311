/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class StackHelperTest {
    
    virtual class BaseClass {
    	public void addInfoMessage(string message) {
			StackHelper aStack = new StackHelper();
	    	addMessage(Apexpages.Severity.INFO, aStack.getFirstForeignFrame().getPrintString() + '\n' + message);
	    }
	    
	    public void addInfoMessage(string format, object arg1) {
	    	addInfoMessage(format, arg1, null);
	    }
	    
	    public void addInfoMessage(string format, object arg1, object arg2) {
	    	addInfoMessage(format, arg1, arg2, null);
	    }
	    
	    public void addInfoMessage(string format, object arg1, object arg2, object arg3) {
	    	addInfoMessage(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
	    }
	    
	    public void addMessage(Apexpages.Severity aSeverity, string aMessage) {
			ApexPages.addMessage(new Apexpages.Message(aSeverity, aMessage));
	    }  
    }
    
    class SubClass extends BaseClass {
        public void doit()
        {
            addInfoMessage('{0}', 'Hello, world!');
            addInfoMessage('Hello, world!');
        }
    }
    
    static testMethod void testStackTrace()
    {
        level1();
        
        SubClass aSub = new SubClass();
        aSub.doit();
    }
    
    static void level1() { level2(); }
    static void level2() { level3(); }
    static void level3() { level4(); }
    static void level4() {
        StackHelper aStack = new StackHelper();
        system.assertNotEquals(null, aStack); 
        system.assertEquals('Class.StackHelperTest.level4()', aStack.getMyMethodName());
        system.assertEquals('Class.StackHelperTest.level3()', aStack.getSenderMethodName());
        system.assertEquals('Class.StackHelperTest.level4()', StackHelper.MyMethodName());
        system.assertEquals('Class.StackHelperTest.level3()', StackHelper.SenderMethodName());
        
        try {
            StackHelper.Frame aFrame = aStack.getFirstForeignFrame();
            system.assert(false, aFrame.getPrintString());
        }
        catch (StackHelperException ex)
        {
            // it's supposed to throw this exception
        }
    }
}