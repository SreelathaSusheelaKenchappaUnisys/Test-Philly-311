@isTest 
//Test class for testing the trigger on cases
private class RateArticleControllerTest {
    public static PageReference pageRef = Page.X311TemplateFAQRatestar;
    static testMethod void RateArticleControllerTest1() { 
        Test.setCurrentPage(pageRef);
        RateArticleController c = new RateArticleController ();
        c.rating = 1;
        c.rateArticle1();
        c.rateArticle1();
    }   
    static testMethod void RateArticleControllerTest2() { 
        Test.setCurrentPage(pageRef);
        RateArticleController c = new RateArticleController ();
        c.rating = 2;
        c.rateArticle2();
    }
    static testMethod void RateArticleControllerTest3() { 
        Test.setCurrentPage(pageRef);
        RateArticleController c = new RateArticleController ();
        c.rating = 3;
        c.rateArticle3();
    }
    static testMethod void RateArticleControllerTest4() { 
        Test.setCurrentPage(pageRef);
        RateArticleController c = new RateArticleController ();
        c.rating = 4;
        c.rateArticle4();
    }
    static testMethod void RateArticleControllerTest5() { 
        Test.setCurrentPage(pageRef);
        RateArticleController c = new RateArticleController ();
        c.rating = 5;
        c.rateArticle5();
    }
}