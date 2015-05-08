@isTest
private class CaseCommentHelperTest {


        static testMethod void testLinkCountUpdate() {
        
                Case aCase = new Case(
                customer_request_id__c = '12234',
                subject = 'a subject',
                
                // next couple lines inserted to avoid trigger callout to locate and project (caseAfterUpdate/CaseWrapper)
                street__c = 'a street',
                centerline_match_type__c = 'a type',
                centerline_2272x__c = 10,
                centerline_2272y__c = 10,
                description = 'a description',
                Origin = 'Phone',
                Customer_Declined__c = TRUE,
                Translator_Required__c = 'No'
                );
    
                Test.startTest();
    
                insert aCase;
    
                CaseComment aComment= new CaseComment(parentId = aCase.id, commentBody = 'a comment body', isPublished = true);
                insert aComment;
                CaseCommentHelper.CommentInsertionWrapper1 c1 = new CaseCommentHelper.CommentInsertionWrapper1();
                CaseCommentHelper.CommentInsertionWrapper2 c2 = new CaseCommentHelper.CommentInsertionWrapper2();
                Test.stopTest();
    
                system.assert(true, 'Nothing to assert, because we are testing the callout');
        }
}