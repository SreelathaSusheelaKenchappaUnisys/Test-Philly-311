/* Controller for article subscription page

 */

public with sharing class SubscribeToArticeController {
    public string article{get;set;}
    public SubscribeArticle__c cs;
    public string num{get;set;}
    public ApexPages.StandardController pScontroller =null;
    pageReference pr=null;

    public SubscribeToArticeController(ApexPages.StandardController controller) {
        article=System.currentPageReference().getParameters().get('atrid');
        num=System.currentPageReference().getParameters().get('artnum');
        pScontroller=controller;
        cs=(SubscribeArticle__c)pScontroller.getRecord();
    }

    //Method for Subscribe button in 'Subscribe Article' page
    Public PageReference Subscribe() {
        cs.ArticleID__c= string.valueOf(num);
        //cs.UserProfileID__c = userInfo.getProfileId();
        system.debug(num+'number');
        if(cs.email__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Email'));
        }  if(cs.LastName__c == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Last Name'));
        } else {
            try{
                insert cs;  
                pr = new pageReference('/apex/SubscribeToArticleSuccess');
            } catch(Exception e ) {
                system.debug(e); 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
                pr = new pageReference('/apex/SubscribeToArticle?artnum='+num+'&atrid='+article); 
            }

            return pr;
        }  
        return null;
    }
}