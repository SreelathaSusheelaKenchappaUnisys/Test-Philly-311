@isTest
global class GISAPIMock implements HttpCalloutMock {
	class Response {
		Response(string aString) {
			this(aString, 200);
		}
		
		Response(string aString, integer aStatus) {
			text = aString;
			status = aStatus;
		}
		
		string text;
		integer status;
	}
	
	public void add(string aString)
	{
		responseList.add(new Response(aString));
	}
	
	public void add(string aString, integer aStatus)
	{
		responseList.add(new Response(aString, aStatus));
	}
	
    public GISAPIMock(string aString)
	{
		add(aString);
	}
	
	public GISAPIMock(string aString, integer aStatus)
	{
		add(aString, aStatus);
	}
	
	public GISAPIMock(list<string> aStringList)
	{
		for (string each : aStringList)
			add(each);
	}

	// Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    	HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if (responseList.isEmpty()) {
        	res.setStatusCode(404);
        }
        else {
        	Response aResponse = responseList.remove(0);
	        res.setBody(aResponse.text);
	        res.setStatusCode(aResponse.status);
        }
        return res;
    }
    
    list<Response> responseList = new list<Response>();
}