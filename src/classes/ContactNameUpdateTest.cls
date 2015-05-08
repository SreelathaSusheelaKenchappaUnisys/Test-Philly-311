@isTest 
private class ContactNameUpdateTest{
  
      static testMethod void validateEmail() {
          Contact con = new Contact(LastName='Test',Email='test@mail.com');
          insert con;
          con = new Contact(LastName='Test1',Email='test@mail.com');
          try {
              insert con;          
          }    
          catch(DMLException dex)    {
                   System.assertEquals('System.DmlException',dex.getTypeName());
          }
      }
}