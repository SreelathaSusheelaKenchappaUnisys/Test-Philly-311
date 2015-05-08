public with sharing class X311TemplateController {
    ApexPages.StandardController pstdController;
    public String srcUpUrl { get; set; }
    
    public X311TemplateController(ApexPages.StandardController stdController) {
        pstdController=stdController;
    }

    public PageReference logCase() {
        List<RecordType> lst=[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Case' 
        							AND Name = 'Information Request'];
    
        if (!lst.IsEmpty()) {
        	FAQ1__kav record=((FAQ1__kav)pstdController.getRecord());
            Case cs=new Case(Type='Information Request Type',RecordTypeId=lst[0].Id, 
            			Subject=record.Title, 
            			Department__c=record.Department__c,
            			Case_Record_Type__c='Information Request');
            insert cs;
            CaseArticle ca=new CaseArticle(CaseId=cs.Id, KnowledgeArticleId=pstdController.getId());
            insert ca;
            srcUpUrl='/' + cs.Id + '/e';
        }
        return null;
    }

}