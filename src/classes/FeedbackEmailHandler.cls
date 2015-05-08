/*
Copyright 2012, Xede Consulting Group, Inc.
*/

/**
 * Both ownerIdFromEmail() and whoIdFromEmail() are nearly identical
 * functions, but regrettably from different objects.  Changes to
 * one likely indicate a possible change to the other until such
 * refactoring that makes this unnecessary.
 */ 
 
global class FeedbackEmailHandler implements Messaging.InboundEmailHandler {

        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
            
                debugEmail(email);
                
                Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
                result.success = true;
                result.message = null;
        
                list<Feedback> aList = new list<Feedback>();
                string ownerId = ownerIdFromEmail(email);
                string whoId = whoIdFromEmail(email);
                
                string fbRegexPattern = '[fF][bB]-\\d+';
                Pattern p = Pattern.compile(fbRegexPattern);
                
                list<string> fbNames = new list<string>();      
                Matcher m = p.matcher(email.subject);
                
                while (m.find())
                        fbNames.add(m.group());
                
                if (fbNames.isEmpty()) {
                    
                        if (String.IsBlank(ownerId)) {
                                result.success = false;
                                result.message = 'Could not process email from unknown user with subject ' + email.subject;
                                return result;
                        }
                        
                        aList.add(newFeedback(email, ownerId));
                        result.message = 'Created new ticket, ' + aList[0].getName();
                } else {
                
                        //if we found an FB- pattern then we should make sure we found the feedback. If there's no FB- pattern let's create a feedback
                        aList = Feedback.ListFor(fbNames);
                        
                        if (aList.isEmpty()) { 
                                result.success = false;
                                result.message = 'Could not find feedback items for ' + fbnames;
                                return result;
                        }
                }
                
                Feedback aFeedback = aList[0];
                
                XedeTestData data = new XedeTestData('FeedbackTestData');
                string format = data.find('EmailActivityFormat');
                string description = String.Format(
                        format,
                        new string[] {
                                dateStringFromEmail(email),
                                email.fromAddress,
                                email.toAddresses == null ? '' : String.Join(email.toAddresses, ', '),
                                email.ccAddresses == null ? '' : String.Join(email.ccAddresses, ', '),
                                email.plainTextBody
                        }
                );
                
                Task aTask = new Task(
                
                    subject = email.subject,
                    Status = 'Completed',
                    Description = description,
                    ActivityDate = Date.Today(),
                    OwnerId = ownerId,
                    WhoId = whoId
                );
                
                system.debug(aTask);
                
                aFeedback.add(aTask);
                
                list<Attachment> attachmentList = new list<Attachment>();
        
                if (email.binaryAttachments != null){
                
                        for (Messaging.InboundEmail.BinaryAttachment each : email.binaryAttachments)
                                attachmentList.add(new Attachment (Body = each.body, Name = each.fileName, ContentType = each.mimeTypeSubType));
                }
                
                if (email.textAttachments != null){
                
                        for (Messaging.InboundEmail.TextAttachment each : email.textAttachments)
                                attachmentList.add(new Attachment (Body = Blob.valueOf(each.body), Name = each.fileName, ContentType = each.mimeTypeSubType));
                }
                
                List<Attachment> updateAttachmentList = createCalendarEventsAndRemoveFromList(attachmentList, aFeedback);
                
                aFeedback.add(updateAttachmentList);
        
                return result;
        }
        
        private List<Attachment> createCalendarEventsAndRemoveFromList(List<Attachment> anAttachmentList, Feedback aFeedback) {
    
                List<Attachment> listWithoutCalendarEvents = new List<Attachment>();
                
                String meetingInvite;
                
                for (Attachment each : anAttachmentList) {
                        if (each.ContentType.equalsIgnoreCase('application/ics') || each.ContentType.equalsIgnoreCase('text/calendar'))
                                meetingInvite = each.Body.toString();
                        else
                                listWithoutCalendarEvents.add(each);
                }
                
                if (meetingInvite != null) {
                        try {
                                Vics.InsertEventFromIcs(meetingInvite, aFeedback.getId());
                        }catch (Exception ex) { // swallow errors.  Event invitations are disposable
                    
                                system.debug(ex.getMessage());
                                system.debug(ex.getStackTraceString());
                        }
                }
                
                return listWithoutCalendarEvents;
        }
    
        string dateStringFromEmail(Messaging.InboundEmail anEmail){
        
                for (Messaging.InboundEmail.Header each : anEmail.headers)
                        if (each.name.toLowerCase() == 'date')
                            return each.value;
            
                return '';          
        }
        
        public FeedbackEmailHandler(){}
        public FeedbackEmailHandler(ApexPages.StandardController aController){}    
        
        public string getEmailAddress() {
                list<EmailServicesFunction> aList = [ Select (Select LocalPart, EmailDomainName From Addresses) From EmailServicesFunction e where e.apexClassId in (select id from apexclass where name = 'FeedbackEmailHandler') ];
                if (aList.isEmpty())
                        return null;
                
                if (aList[0].Addresses.isEmpty())
                        return null;
                
                else return aList[0].Addresses[0].localPart + '@' + aList[0].Addresses[0].emailDomainName;
        }
        
        Feedback newFeedback(Messaging.InboundEmail email, string whoId){
                Feedback fb = new Feedback('', email.subject, email.plainTextBody);
                if (whoId != null) {
                
                    // fb-00385
                    if (String.isBlank(email.fromAddress) == false)
                            fb.setUserEmail(email.fromAddress);
                    fb.setOwnerId(whoId);
                    fb.setAssignedTo(whoId);
                }
                fb.save();
                return fb;
        }
        
        string ownerIdFromEmail(Messaging.InboundEmail anEmail){
        
                string anId = UserInfo.getUserId();
                list<User> aList = new list<User>();
                
                set<string> addressList = new set<string>();   
                    
                if (String.IsNotBlank(anEmail.fromAddress))
                        addressList.add(anEmail.fromAddress);
                
                if (String.IsNotBlank(anEmail.replyTo))
                        addressList.add(anEmail.replyTo);
                
                if (anEmail.toAddresses != null)
                        addressList.addAll(anEmail.toAddresses);
                
                if (anEmail.ccAddresses != null)
                        addressList.addAll(anEmail.ccAddresses);
                
                aList = [ select id from User where isActive = true and userType in ('Standard') and email in :addressList ];
                if (aList.isEmpty() == false)
                        return aList[0].id;
                    
                return anId;
        }
        
        string whoIdFromEmail(Messaging.InboundEmail anEmail){
        
            string anId = null;
            
            list<string> fromAddresses = new list<string>();
            
            if (String.IsNotBlank(anEmail.fromAddress))
                    fromAddresses.add(anEmail.fromAddress);
            
            for (list<string> eachList : new list<list<string>> { fromAddresses, anEmail.toAddresses, anEmail.ccAddresses } ) {     
                    if (eachList != null && eachList.isEmpty() == false) {
                    list<Contact> aList = [ select id from Contact where email in :eachList ];
                    if (aList.isEmpty() == false)
                            return aList[0].id;
                    }
            }
                
            return anId;
        }
        
        void debugEmail(Messaging.InboundEmail email) {
            
                String headers;
                
                for (Messaging.Inboundemail.Header each : email.headers)
                        headers = headers + each.Name + ' : ' +each.Value + '\n';
                
                system.debug('\n\n*** *** *** DEBUG DUMP OF EMAIL START *** *** ***');
                
                system.debug('\n\nEmail Headers: Name : Value\n\n' + headers + '\n\n');
                
                system.debug('\n\nEmail Plain Text Body: \n\n' + email.plainTextBody + '\n\nEnd of Plain Text Body\n\n');
        
                system.debug('\n\nEmail HTML Body: \n\n' + email.HTMLBody + '\n\nEnd of HTML Body\n\n');
                
                if (email.binaryAttachments != null) {
                        system.debug('\n\nNumber of Binary Attachments: ' + email.binaryAttachments.size() +'\n\n');
                    
                        for (Messaging.InboundEmail.Binaryattachment each : email.binaryAttachments) {
                                system.debug('\n\nBinary Attachement fileName: ' + each.fileName + '\n\n');
                                system.debug('\n\nBinary Attachement mimeTypeSubType: ' + each.mimeTypeSubType + '\n\n');
                                system.debug('\n\nBinary Attachement body: \n\n' + each.body + '\n\n');
                                try {
                                        system.debug('\n\nBinary Attachement body.toString(): \n\n' + each.body.toString() + '\n\n');
                                }catch (system.Stringexception ex) { } 
                                
                        }
                    
                        system.debug('\n\nEnd of Binary Attachments\n\n');
                } else {
               
                        system.debug('\n\nEmail Has No Binary Attachements\n\n');
                }
                
                if (email.textAttachments != null) {
                        system.debug('\n\nNumber of Text Attachments: ' + email.textAttachments.size() + '\n\n');
                    
                        for (Messaging.InboundEmail.Textattachment each : email.textAttachments) {
                                system.debug('\n\nText Attachement fileName: ' + each.fileName + '\n\n');
                                system.debug('\n\nText Attachement mimeTypeSubType: ' + each.mimeTypeSubType + '\n\n');
                                system.debug('\n\nText Attachement bodyIsTruncated: ' + each.bodyIsTruncated + '\n\n');
                                system.debug('\n\nText Attachement body: \n\n' + each.body + '\n\n');
                                system.debug('\n\nText Attachement charset: \n\n' + each.charset + '\n\n');
                        }
                    
                        system.debug('\n\nEnd of Text Attachments\n\n');
                }else {
                
                        system.debug('\n\nEmail Has No Text Attachements\n\n');
                }
                
                system.debug('\n\n*** *** *** DEBUG DUMP OF EMAIL END *** *** ***');
        }
}