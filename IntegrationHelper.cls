/*
 * Name IntegrationHelper
 * @author Vijay
 * @description Custom solution to correctly integrate with Workforce Planning API and extensible when endpoint requires AUTH/TOKEN REFRESH etc
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0        vijaya kapadam	 				12/09/2020				created
 */
public class IntegrationHelper {


	/*
	* Name BuildRequest
	* Builds the HTTP request                        
	*
	* @return HttpRequest
	*/
	public static HttpRequest BuildRequest(string endPointName, string methodName, string header, string body){
		HttpRequest request = new HttpRequest();
		//request.setEndpoint(endPointName);
		request.setEndpoint('Callout:Workforce_planning');
		request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		request.setMethod(methodName);
        system.debug('HTTP Request --> '+request);
		if(String.isNotBlank(body)){             
			request.setBody(body);
		}
		request.setTimeout(120000);
        system.debug('BuildRequest 1');
		return request;
	}

	/*
	* Name GetResponse
	* Returns the HTTP response after sending HTTP request to the endpoint                        
	*
	* @return HttpResponse
	*/

	public static HttpResponse GetResponse(HttpRequest request){

		Http http = new Http();
		HttpResponse response;
		response = http.send(request);
		system.debug('HTTP Response-->'+response.getBody());
		//ErrorLogThis.saveLog('POST','WorkForce Planning EP',response.getStatusCode(),request.getHeader('Content-Type'),JSON.serializePretty(request.getBody(),true),JSON.serializePretty(response.getBody(),true));
		return response;
	}

	/*
	* Name makeRequest
	* Returns the HTTP response after sending HTTP request to the endpoint                        
	*
	* @return HttpResponse
	*/

	 public static HttpResponse makeRequest(String requestObj, String endPoint,String methodName) {

		String jsonString = requestObj;
        System.debug(JSON.serializePretty(jsonString));
		HttpRequest req = BuildRequest(endPoint,methodName,null,jsonString);
		return GetResponse(req);
    }
	
	/*
	* Name retrieveGlobalVariables
	* Returns the global variable Org defaults from custom settings                        
	*
	* @return GV
	*/ 
	public static Global_Variables__c retrieveGlobalVariables(){

		return Global_Variables__c.getOrgDefaults();

	}
 
}

