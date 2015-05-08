public with sharing class RateArticleController {
public decimal rating{get;set;}
public RateArticle__c articleRate = new RateArticle__c() ;
public list<RateArticle__c> averageRatingList = new list<RateArticle__c>();
public string artId{get;set;}

    public RateArticleController(ApexPages.KnowledgeArticleVersionStandardController controller) {
        artId =apexpages.currentpage().getparameters().get('artnum');
        
        if(artId != null) {
            try {
                articleRate = [select id, rating__c,Article_Number__c,User_Id__c from RateArticle__c where Article_Number__c=:artId and User_Id__c=:UserInfo.getUserID() LIMIT 1 ];
                rating = articleRate.rating__c;
                system.debug('in constructor');
                system.debug('article list '+ articleRate);
                //averageRatingList = [select Article_Number__c,rating__c from RateArticle__c where Article_Number__c=:artId];   
            } Catch(Exception e) {
                system.debug('Exception Occured'+ e.getMessage());    
            }
        } 
    }
 
    public RateArticleController() {
       
        
    }

    public decimal getAverageRating() {
        averageRatingList = [select Article_Number__c,rating__c from RateArticle__c where Article_Number__c=:artId]; 
        decimal temp = 0.0;
        for(RateArticle__c i : averageRatingList) {
            temp=temp+i.rating__c;
        }
        
        if(averageRatingList.size()>0) {
            return (temp/averageRatingList.size());        
        } else 
        
        return 0.0;    
        
    }
    
    public pageReference rateArticle1() {
        system.debug('in rateArticle1 method');
        system.debug('article rating object for rateArticle1 method'+articleRate);
      
        if(articleRate.rating__c == null) {
            
                rating = 1;
                articleRate.Article_Number__c = apexpages.currentpage().getparameters().get('artnum');
                articleRate.rating__c = 1;
                articleRate.User_Id__c = UserInfo.getUserID();
            try {
                insert articleRate;    
                system.debug('insert succesful: '+articleRate.id);
            } catch(Exception e ) {
                apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
        
        }else{
            rating = 1.00;
            articleRate.rating__c = 1.00;
            try {
                update articleRate;
                system.debug('update successful');
            }catch(Exception e ) {
                    apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
       } 
        return null;
    }

    public pageReference rateArticle2() {
        system.debug('in rateArticle2 method');
        system.debug('article rating object for rateArticle1 method'+articleRate);
      
        if(articleRate.rating__c == null) {
            
                rating = 2;
                articleRate.Article_Number__c = apexpages.currentpage().getparameters().get('artnum');
                articleRate.rating__c = 2;
                articleRate.User_Id__c = UserInfo.getUserID();
            try {
                insert articleRate;    
                system.debug('insert succesful: '+articleRate.id);
            } catch(Exception e ) {
                apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
        
        }else{
            rating = 2.00;
            articleRate.rating__c = 2.00;
            try {
                update articleRate;
                system.debug('update successful');
            }catch(Exception e ) {
                    apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
       } 
        return null;
    }
    public pageReference rateArticle3() {
        system.debug('in rateArticle1 method');
        system.debug('article rating object for rateArticle1 method'+articleRate);
      
        if(articleRate.rating__c == null) {
            
                rating = 3;
                articleRate.Article_Number__c = apexpages.currentpage().getparameters().get('artnum');
                articleRate.rating__c = 3;
                articleRate.User_Id__c = UserInfo.getUserID();
            try {
                insert articleRate;    
                system.debug('insert succesful: '+articleRate.id);
            } catch(Exception e ) {
                apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
        
        }else{
            rating = 3.00;
            articleRate.rating__c = 3.00;
            try {
                update articleRate;
                system.debug('update successful');
            }catch(Exception e ) {
                    apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
       } 
        return null;
    }
    public pageReference rateArticle4() {
        system.debug('in rateArticle4 method');
        system.debug('article rating object for rateArticle1 method'+articleRate);
      
        if(articleRate.rating__c == null) {
            
                rating = 4;
                articleRate.Article_Number__c = apexpages.currentpage().getparameters().get('artnum');
                articleRate.rating__c = 4;
                articleRate.User_Id__c = UserInfo.getUserID();
            try {
                insert articleRate;    
                system.debug('insert succesful: '+articleRate.id);
            } catch(Exception e ) {
                apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
        
        }else{
            rating = 4.00;
            articleRate.rating__c = 4.00;
            try {
                update articleRate;
                system.debug('update successful');
            }catch(Exception e ) {
                    apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
       } 
        return null;
    }
    public pageReference rateArticle5() {
        system.debug('in rateArticle5 method');
        system.debug('article rating object for rateArticle1 method'+articleRate);
      
        if(articleRate.rating__c == null) {
            
                rating = 5;
                articleRate.Article_Number__c = apexpages.currentpage().getparameters().get('artnum');
                articleRate.rating__c = 5;
                articleRate.User_Id__c = UserInfo.getUserID();
            try {
                insert articleRate;    
                system.debug('insert succesful: '+articleRate.id);
            } catch(Exception e ) {
                apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
        
        }else{
            rating = 5.00;
            articleRate.rating__c = 5.00;
            try {
                update articleRate;
                system.debug('update successful');
            }catch(Exception e ) {
                    apexPages.addMessage(new ApexPages.Message(apexPages.SEVERITY.ERROR , e.getMessage()));
            }
       } 
        return null;
    }
}