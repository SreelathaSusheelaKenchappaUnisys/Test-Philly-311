public class ContactController {

        public ContactController(ApexPages.StandardController controller) {

        }

        public Static PageReference controller1()  {
    
                list<User>  Uid = [SELECT Id,ContactId FROM User WHERE Id=:userinfo.getuserID()];
                Contact c = [Select id From Contact Where Id =: Uid[0].ContactId];
                String s = '';
                if(c != null)
                        s = c.Id;
                //   return s;
               //{!URLFOR('/liaisons/'{!controller1})
               return new PageReference('/'+s);
               }
        }