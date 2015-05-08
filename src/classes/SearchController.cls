global with sharing class SearchController extends XedeController {
        
    global class SearchResult {
        public void add(list<sobject> objectList)
        {
            if (objectList == null || objectList.isEmpty())
                return;
            
            sobject anObject = objectList[0];
            resultMap.put(anObject.getSObjectType().getDescribe().getName(), objectList);
        }
        
        public map<string, list<sobject>> resultMap {get; private set; } { resultMap = new map<string, list<sobject>>(); }
    }

    SearchResult performSOSL(string criteria)
    {
        XedeLog.Debug('performSOSL([{0}])', criteria);
        
        SearchResult aSearchResult = new SearchResult();
        
        List<List<SObject>> resultList;
        
        if (String.isBlank(criteria))
            return new SearchResult();
        
        string queryString = 
            'FIND \'' + String.escapeSingleQuotes(criteria) + 
            '\' IN ALL FIELDS RETURNING ' +
            'Account (id, name order by name), ' +          
            'Contact (id, name, firstName, lastName, email, phone order by lastName, firstName), ' +
            'Case (id, CaseNumber, Subject, CreatedDate, LastModifiedDate, Status, Ticket__c ), ' +
            'Directory__c (id, name, department__c, Phone__c, Title__c,Case_Link__c, CreatedDate, LastModifiedDate ), ' +
            'X311RequestType__c (id, Request_Category__c, Name, Keywords__c, Description__c, Department__c, Case_RecordType_Name__c, Case_RecordTypeId__c, Case_Link__c), ' +
            'KnowledgeArticleVersion (KnowledgeArticleid, articleNumber, title, summary, lastPublishedDate, createdDate WHERE PublishStatus=\'Online\' AND Language= \'en_US\')';
        System.debug(queryString);
        
        resultList = search.query(queryString);
        for (list<sobject> each : resultList)
            aSearchResult.add(each);
        
        return aSearchResult;
    }
    
    @RemoteAction @ReadOnly
    global static SearchResponse Search(String value) {
        SearchController controller = new SearchController();
        SearchResponse aResponse;
        
        try {
            aResponse = SearchResponse.Ok(controller.searchAll(value));              
        }
        catch (Exception ex) {
            aResponse = new SearchResponse(false, new string[] { ex.getMessage() });
            aResponse.addMessage(ex.getStackTraceString());
        }
        
        aResponse.loadDebugLog();
        system.debug(aResponse.debugLog);
        return aResponse;
    }

    public SearchResult searchAll(string aString)
    {
        return performSOSL(aString);    
    }
    
    public PageReference logInfoRequest()    {
        RecordType rd = [Select id, Name, DeveloperName from RecordType WHERE DeveloperName= 'Information_Request'];
        String redURL = '/500/e?ekp=500&ent=Case&RecordType=' + rd.Id + '&x311rt=Information_Request';
        return new PageReference(redURL);
    }
}