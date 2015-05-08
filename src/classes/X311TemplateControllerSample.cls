public without sharing class X311TemplateControllerSample {
    ApexPages.StandardController pstdController;
    public String srcUpUrl { get; set; }
    public FAQ1__kav record1{get;set;}
    public RateArticle__c articleRate = new RateArticle__c() ;
    public decimal rating{get;set;}
    public string test{get;set;}
    public string knowledgeArtID {get;set;}
    
    public X311TemplateControllerSample(ApexPages.StandardController stdController) {
        
        pstdController=stdController;
        record1=((FAQ1__kav)pstdController.getRecord());
        test = record1.articleNumber;
         
            try {
                
               knowledgeArtID =[select id,KnowledgeArticleId,ArticleNumber from FAQ1__kav where PublishStatus='Online' and Language='en_US' and KnowledgeArticleId =: pstdController.getId() limit 1 ].KnowledgeArticleId;
                articleRate = [select id, rating__c,Article_Number__c,User_Id__c from RateArticle__c where Article_Number__c =:test and User_Id__c=:UserInfo.getUserID() LIMIT 1 ];
                rating = articleRate.rating__c;
            } catch (Exception e) {
                system.debug('error Message' + e.getMessage());
            }
    }
    public pageReference redirectSubscribe() {
    
    system.debug('ID OF'+record1.ArticleNumber);
    //FAQ1__kav record2=[ select id, ArticleNumber from FAQ1__kav where PublishStatus='Online' and Language='en_US' and ArticleNumber=:record1.ArticleNumber  ] ;
    
    return new pageReference('/apex/SubscribeToArticle?atrid='+record1.id+'&artnum='+record1.ArticleNumber);
    
    }
    public pageReference rateArticleRedirect() {
        return new pageReference('/apex/X311TemplateFAQRatestar?atrid='+record1.id+'&artnum='+record1.ArticleNumber+'&id='+knowledgeArtID);
    }

    public PageReference logCase() {
       
        System.Debug('Log Information Method Called.');
        List<RecordType> lst=[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Case' 
                                    AND Name = 'Information Request'];
        System.Debug('RecordType List Length: ' + lst.size());
        
        if (!lst.IsEmpty()) {
            System.Debug('Information Request Type id: ' + lst[0].Id);
            FAQ1__kav record=((FAQ1__kav)pstdController.getRecord());
            system.debug('record of knowledge article is ' + record);
            Case cs=new Case(Type='Information Request Type',RecordTypeId=lst[0].Id, 
                        Subject=record.Title, 
                        Department__c=record.Department__c,
                        Case_Record_Type__c='Information Request',
                        Service_Request_Type__c='Information Request',
                        Origin = 'Phone',
                        Translator_Required__c = 'No',
                        Customer_Declined__c = True,
                        ByPass_VR_WF__c = true
                        );
            System.debug('Case to be inserted: ' + cs);
                        
            try {
                insert cs;
               // database.setSavePoint();
                system.debug('case created  is'+cs);
                
                System.Debug('Inserting CaseArticle Now');
                
                CaseArticle ca=new CaseArticle(CaseId=cs.Id, KnowledgeArticleId=knowledgeArtID);
                system.debug('CaseArticle to be inserted: '+ ca);
                Database.insert(ca);
                system.debug('Case Article id is '+ ca);
                srcUpUrl='/' + cs.Id + '/e';
                
            } catch (Exception e){
                system.debug('exception occured '+e);
                system.debug('exception message'+ e.getMessage());
                srcUpUrl='/' + cs.Id + '/e';
            }           
            
        }
        return null;
    }

}