global class SearchResponse extends XedeRemoteResponse {

	public SearchResponse(boolean aBoolean, string[] aStringArray)
	{
		super(aBoolean, aStringArray);
	}
		
	public static SearchResponse Ok(SearchController.SearchResult anElement)
	{
		list<string> errorMessages = new List<String>();
		
		SearchResponse aResponse = new SearchResponse(true, new list<string>());
		aResponse.addMessage(errorMessages);
		aResponse.searchResult = anElement;
		
		return aResponse;
	}

	public SearchController.SearchResult searchResult { get; private set; }
}