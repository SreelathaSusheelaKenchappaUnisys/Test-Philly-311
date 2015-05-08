/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public with sharing class FeedbackException extends Exception {
        public enum Error { Success, Failure }
        
        public static void RaiseSuccess(Feedback aFeedback){
               
                FeedbackException ex = new FeedbackException(aFeedback.getSummary() == null ? '' : aFeedback.getSummary());
                ex.goodFeedback = aFeedback;
                ex.error = Error.Success;
                ex.name = aFeedback.getName();
                ex.id = aFeedback.getId();
                
                throw ex;
        }
        
        public static void RaiseError(string aString, Exception innerException){
        
                FeedbackException ex = new FeedbackException(aString, innerException);
                ex.error = Error.Failure;
                ex.name = null;
                ex.id = null;
                
                throw ex;
        }
        
        public string getXmlString() {
                XmlStreamWriter xwriter = new XmlStreamWriter();
                xwriter.writeStartDocument(null, '1.0');
                
                xwriter.writeStartElement(null, 'feedback', null);
                
                xwriter.writeAttribute(null, null, 'version', '1.0');
                
                xwriter.writeAttribute(null, null, 'type', String.ValueOf(error));  
                xwriter.writeAttribute(null, null, 'name', name == null ? '' : name);           
                xwriter.writeAttribute(null, null, 'id', id == null ? '' : id);
                
                xwriter.writeCharacters(getCause() == null ? getMessage() : getCause().getMessage());
        
                xwriter.writeEndElement();
                
                xwriter.writeEndDocument();
                
                return xwriter.getXmlString();
        }
        
        public Error error { get; private set; }
        Feedback goodFeedback;
        public string name { get; private set; }
        public string id { get; private set; }
}