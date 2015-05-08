public with sharing class PdfTemplateController {
    public case c;
    public case c1;
    public id  id1;
    public string DateForCaseCreation {get;set;}
    public string caseCommentForPdf{get;set;}
    public PdfTemplateController(ApexPages.StandardController controller) {
    id1= apexpages.currentpage().getparameters().get('id');
        if(id1!=null){
             c=[select caseNumber,createdDate from case where id=:id1];
             DateForCaseCreation = c.createdDate.format('MMMM d,  yyyy');
             Apexpages.currentPage().getHeaders().put('content-disposition', 'inline;filename=CaseNumber:'+c.caseNumber+'.pdf');
          /* try{
            List<Case> cases = [Select (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComments) From Case where id=: id1 ];
                caseCommentForPdf='';
                for(Case c : cases){
                   for(CaseComment comm : c.CaseComments){
                        caseCommentForPdf += comm.CommentBody+',';  
                    }
                }
                caseCommentForPdf = caseCommentForPdf.substring(0,(caseCommentForPdf.length()-1));
            } catch(Exception e){
                system.debug('Exception is '+ e.getMessage());
            } */
        }
    }
    
     public string getDate()    {
          
          Datetime myDatetime = Datetime.now();
          String myDatetimeStr = myDatetime.format('MMMM d,  yyyy');
          return myDatetimeStr ; 
       }
   
}