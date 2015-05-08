/*
Copyright 2012, Xede Consulting Group, Inc.
*/
public without sharing class Feedback extends XedeObject {
        public void add(list<Attachment> aList) {        
                for(Attachment each : aList)
                        each.parentId = getId();                
                insert aList;
        }
        
        public void add(Task aTask) {      
                aTask.WhatId = getId();
                insert aTask;
        }
        
        string buildEndpoint(string uri, map<string, string> parameter) {
       
                string queryString = '';           
                for(string key : parameter.keySet()) {
                        string value = parameter.get(key);
                        if(value != null)
                                queryString += '&' + key + '=' + urlEncode(value);
                }
                
                return String.format('{0}?ignore=true{1}', new string[] { uri, queryString });
        }
        
        public Feedback copyForRelated() {
                Feedback__c child = sobjectData.clone(false,true);
                child.Assigned_To__c = null;
                child.Closed_Date__c = null;
                child.Close_Status__c = null;
                child.Description__c = null;
                child.Open_Time__c = null;
                child.Resolution__c = null;
                child.Status__c = 'New';
                child.Summary__c = null;
                
                return new Feedback(child);
        }
        
        public static void FixOpenTime(string aString){
        
                list<Feedback__c> aList = [ select id, createdDate, open_time__c from feedback__c where open_time__c = null ];
                
                if(aString.tolowercase() == 'count')
                        XedeException.Raise('found {0} records without open times.', aList.size());
        
                for(Feedback__c each : aList)
                        each.open_time__c = each.createdDate;
        
                if(aString.tolowercase() == 'commit')      
                        update aList;
        }
        
        public Feedback(Feedback__c aFeedback)  {
      
                sobjectData = aFeedback;
        }
        
        public Feedback() { sobjectData = new Feedback__c(); } // discouraged...
        
        public Feedback(string anId){
        
                refresh(anId);
        }
        
        public Feedback(string aType, string aDescription){
               
                this(aType, '', aDescription);  
        }
        
        public Feedback(string aType, string aSummary, string aDescription) {
       
                this(UserInfo.GetOrganizationId(), null, aType, aSummary, aDescription);
        }
        
        public Feedback(string anOrgId, string anOrgName, string aType, string aSummary, string aDescription){
        
                if (aSummary == '' || aSummary == null)
                        aSummary = SummaryFromString(aDescription);
                
                sobjectData = new Feedback__c(
                organization_id__c = anOrgId,
                organization_name__c = anOrgName,
                type__c = aType, 
                summary__c = XedeUtil.TruncateStringAtFieldLength(aSummary, Feedback__c.Summary__c), 
                description__c = XedeUtil.TruncateStringAtFieldLength(aDescription, Feedback__c.Description__c)
                );
        }
        
        static string SummaryFromString(String aString) {
       
                if (aString == null || aString.trim().length() == 0)    
                        return '';
                
                string sentence;
                string[] strings = aString.split('[\\.\n\r\\?\\!]');
            
                if (strings.isEmpty())
                        sentence = aString;
                else
                        sentence = strings[0];
                
                return Left(sentence, 40);
        }
    
        public string getAssignedto() { return sobjectData.assigned_to__c; }
        public string getConfigOwner() { return config == null ? '' : config.Owner__c; }
        public string getConfigProductCategory() { return config == null ? '' : config.Product_Category__c; }
        public string getDescription() { return sobjectData.description__c; }
        public string getHost() { return sobjectData.host__c; }
        public string getId() { return (string) sobjectData.id; }
        public string getName() { return sobjectData.name; }
        public string getOrganizationId() { return sobjectData.organization_id__c; }
        public string getOrganizationName() { return coalesce(sobjectData.organization_name__c, ''); }
        public string getReferrer() { return sobjectData.referer__c; }
        public string getStatus() { return sobjectData.status__c; }
        public string getSummary() { return sobjectData.summary__c; }
        public string getType() { return sobjectData.type__c; }
        public string getUrl() { return sobjectData.Long_url__c; }
        public string getUserAgent() { return sobjectData.User_Agent__c; }
        public string getUserEmail() { return sobjectData.user_email__c; }
        public string getUserName() { return sobjectData.user_name__c; }
        
        public static void HandleAfterUpdate(list<Feedback__c> newList, list<Feedback__c> oldList) {
       
                // build list of organization ids in the new records
                list<string> orgIdList = new list<string>();
                for(Feedback__c each : newList)
                        if (String.IsNotBlank(each.organization_id__c))
                                orgIdList.add(each.organization_id__c);
                
                // select any that may already exist
                list<Feedback_Account_Org__c> faoList = [select id, org_id__c, org_name__c from Feedback_Account_Org__c where org_id__c in :orgIdList];
                map<string, Feedback_Account_Org__c> faoMap = new map<string, Feedback_Account_Org__c>();
                for(Feedback_Account_Org__c each : faoList)
                        faoMap.put(each.org_id__c, each);
                
                for(Feedback__c each : newList) {
                        if(String.IsBlank(each.organization_id__c))
                                continue;
                        
                        Feedback_Account_Org__c anFao = faoMap.get(each.organization_id__c);
                    
                        if(anFao == null)
                                faoList.add(new Feedback_Account_Org__c(
                                Org_Id__c = each.Organization_Id__c,
                                Org_Name__c = each.Organization_Name__c
                                )
                                );
        
                        else if(anFao != null && String.IsNotBlank(each.Organization_Name__c))
                                anFao.org_name__c = each.Organization_Name__c;
                }
                
                upsert faoList;
        }
    
        public static void HandleInsert(list<Feedback__c> newList, list<Feedback__c> oldList){
        
            if(newList.size() == 0)
                    return;
            
            Organization anOrg = [ select id, name from Organization limit 1 ];
            User aUser = [ select id, name, email from User where id = :UserInfo.getUserId() limit 1 ];
            
            for(Feedback__c each : newList) {
                    if(String.IsBlank(each.organization_id__c)) {
                            each.organization_id__c = anOrg.id;
                            each.organization_name__c = anOrg.name;
                    }
                    
                    if(String.IsBlank(each.user_email__c))
                            each.user_email__c = aUser.email;
                    
                    if(String.IsBlank(each.user_name__c))
                            each.user_name__c = aUser.name;
            }
        }
        
        public static string Left(string aString, integer characters){
        
                if(aString == null)
                        return '';
                
                aString = aString.trim();
                return aString.substring(0, Math.Min(characters, aString.length()));
        }
        
        public static List<Feedback> ListFor(List<String> nameList) {
       
                String queryString = String.Format(
                    '{0} where name in {1}',
                    new string[] {
                        SOQLSelect(), XedeUtil.FormatListForQuery(nameList)
                    }
                );
        
                list<Feedback__c> objectList = sobjectListForQuery(queryString);
        
                list<Feedback> aList = new list<Feedback>();
        
                for(Feedback__c each : objectList)
                        aList.add(new Feedback(each));
        
                return aList;
        }
            
        public void refresh() { refresh(getId()); }
        
        void refresh(string anId){
        
                string queryString = String.Format(
                    '{0} where id = {1}',
                    new string[] {
                        SOQLSelect(), 
                        '\'' + anId + '\''
                    }
                );
            
                list<Feedback__c> aList = SobjectListForQuery(queryString);
                if(aList.size() != 1)
                        throw new system.Invalidparametervalueexception(aList.size() + ' rows instead of 1.', anId);
        
                system.assertEquals(anId, aList[0].id);                 
                sobjectData = aList[0];
        }
        
        override public void save() {
                super.save();
                refresh();
        }
        
        override public void saveTo(list<sobject> aList) {
       
                string ownerName = getConfigOwner();
                if(String.IsNotBlank(ownerName)) {
                        list<Group> groupList = [ select id from Group where name = :ownerName ];
                        
                        if(groupList.size() == 1)
                                sobjectData.OwnerId = groupList[0].id;
                            
                        else {
                                list<User> userList = [ select id from User where name = :ownerName ];
                                if (userList.size() == 1)
                                        sobjectData.OwnerId = userList[0].id;
                        }
                }
                
                string productCategory = getConfigProductCategory();
                if(String.IsNotBlank(productCategory))
                        sobjectData.Product_Category__c = productCategory;
                    
                aList.add(sobjectData); 
        }
        
        public void setAssignedTo(string aString) { sobjectData.assigned_to__c = aString; } 
        public void setConfig(Feedback_Config__c aConfig) { config = aConfig; } 
        public void setDescription(string aString) { sobjectData.description__c = Left(aString, Feedback__c.Description__c.getDescribe().getLength()); }
        public void setHost(string aString) { sobjectData.host__c = aString; }
        public void setOrganizationId(string aString) { sobjectData.organization_id__c = aString; }
        public void setOrganizationName(string aString) { sobjectData.organization_name__c = aString; }
        public void setOwnerId(string aString) { sobjectData.OwnerId = aString; }
        public void setReferrer(string aString) { sobjectData.referer__c = aString; }
        public void setStatus(string aString) { sobjectData.status__c = aString; }
        public void setSummary(string aString) { sobjectData.summary__c = aString; }
        public void setType(string aString) { sobjectData.type__c = aString; }
        public void setUrl(string aString) { sobjectData.Long_url__c = aString; }
        public void setUserAgent(string aString) { sobjectData.User_Agent__c = Left(aString, 255); }
    
        public void setUserEmail(string aString) { sobjectData.user_email__c = aString; }
        public void setUserName(string aString) { sobjectData.user_name__c = aString; }
    
        static List<Feedback__c> SObjectListForQuery(String queryString){
        
                system.debug('DynamicSOQL = ' + queryString);
                return Database.query(queryString);
        }
        
        static string SOQLSelect() {
                Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Feedback__c.fields.getMap();
                
                String theQuery = 'SELECT ' + String.join(new List<String>(fldObjMap.KeySet()),', ');
                theQuery += ' FROM Feedback__c';
                
                return theQuery;
        }
        
        string urlEncode(string aString){
        
                return String.isBlank(aString) ?
                    '' :
                EncodingUtil.urlEncode(aString, 'utf-8');
        }
        
        Feedback_Config__c config;
        Feedback__c sobjectData;
}