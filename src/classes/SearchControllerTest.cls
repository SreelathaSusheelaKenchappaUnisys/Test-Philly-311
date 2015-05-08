@isTest
private class SearchControllerTest {

    static testMethod void myUnitTest() {
        list<string> idList = SetSearchResults();
        Test.setFixedSearchResults(idList);
        
        system.assert(idList.size() > 2, 'there must be at least two records -- I inserted them!');
        
        SearchResponse aResponse = SearchController.Search('graffiti');
        system.debug(aResponse);
    }
    
    static list<string> SetSearchResults() {
    	
    	Account philly = new Account(name = 'City of Philadelphia');
    	insert philly;
    	
    	list<sobject> sobjectList = new list<sobject>();

    	sobjectList.add(new Contact(firstName = 'first', lastName = 'last', accountid = philly.id));
    	
    	insert sobjectList;
    	
    	list<string> idList = new list<string>();
    	idList.add(philly.id);
    	for (sobject each : sobjectList)
    		idList.add(each.id);
    	
    	for (RecordType each : [ select id from RecordType ])
    		idList.add(each.id);
    	
    	return idList;
    }
}