/* 
 * The batch class that is used to insert Comment in Public Stuff 
 * if initial try fails
 */

global class CommentInsertionPS implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
        public String query = 'Select Id, Name,Case_ID__c, Case_Number__c, Customer_Request_ID__c,Case_Comment_Body_Size__c, Case_Comment_Body_1__c, Case_Comment_Body_2__c, Case_Comment_Body_3__c, Case_Comment_Body_4__c, Case_Comment_Body_5__c, Case_Comment_Body_6__c, Case_Comment_Body_7__c, Case_Comment_Body_8__c, Case_Comment_Body_9__c, Case_Comment_Body_10__c, Case_Comment_Body_11__c, Case_Comment_Body_12__c, Case_Comment_Body_13__c, Case_Comment_Body_14__c, Case_Comment_Body_15__c, Case_Comment_Body_16__c from Case_Comment_Insertion_Failed__c';
        global Static List<String> caseDelete = new List<String>();
    
        // To Deserialize the response comming from SAG.
        global class CommentInsertionResponse {
                public CommentInsertionWrapper1  response;
        }
      
        global class CommentInsertionWrapper1  {
                public CommentInsertionWrapper2  status;
        }
      
        global class CommentInsertionWrapper2 {
                public String message; 
                public String code_message;
                public String code;
                public String type;
        }
      
        global Database.QueryLocator start(Database.BatchableContext BC) {
                return Database.getQueryLocator(query);
        }
    
        global void execute(Database.BatchableContext BC, List<Case_Comment_Insertion_Failed__c> records) { 
    
                // Intializing Variables
                String aComment = null;
                System.debug('Scheduler for Inserting Comment in PS is running.');
        
                if (records != null && records.size() != 0) {
                        System.debug('The query returned ' + records.size() + ' no of records.');   
            
                        for (Case_Comment_Insertion_Failed__c rec : records) {
                
                                aComment = rec.Case_Comment_Body_1__c + rec.Case_Comment_Body_2__c + rec.Case_Comment_Body_3__c + rec.Case_Comment_Body_4__c + rec.Case_Comment_Body_5__c + rec.Case_Comment_Body_6__c + rec.Case_Comment_Body_7__c + rec.Case_Comment_Body_8__c + rec.Case_Comment_Body_9__c + rec.Case_Comment_Body_10__c + rec.Case_Comment_Body_11__c + rec.Case_Comment_Body_12__c + rec.Case_Comment_Body_13__c + rec.Case_Comment_Body_14__c + rec.Case_Comment_Body_15__c + rec.Case_Comment_Body_16__c;
                                aComment = aComment.replaceAll('null',' ');
                                aComment = aComment.trim();
                             
                                Http http = new Http();
                                HttpRequest request = new HttpRequest();        
                                request.setMethod('POST');
                                String body = null;
                                body = String.Format('requestId={0}&comment={1}&caseId={2}&caseNumber={3}',
                                new string[] { 
                                    EncodingUtil.URLEncode(rec.Customer_Request_ID__c , 'UTF-8'),
                                    EncodingUtil.URLEncode(aComment , 'UTF-8') ,
                                    EncodingUtil.URLEncode(rec.Case_ID__c , 'UTF-8'), 
                                    EncodingUtil.URLEncode(rec.Case_Number__c , 'UTF-8') 
                                }
                                );
                                
                                request.setBody(body);
                                request.setEndpoint(String.Format('{0}/rest/philly311/comment_submitPS',
                                new string[] {X311SystemSettings.SAGURL()}));
                            
                                System.debug('Body: ' + body);
                            
                                // Test is running
                                if (Test.isRunningTest()) {
                                        System.debug('Test is Running: ' + Test.isRunningTest());
                                        CommentInsertionResponse comRes = new CommentInsertionResponse();
                                        CommentInsertionWrapper1 com1 = new CommentInsertionWrapper1();
                                        CommentInsertionWrapper2 com2 = new CommentInsertionWrapper2();
                                }    
                            
                                // If the test is not running, then we are making HTTP Callout
                                if (!Test.isRunningTest()) {
                                        try {
                                                Httpresponse response = http.send(request);
                                                System.debug('Response Code: ' +response.getStatusCode());
                                                System.debug('Response: ' + response.getBody());
                                        
                                                if (response.getStatusCode() == 200) {
                                                        CommentInsertionResponse comRes = (CommentInsertionResponse)JSON.deserialize(response.getBody(), CommentInsertionResponse.class); 
                                                if (comRes.response.status.code == '200') {
                                                        System.debug('Comment Inserted. Case Number: ' + rec.Case_Number__c + ', Customer Request ID: ' + rec.Case_ID__c + ', Comment ID: ' + rec.Name);    
                                                        caseDelete.add(rec.Name); 
                                                
                                                }  
                                                }     
                                        } catch (Exception ex) {
                                   
                                                System.debug('Error thrown while Inserting Case Comment in PS: ' + ex.getMessage());       
                                        }
                                } else {  
                                    
                                        caseDelete.add(rec.Name);
                                }
                        }
                }
                if (!caseDelete.isEmpty()) {
                        List<Case_Comment_Insertion_Failed__c> te = [Select id from Case_Comment_Insertion_Failed__c where Name IN: caseDelete];
                        System.debug('Comment to be deleted from Case_Comment_Insertion_Failed__c: ' + te.size());
                        System.debug(te);
                        Database.delete(te);  
                }                            
        }   
   
        global void finish(Database.BatchableContext BC){
                System.debug('Exiting Insert Comment.' );
                System.debug(caseDelete.size());
                for (String s :  caseDelete ) {
                        System.debug('Comment Inserted with ID:');
                        System.debug(s);             
                }    
        }
}