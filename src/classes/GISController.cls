global with sharing class GISController extends XedeController {
	
	@RemoteAction
	global static XedeRemoteResponse Address(String anAddress, string srid) {
        RestRequest aRequest = new RestRequest();
        aRequest.addParameter('action', 'address');
        aRequest.addParameter('street', anAddress);
        aRequest.addParameter('srid', srid);   

		return apiResponseFor(aRequest);
	}
	
	@RemoteAction
	global static XedeRemoteResponse AddressCandidates(String anAddress) {
        RestRequest aRequest = new RestRequest();
        aRequest.addParameter('action', 'candidates');
        aRequest.addParameter('street', anAddress);

		return apiResponseFor(aRequest);
	}
	
	private static XedeRemoteResponse ApiResponseFor(RestRequest aRequest) {
        RestResponse aResponse = new RestResponse();
        GISAPI api = new GISAPI();
        return api.handleRequest(aRequest, aResponse);
	}
	
	//
	// Anonymously execute "GISController.CaseTopicCreate();"
	public static void CaseTopicCreate()
	{
		list<PushTopic> topicList = [ select id from PushTopic where name = 'CaseTopic' ];
		delete topicList;
		
		PushTopic aTopic = new PushTopic();
		aTopic.ApiVersion = 29.0;
		aTopic.Name = 'CaseTopic'; 
		aTopic.Description = 'All records for the Case object';
		aTopic.Query = 'SELECT Id, Case_Record_Type__c, Department__c, CaseNumber, Centerline_2272x__c, Centerline_2272y__c, subject, createdDateString__c, status, street__c FROM Case where Centerline_2272x__c != null and Centerline_2272x__c != 0';
		aTopic.NotifyForOperationCreate = true;
		aTopic.NotifyForOperationUpdate = true;
		aTopic.NotifyForOperationUndelete = true;
		aTopic.NotifyForOperationDelete = true;
		aTopic.NotifyForFields = 'Referenced';
		insert aTopic;
		system.debug(aTopic);
	}
	
	@RemoteAction global static list<Case> GetRecentCases(integer rowLimit, string anId)    
    {
        list<Case> aList = new list<Case>();

		try {
            aList = [
                select  id,
                		recordtype.name,
                        caseNumber,
                        Case_Record_Type__c,
                        Department__c,
                        street__c,
                        subject,
                        status,
                        createdDate,
                        createdBy.name,
                        description,
                        Centerline_2272x__c,
                        Centerline_2272y__c,
                        CreatedDateString__c,
                        ClosedDateString__c
                  from  Case
                 where  id != :anId
                   and  Centerline_2272x__c != null and Centerline_2272x__c != 0
                   and  Centerline_2272y__c != null and Centerline_2272y__c != 0
                  order by CreatedDate DESC
                  limit :rowLimit
            ];              
        } catch (system.Dmlexception e) {
            system.debug(e.getMessage());
        }

        return aList;
    }

    public GISController(ApexPages.StandardController controller) {}
    public GISController(XedeObject controller) {}
    public GISController() {}
    
    @RemoteAction
    global static XedeRemoteResponse HttpGet(string aUrl) {
        RestRequest aRequest = new RestRequest();
        aRequest.addParameter('action', 'httpGet');
        aRequest.addParameter('url', aUrl);

		return apiResponseFor(aRequest);
	}
    
    @RemoteAction
	global static XedeRemote.Response Query(string aSoqlQuery)
	{
		return XedeRemote.Query(aSoqlQuery);
	}
	
	public PageReference geodataReportList() {
		PageReference geoRedirect = Page.XedeReportTypes;
		geoRedirect.getparameters().put('typex', 'Cases with Geodata');
		
		return geoRedirect;
	}
}