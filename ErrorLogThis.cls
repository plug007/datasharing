/**================================================================      
* Name: ErrorLogThis
* @description: Logic to store exception message
* @date: [12/09/2020]
* @author: Vijay K
* 
* Date Modified      Modified By           Description of the update
* ==============================================================*/
global class ErrorLogThis{

public static void saveLog(
		String httpmethod,
		String endpoint,
		Integer httpStatusCode,
		String httpheaders,
		String httprequestBody,
		String httpresponseBody
		
	){
		Error_Log__c l = new Error_Log__c();

		l.HttpHeaders__c = httpheaders;
		l.HttpStatusCode__c=httpStatusCode;
		l.HttpRequestBody__c = httprequestBody;
		l.HttpResponseBody__c = httpresponseBody;
		l.HttpMethod__c = httpmethod;
		l.Endpoint__c = endpoint;
		
		insert l;
	}

}