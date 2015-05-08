@isTest(SeeAllData = True) 
//Test class for testing the Email Service ProcessArticleSubscriptionEmail
private class ProcessArticleSubscriptionEmailTest {
    static testMethod void testEmail1() { 
        try{
            FAQ1__kav flist1 = [select ArticleNumber from FAQ1__kav where PublishStatus='Online' and Language='en_US' ORDER BY LastModifiedDate desc limit 1]; 
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            email.subject = 'Test Article Subscription';
            email.fromAddress = 'someaddress@email.com';
            email.plainTextBody= flist1.ArticleNumber;
            ProcessArticleSubscriptionEmail pa = new ProcessArticleSubscriptionEmail();
            Messaging.InboundEmailResult  result = pa.handleInboundEmail(email,env);
            system.assertEquals(result.Success,true);
            }catch(Exception e) {
                system.debug('exception occured' + e.getMessage());
            }
    }
}