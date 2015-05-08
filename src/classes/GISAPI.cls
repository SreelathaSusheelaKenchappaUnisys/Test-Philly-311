/*
Copyright 2013, Xede Consulting Group, Inc.
*/

@RestResource(urlMapping='/GISAPI/*')

global with sharing class GISAPI extends XedeObject {
	
	public string address(RestRequest request)
	{
		string street = request.params.get('street');
		string srid = request.params.get('srid');
		
		if (String.IsBlank(street))
			GISException.Raise('street may not be empty or missing');
			
		GIS aGis = new GIS();
		
		if (String.IsBlank(srid))
			return aGis.address(street);
		
		return aGis.address(street, (GIS.XyPair) null, srid);
	}
	
	public string addressCandidates(RestRequest request)
	{
		string street = request.params.get('street');
		string srid = request.params.get('srid');
		
		if (String.IsBlank(street))
			GISException.Raise('street may not be empty or missing');
			
		GIS aGis = new GIS();
		
		if (String.IsBlank(srid))
			return aGis.addressCandidates(street);
		
		return aGis.address(street, (GIS.XyPair) null, srid);
	}
	
	@HttpGet
    global static void doGet() {
		GISAPI anAPI = new GISAPI();		
        anAPI.handleRequest(RestContext.request, RestContext.response);		
    }
  
	@HttpPost
    global static void doPost() {                    
        GISAPI anAPI = new GISAPI();
        anAPI.handleRequest(RestContext.request, RestContext.response);        
    }

	public GISAPI() {} // is public for unit testing purposes
	
	public XedeRemoteResponse handleRequest(RestRequest request, RestResponse response)
	{
		XedeRemoteResponse apiResponse = new XedeRemoteResponse(true, 'OK');
		
		string xapiString = request.params.remove('xapi');
		system.debug('xapi=' + xapiString);
		
		system.debug(XedeLog.Write('GISAPI.handleRequest({0})', request.params));
		
		string action = request.params.get('action');
		
		try {
			if (action == null)
				GISException.Raise('Missing action parameter');
			
			action = action.tolowercase();
			
			if (action.equals('address'))
				apiResponse.setJmap(address(request));
				
			else if (action.equals('candidates'))
				apiResponse.setJmap(addressCandidates(request));

			else if (action.equals('httpget'))
				apiResponse.setJmap(httpGet(request));
			
			else if (action.equals('xyzzy'))
				apiResponse.setMessage(xyzzy());
			
			else {
				GISException.Raise('Action not found : ' + action);
			}
			
			response.statusCode = 200;
		}
		
		catch (GISException ex)
		{			
			response.statusCode = 400;
			apiResponse = new XedeRemoteResponse(false, ex.getMessage());
		}
		
		catch (Exception ex)
		{
			response.statusCode = 500;
			apiResponse = new XedeRemoteResponse(false, ex.getMessage());
			apiResponse.error(ex.getStackTraceString());
		}
		
		try {
			apiResponse.loadDebugLog();
			apiResponse.setXapi(xapiString);
		}	
		catch (Exception ex) {
			apiResponse.addMessage('Error loading xapi or debug log');
			apiResponse.addMessage(ex.getMessage());
		}
				
		response.responseBody = Blob.ValueOf(Json.Serialize(apiResponse));

		return apiResponse;
	}
	
	public string HttpGet(RestRequest request)	
	{
		string aUrl = request.params.get('url');
		
		if (String.IsBlank(aUrl))
			GISException.Raise('url may not be empty or missing');
			
		XedeLog.Write('GIS.HttpGet({0})', aUrl);
		
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		
		aUrl = aUrl.replace(' ', '%20');
		
		req.setEndpoint(aUrl);
		req.setTimeout(30000);
		
		Http http = new Http();
		HttpResponse res = http.send(req);

		system.debug(res);
		system.debug(String.ValueOf(res.getBody()));
				
		XedeLog.Write('status = {0}, {1}', res.getStatusCode(), res.getStatus());
		
		if (res.getStatusCode() != 200)
			XedeException.Raise(res.getStatus());
		
		system.debug(XedeLog.GetLogString());
		
		return String.ValueOf(res.getBody());
	}
	
	public string xyzzy() { return 'Nothing happens.\n'; }
}