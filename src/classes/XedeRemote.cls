global without sharing class XedeRemote extends XedeController {
	
	global class Response {
		void addMessage(string aString) {
			message.add(aString);
		}
		
		Response() {
			message = new list<string>();
			debugLog = new list<string>();
		}
		
		public integer size() { return queryData.size(); }
		
		public list<sobject> queryData { get; set; } { queryData = new list<sobject>(); }
		public list<string> message { get; private set; }
		public list<string> debugLog {get; private set; }
	}
	
	public XedeRemote() { super(); }
	public XedeRemote(object anObject) { super(); }
	
	@RemoteAction
	global static Response Query(string aString) {
		
		Response aResponse = new Response();
		
		string dateString = DateTime.Now().formatGMT('yyyy-MM-dd');
		string timeString = DateTime.Now().formatGMT('HH:mm:ss');
		string nowString = dateString + 'T' + timeString + 'Z';
		
		XedeLog.Write('XedeRemote.Query({0}) at {1}', aString, nowString);
						
		aString = aString.replaceAll('today\\(\\)', dateString);		
		aString = aString.replaceAll('now\\(\\)', nowString);
		
		XedeLog.Write('XedeRemote.Query({0}) after subs', aString);
		
		try {
			aResponse.queryData = Database.Query(aString);
		}
		catch (Exception ex) {
			aResponse.addMessage(ex.getMessage());
		}
		
		aResponse.debugLog = XedeLog.GetLog();
		
		return aResponse;
	}
}