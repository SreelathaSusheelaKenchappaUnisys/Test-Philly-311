/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class XedeObjectTest {
	class TestObject extends XedeObject
	{
		public override void saveTo(List<sobject> aList) {
			
			aList.addAll( new List<sobject> {
				(sobject)(new Account()),
				(sobject)(new Contact()),
				(sobject)(new Attachment()),
				(sobject)(new Account()),
				(sobject)(new Contact()),
				(sobject)(new Attachment()),
				(sobject)(new Account()),
				(sobject)(new Contact()),
				(sobject)(new Attachment()),
				(sobject)(new Account()),
				(sobject)(new Contact()),
				(sobject)(new Attachment())
			});
			
			system.assertEquals(12, CountChunksIn(aList)); // too many to perform dml
		}

		protected override void saveInsertList(list<sobject> aList) {
			system.assertEquals(3, CountChunksIn(aList)); // safe to perform dml on less than 10 chunks
		}
	}

	static testMethod void groupBySobjectTypeTest()
	{
    	TestObject xo = new TestObject();
		
		xo.save(); // all asserts are in the object above
	}
	
	static Integer CountChunksIn(List<sobject> anSobjectList) {
		Integer numberOfChunks = 0;
		Schema.Sobjecttype previousType;
		
		for (sobject each : anSobjectList) {
			if (each.getSObjectType() != previousType) {
				numberOfChunks++;
			}
			previousType = each.getSObjectType();
		}
		
		return numberOfChunks;
	}
	
    static testMethod void messageTest()
    {
    	TestObject xo = new TestObject();
    	
    	system.assertEquals(0, ApexPages.getMessages().size());
    	
    	xo.addInfoMessage('{0}', 1);
    	system.assertEquals(1, ApexPages.getMessages().size());
    	system.assert(ApexPages.getMessages()[0].getDetail().startsWith('Class.XedeObjectTest.'));
    	
    	system.assertEquals('1', xo.addInfoMessage('{0}', 1));
    	system.assertEquals('1,2', xo.addInfoMessage('{0},{1}', 1, 2));
    	system.assertEquals('1,2,3', xo.addInfoMessage('{0},{1},{2}', 1, 2, 3));
    	
    	system.assertEquals('1', xo.addErrorMessage('{0}', '1'));
    }
    
    static testMethod void dependentTest()
    {
    	TestObject xo1 = new TestObject();
    	TestObject xo2 = new TestObject();
    	
    	system.assertEquals(0, xo1.getDependents().size());
    	xo1.addDependent(xo2);
    	system.assertEquals(1, xo1.getDependents().size());
    	xo1.removeDependent(xo2);
    	system.assertEquals(0, xo1.getDependents().size());
    	xo1.removeDependent(null); // should't throw exception
    }
    
    static testMethod void convenienceMethodsTest()
    {
    	TestObject xo = new TestObject();
    	
    	system.assertEquals('\'test\'', xo.singleQuote('test'));
    	system.assertEquals('two', xo.coalesce((string) null, 'two'));    	
    }
    
    static testMethod void coalesceTest()
    {
    	TestObject xo = new TestObject();
    	
    	system.assertEquals(Date.Today(), xo.coalesce(Date.Today(), Date.Today().addDays(1)));
    	system.assertEquals(Date.Today(), xo.coalesce(null, Date.Today()));
    	
    	system.assertEquals('Hello', xo.coalesce('Hello', 'World'));
    	system.assertEquals('World', xo.coalesce((string) null, 'World'));
    	system.assertEquals('Neither', xo.coalesce(null, null, 'Neither'));
    	
    	system.assertEquals(1.0, xo.coalesce(1.0, 2.0));
    	system.assertEquals(2.0, xo.coalesce(null, 2.0));
    	
    	Task t1 = new Task(Subject = 'task 1', ActivityDate = Date.Today(), Status = 'Completed');
    	insert t1;

		system.assertEquals(String.ValueOf(t1.id), xo.coalesce(t1.id, '000000000000000000'));    	
    }
    
    static testMethod void sublcassErrorTest()
    {
    	XedeObject anObject = new XedeObject();
    	
    	list<sobject> sobjectList = new list<sobject>();
    	try {
    		anObject.saveTo(sobjectList);
    		system.assert(false, 'should throw exception');
    	}
    	catch (XedeException ex) {
    		
    	}
    }
    
    static testMethod void miscellaneousTest()
    {
    	XedeObject xo = new XedeObject();
    	system.assert(xo.printString().startsWithIgnoreCase('xedeobject'));
    }
}