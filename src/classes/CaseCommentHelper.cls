global class CaseCommentHelper {


        public static void SendSomething(id anId, id commentId, string aComment) {
                if (system.isFuture())
                        SendSomethingNow(anId, commentId, aComment);
                else
                        SendSomethingFuture(anId, commentId, aComment);
        }
        
        @future (callout=true)
        static void SendSomethingFuture(id anId, id commentId, string aComment) {
                SendSomethingNow(anId, commentId, aComment);
        }
        
        static void SendSomethingNow(id anId, id commentId, string aComment) {
                system.debug('HasFired = ' + HasFired);
                if (HasFired)
                        return;
                
                HasFired = true;
                
                Case aCase = [ Select id, CaseNumber, Customer_Request_id__c from case where id = :anId limit 1 ];
                system.assertNotEquals(null, aCase);
                
                CaseComment com = [ Select id, createdById, createdBy.Name, IsPublished from CaseComment where id =: commentId limit 1];
                system.assertNotEquals(null, com);
                
                String createdBy = 'Owner';
                if (String.IsNotBlank(com.createdBy.Name)) {
                        createdBy = com.createdBy.Name;
                }
                
                if (com.IsPublished == false || String.IsBlank(aCase.Customer_Request_Id__c))
                        return;
                
                Http http = new Http();
                HttpRequest request = new HttpRequest();
            
                request.setMethod('POST');
               
                String body = String.Format('requestId={0}&comment={1}&caseId={2}&caseNumber={3}',
                    new string[] { 
                        EncodingUtil.URLEncode(aCase.Customer_Request_id__c, 'UTF-8'),
                        EncodingUtil.URLEncode(aComment , 'UTF-8') ,
                        EncodingUtil.URLEncode(aCase.id, 'UTF-8'), 
                        EncodingUtil.URLEncode(aCase.CaseNumber, 'UTF-8') 
                    }
                );
                
                request.setBody(body);
                request.setEndpoint(String.Format('{0}/rest/philly311/comment_submitPS',
                new string[] { 
                X311SystemSettings.SAGURL()}));
                
                System.debug('Body: ' + body);
                    
                try {
                        CommentInsertionResponse comRes = new CommentInsertionResponse();
                        String statusCode = null;
                        String resp = null;
                        Httpresponse response = new Httpresponse();
                        if (!Test.isRunningTest())    {
                            response = http.send(request);                            
                            resp = response.getBody();        
                            System.debug(response.getStatusCode());
                            statusCode = String.valueOf(response.getStatusCode());
                         }   
                         else    {
                             statusCode = '400';
                         }
                        if (statusCode == '200') {
                                System.debug(response.getBody());
                                comRes = (CommentInsertionResponse)JSON.deserialize(resp, CommentInsertionResponse.class); 
                                System.debug('comRes.response: ' + comRes.response);
                                System.debug('comRes.StatusCode: ' + comRes.StatusCode);
                                System.debug('comRes.response.status.code: ' + comRes.response.status.code);
                        }
                        
                        if ((statusCode != '200' ) || comRes.response.status.code != '200') {
                                Matcher m = Pattern.compile('.{1,255}').matcher(aComment); 
                                Integer len = aComment.length();
                                Case_Comment_Insertion_Failed__c c = new Case_Comment_Insertion_Failed__c();
                                c.Name = commentId;
                                c.Case_ID__c = aCase.id ;
                                c.Case_Number__c = aCase.CaseNumber;
                                c.Case_Comment_Body_Size__c = len;
                                c.Customer_Request_ID__c = aCase.Customer_Request_id__c;          
                                c.Case_Comment_Body_1__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_2__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_3__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_4__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_5__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_6__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_7__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_8__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_9__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_10__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_11__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_12__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_13__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_14__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_15__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                c.Case_Comment_Body_16__c = m.find() ? aComment.substring(m.start(), m.end()) : '';
                                insert c;
                        }
                } catch(Exception ex) {
                
                 System.debug('Insertion Failed: ' + ex.getMessage());
                }        
        }
      
        public class CommentInsertionResponse {
                public CommentInsertionWrapper1  response;
                public String StatusCode;
                public String Status;
        }
      
        public class CommentInsertionWrapper1 {
                public CommentInsertionWrapper2  status;
        }
      
        public class CommentInsertionWrapper2 {
                public String message; 
                public String code_message;
                public String code;
                public String type;
        }
        
        static boolean HasFired = false;
}