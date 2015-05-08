global class ProcessArticleSubscriptionEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope) {
        
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            FAQ1__kav flist2 = null  ;
            String myPlainText = 'The knowledge article for which you have  subscribed has been updated. Please login to the below link to check the change';
            string articleNumber = email.plainTextBody;
            Messaging.reserveSingleEmailCapacity(100);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            list<String> addr=new list<String>();
            
            try {
                flist2 = [select id,isLatestVersion,ArticleNumber,KnowledgeArticleId,PublishStatus from FAQ1__kav where PublishStatus='Online' and Language='en_US' and ArticleNumber=:articleNumber limit 1 ];
               // system.debug( 'new list is '+ flist2);
                FAQ1__kav flist1 = [select id,ArticleNumber,KnowledgeArticleId,LastPublishedDate,LastModifiedDate,Summary,Title from FAQ1__kav where PublishStatus='Online' and Language='en_US' ORDER BY LastModifiedDate desc limit 1]; // and LastModifiedDate>:dt2 and LastModifiedDate<:dt
                
                for(SubscribeArticle__c sub:[select email__c,ArticleID__c from SubscribeArticle__c where ArticleID__c=:flist2.articleNumber]) {
                  //  System.debug('Entered For Loop');
                    addr.add(sub.email__c); 
                    system.debug('email addresses' + addr);               
                 }
             } catch (Exception e) {
                 system.debug('Exception Occured' + e.getMessage());
             }   
                        
               // system.debug('Exited for loop with the email addresses' + addr);
                list<String> ccaddr= new list<String>();
                mail.setToAddresses(addr);
                mail.setReplyTo('philly311@phila.gov');
                mail.setSenderDisplayName('City Of Philadelphia Knowledge Article');
                mail.setSubject('Knowledge Article Number '+flist2.articleNumber+ ' has been Updated');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody(myPlainText+'\n https://philly311--citywide--c.cs10.visual.force.com/apex/X311TemplateFAQSample?id='+id.valueOf(flist2.KnowledgeArticleId));
                if(flist2.PublishStatus=='Online' && flist2.isLatestVersion == true)
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
           
                return result;
    }
}