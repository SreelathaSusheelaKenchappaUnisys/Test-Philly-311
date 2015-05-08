public with sharing class SelectContactMailController {
    public boolean chkbox1{get;set;}
    public boolean chkbox2{get;set;}
    public boolean chkbox3{get;set;}
    public boolean chkbox4{get;set;}
    public boolean chkbox5{get;set;}
    public boolean closeFlag{get;set;}
    public Contact cs=null;
    public string temp;
    public PageReference pr;
    public ApexPages.StandardController pScontroller =null;
    public string searchString2{get;set;}
    
     public void setcloseFlag(boolean closeFlag) {
        this.closeFlag = closeFlag;
    }
    
    public boolean getcloseFlag() {
        return closeFlag;
    }

    
    public SelectContactMailController(ApexPages.StandardController controller) {
        pScontroller=controller;
        cs=(Contact)pScontroller.getRecord();
        searchString2 = System.currentPageReference().getParameters().get('id');
        
    }
    
    public String getFields() {
       
        Contact c=[select email,lastName from contact where id=:searchString2];    
        return searchstring2+'hi'+string.valueOf(c);
    }

    public pageReference getEmails() {
        if(chkbox3==true) {
            temp=cs.Email;
            cs.Email=cs.email3__c;
            cs.email3__c=temp;
            chkbox3=false;
        }
    
        else if(chkbox4==true) {
            temp=cs.Email;
            cs.Email=cs.email4__c;
            cs.email4__c=temp;
            chkbox4=false;
        
        }
        else if(chkbox5==true) {
            temp=cs.Email;
            cs.Email=cs.email5__c;
            cs.email5__c=temp;
            chkbox5=false;
        
        
        }
        else if(chkbox2==true) {
            temp=cs.Email;
            cs.Email=cs.email2__c;
            cs.email2__c=temp;
            chkbox2=false;
        }
        try {  
            if(cs.Email!=null) {
                
            update cs;
            setCloseFlag(true);
            } else if(cs.Email == null ) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Primary e-mail cannot be left empty'));
              setCloseFlag(false);
            }
           
        } catch ( Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            setCloseFlag(false);
          }
            return null;
    }
 
  
}