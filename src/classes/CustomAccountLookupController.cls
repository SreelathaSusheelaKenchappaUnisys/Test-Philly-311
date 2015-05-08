public with sharing class CustomAccountLookupController {


    public CustomAccountLookupController(){}
    Public contact cs =null ;
    public String nam { get; set; }
    public boolean flag {get;set;}
    public boolean res { get; set; }
    public String i { get; set; }
    public id idc;
    public ApexPages.StandardController pScontroller =null;
    public Account account{get;set;}
   // public Contact contact{get;set;} // new account to create
    public List<Contact> results{get;set;} // search results
    public string searchString{get;set;} // search keyword
    public List<Contact> results1{get;set;}
    
    // setters and getters for flag
    public void setFlag(boolean flag) {
        this.flag = flag;
    }
    
    public boolean getFlag() {
        return flag;
    }
    
    
    public CustomAccountLookupController(ApexPages.StandardController controller) {
        pScontroller = controller;
        cs = (contact)pScontroller.getRecord();
        
        String soql1 = 'SELECT Id, Name,phone, MailingStreet,MailingCity,MailingState,MailingCountry,Email FROM Contact where LastViewedDate != NULL ORDER BY LastViewedDate DESC ';
        results1 = database.query(soql1);
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();  
    }

   // performs the keyword search
   public PageReference search() {
       runSearch();
       return null;
   }
 
  // prepare the query and issue the search command
  public void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    
    results = performSearch(searchString);
    if(results.size() == 0)
        res = false;
    else 
         res = true;    
    System.debug('Results : ' + results.size());                 
  } 
 
  // run the search and return the records found. 
  public List<Contact> performSearch(string searchString) {
         
         String soql = 'select id,name,phone, MailingStreet,MailingCity,MailingState,MailingCountry,Email from contact';
         if(searchString != '' && searchString != null) {             
             // Support ticket fix for 09116219 start
             searchString = searchString.replaceAll('\'','\\\\\'');
             // Support ticket fix for 09116219 end
             System.Debug('Search String : ' + searchString);
             soql = soql +  ' where name LIKE \'%' + searchString +'%\''; 
             
         }    
         soql = soql + ' ORDER BY name limit 25' ;
         System.debug('SOQL: ' +soql);        
         return database.query(soql);   
        
         
  }

 
  
  // validate the email provided by the user and call save if no dupilcate email is found 
  public PageReference validateEmail() {
          list<contact> emailList = [select id, email from contact where id =: cs.id];
          if(emailList.size() > 0 ) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Unique email id'));    
              setFlag(false); 
              return null;
                      
          } else {
               
               return saveAccount();
          }
      
      
  }
  
  // save the new Contact record
  public  PageReference saveAccount() {
      
      System.debug('Inserting Contact');
      try    {
   
          setFlag(true);
          system.debug('flag value is' + getFlag());
          insert cs;
          i = cs.id;
          if(cs.FirstName != null)
          nam = cs.FirstName + ' ' + cs.lastName;
          else
          nam = cs.LastName;   
          return null;
   
       }
      catch (Exception e)    {
        
          setFlag(false);
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
          return null;
      }
  
     //return null;
  }

 // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
      return System.currentPageReference().getParameters().get('frm');
  }
 
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
      System.debug('TEXT BOX ID '+ System.currentPageReference().getParameters().get('txt')); 
      return System.currentPageReference().getParameters().get('txt');
  }
  
 }