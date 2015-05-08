@isTest
private class XedeObjectHolderTest {    
    static testMethod void OneParentTwoChildrenTest() {
        Task t1 = new Task(Subject = 'task 1', ActivityDate = Date.Today(), Status = 'Completed');
        XedeObjectHolder parent = new XedeObjectHolder(t1);
        
        Attachment a1 = new Attachment(Name = 'doc 1', Body = Blob.ValueOf('some text'));
        parent.add(a1, 'parentId');
        
        Attachment a2 = new Attachment(Name = 'doc 2', Body = Blob.ValueOf('some text'));
        parent.add(a2, 'parentId');
        
        system.assertEquals(2, parent.size());
        
        parent.save();
        
        system.assertNotEquals(null, parent.getId());
        system.assertNotEquals(null, a1.id);
        system.assertNotEquals(null, a2.id);
        
        system.assertEquals(t1.id, a1.parentId);
        system.assertEquals(t1.id, a2.parentId);
        
        system.assertEquals(1, [ select id from Task where id = :t1.id ].size());
        system.assertEquals(2, [ select id from Attachment where parentId = :t1.id ].size());
        
        system.debug('\n' + XedeLog.GetLogString());
    }
    
    static testMethod void UpdateTwiceTest() {
        Task t1 = new Task(Subject = 'task 1', ActivityDate = Date.Today(), Status = 'Completed');
        XedeObjectHolder parent = new XedeObjectHolder(t1);
        
        Attachment a1 = new Attachment(Name = 'doc 1', Body = Blob.ValueOf('some text'));
        parent.add(a1, 'parentId');
        
        Attachment a2 = new Attachment(Name = 'doc 2', Body = Blob.ValueOf('some text'));
        parent.add(a2, 'parentId');
        
        parent.save();
        
        a1.ContentType = 'text/plain';
        
        try {
	        parent.save();
	        system.debug('\n' + XedeLog.GetLogString());
        } catch (Exception ex) {
        	system.debug('\n' + XedeLog.GetLogString());
        	throw ex;
        }
    }
}