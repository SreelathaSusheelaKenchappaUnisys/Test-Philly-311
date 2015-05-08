@isTest(SeeAllData = true)
public class GetDiscoveryTest {

    public static String baseUrl = 'https://citywide-philadelphia.cs10.force.com/apps/services/apexrest/v2/discovery/';	
    
    static  testmethod void method()	{
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       RestContext.request = req;
       RestContext.response = res;
        
       req.requestURI = baseUrl + 'xml';
       req.httpMethod = 'GET';
       GetDiscovery.doGet();
        
       req.requestURI = baseUrl + 'json';
       req.httpMethod = 'GET';
       GetDiscovery.doGet();
        
       req.requestURI = baseUrl + 'xml';
       req.httpMethod = 'POST';
       GetDiscovery.doGet();
        
       req.requestURI = baseUrl + 'json';
       req.httpMethod = 'POST';
       GetDiscovery.doGet(); 
    }
}