public class CalculateBusinessHoursAgesTest {


        public static testMethod void testBusinessHoursBucketer() {
                Stop_Status__c ss = new Stop_Status__c(Name = 'On Hold');
                insert ss;
                Case c = new Case();
                c.Status = 'New';
                c.Last_Status_Change__c = System.Now();
                c.Description = 'a description';
                c.Street__c = '1200 yerkes';
                c.Subject = 'a subject';
                c.Origin='Phone';
                c.Translator_Required__c='No';
                c.Customer_Declined__c=TRUE;
                c.Centerline_2272x__c=1.2000;
                c.Centerline_2272y__c=1.6700;
                test.startTest();
                insert c;
              //  test.stopTest();   
                
                c.Status = 'On Hold';
              //  test.startTest();
                update c;
             //   test.stopTest();   
                
                c.Status = 'New';
              //  test.startTest();
                update c;
              //  test.stopTest();   

                Case updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];
                System.assert(updatedCase.Time_With_Customer__c!=null);
                System.assert(updatedCase.Time_With_Support__c!=null);
                System.assert(updatedCase.Case_Age_In_Business_Hours__c==null);
        
              //  test.startTest();
                c.Status = 'Closed';
                update c;
                test.stopTest();      
                
                updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];
        
                System.assert(updatedCase.Time_With_Customer__c!=null);
                System.assert(updatedCase.Time_With_Support__c!=null);
                System.assert(updatedCase.Case_Age_In_Business_Hours__c!=null);
        }
}