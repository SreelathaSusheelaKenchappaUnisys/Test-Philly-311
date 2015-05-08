@isTest
//Test class for testing the trigger on cases
private class SubscribeToArticeControllerTest {
    static testMethod void SubscribeToArticeTest1() { 
    
        FAQ1__kav testKnowledgeArticle = new FAQ1__kav();
        testKnowledgeArticle.Language = 'en_US';
        testKnowledgeArticle.Keywords__c= 'test,article';
        testKnowledgeArticle.Department__c='Philly311 Contact Center';
        testKnowledgeArticle.Title='How can I register for the next Neighborhood Liaison refresher training?';
        testKnowledgeArticle.UrlName = 'How-can-I-register-for';
        insert testKnowledgeArticle;
        FAQ1__kav flist = [select articleNumber from FAQ1__kav where id =: testKnowledgeArticle.id ];
        //FAQ1__kav flist1 = [select id, ArticleNumber from FAQ1__kav where PublishStatus='Online' and Language='en_US' ORDER BY LastModifiedDate desc limit 1]; 
        SubscribeArticle__c subscribe = new SubscribeArticle__c(ArticleID__c=testKnowledgeArticle.articleNumber,ContactNumber__c='90000000000',email__c='test@citywide.com',LastName__c='test');
        PageReference pageRef = Page.SubscribeToArticle;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('artnum', flist.articleNumber);
        ApexPages.StandardController sc = new ApexPages.StandardController(subscribe);
        SubscribeToArticeController sub = new SubscribeToArticeController(sc);
        system.debug('sc object instance'+sc);
        sub.Subscribe();
        system.debug('pageReference is '+sub.subscribe());
        system.assertNotEquals(null, sub.Subscribe());
        
    }
}