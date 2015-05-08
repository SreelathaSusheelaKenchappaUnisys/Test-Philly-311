/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class FeedbackExceptionTest {

        static testMethod void testConstructor() {
                Feedback fb = new Feedback('summary', 'description');       
                
                try {
                        fb.save();
                        system.assertNotEquals(null, fb.getId());
                        
                        FeedbackException.RaiseSuccess(fb);
                        
                        system.assert(false, 'should have thrown exception');
                } catch (FeedbackException fex) {
                
                        string xmlString = fex.getXmlString();
                        Dom.Document doc = new Dom.Document();
                        doc.load(xmlString);
                        Dom.Xmlnode root = doc.getRootElement();
                        system.assertEquals('feedback', root.getName());
                        system.assertEquals('Success', root.getAttribute('type', null));
                        system.assertNotEquals('', root.getAttribute('id', null));
                        system.assertNotEquals('', root.getAttribute('name', null));
                }
        }
}