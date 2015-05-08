/*
Copyright 2013, Xede Consulting Group, Inc.
*/

public without sharing class FeedbackExtension extends XedeController {
    
        public FeedbackExtension(ApexPages.StandardController aController){
        }
        
        public string getWeeksByDateProductUser(){
        
                Report aReport = [ Select id From Report where name = 'Feedback Weeks by date, product, user' limit 1 ];
                return aReport == null ? null : aReport.id;
        }
        
        public list<Feedback_Week__c> getFeedbackWeeks() {
                return  [ 
                    select  user__r.name,
                            ending_date__c,
                            feedback__r.name,
                            feedback__r.summary__c,
                            monday_hours__c,
                            tuesday_hours__c,
                            wednesday_hours__c,
                            thursday_hours__c,
                            friday_hours__c,
                            saturday_hours__c,
                            sunday_hours__c,
                            total_hours__c
                      from  feedback_week__c
                      where  user__c = :UserInfo.GetUserId()
                      order  by ending_date__c desc
                ];
        }
        
}