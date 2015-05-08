global virtual class XedeRemoteResponse {
	public void addMessage(string aMessage)
	{
		message.add(aMessage);
	}
	
	public void addMessage(list<string> aMessageList)
	{
		message.addAll(aMessageList);
	}
	
	public XedeRemoteResponse error(string aMessage)
	{
		return error(new string[] { aMessage });
	}
	
	public XedeRemoteResponse error(list<string> aMessageList)
	{
		successful = 'false';
		
		addMessage(aMessageList);
		return this;
	}

	public String get (String key) {
		return responseMap.get(key);
	}
	
	public void loadDebugLog() { 
		XedeLog.Write('XedeRemoteResponse.loadDebugLog()');
		XedeLog.WriteLimits();        
		debugLog = XedeLog.GetLog();
	}
	
	public XedeRemoteResponse ok(string aMessage)
	{
		return ok(new string[] { aMessage });
	}
	
	public XedeRemoteResponse ok(list<string> aMessageList)
	{
		successful = 'true';

		addMessage(aMessageList);
		return this;
	}
	
	public void put(String key, String value) {
		responseMap.put(key, value);
	}
	
	public void setJMap(string aString) {
		jmap = (map<string, object>) JSON.DeserializeUntyped(aString);
	}
		
	public void setMessage(string aString) {
		// use judiciously.  It will overwrite the message already saved to the
		// api log.
		
		message = new string[] { aString };
	}
	
	public void setStartTime(long aTimeStamp) { startTime = aTimestamp; }
	
	public void setXapi(string aString) {
		xapi = aString;
	}
	
	public void setXapiMap(string aString) {
		if (String.IsBlank(aString))
			xapiMap = null;
		else
			xapiMap = (map<string, object>) JSON.DeserializeUntyped(aString);
	}
	
	public XedeRemoteResponse(boolean aBoolean, string aMessage)
	{
		this(aBoolean, new string[] { aMessage });
	}

	public XedeRemoteResponse(boolean aBoolean, string[] aStringArray)
	{
		if (aBoolean == true)
			ok(aStringArray);
		else
			error(aStringArray);
	}
	
	public XedeRemoteResponse() { }
	
	public list<string> debugLog { get; private set; }
	public map<string, object> jmap { get; private set; }
	public boolean isSuccessful { public get { return successful == 'true'; }}
	public list<string> message { get; private set; } { message = new list<string>(); }
	transient Map<String, String> responseMap = new Map<String, String>();
	long startTime;	
	public string successful { get; set; }	
	public map<string, object> xapiMap { get; private set; }
	public string xapi;
}