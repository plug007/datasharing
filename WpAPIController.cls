
 /*
 * Name WpAPIController
 * @author Vijay
 * @description Handles WP API interactions with Salesforce, may contain various wrapper classes
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0	    vijayraghava.k@gmail.com	       12/09/2020           Initial Baseline
 *
 */
global class WpAPIController {
	/**
	* @name fromSobject
	* @description This method transforms a Salesforce Case Record to an external Case record representation on WP
	* @return External Object
	*
	public static WPCaseRecordResource fromSObject(Case record) {
		WPCaseRecordResource ExternalCaseRec = new WPCaseRecordResource();
		ExternalCaseRec.id           = record.id;
		ExternalCaseRec.agentid      = record.OwnerId;

		return ExternalCaseRec;
	}*/


	/*
	* Name sendCaseUpdate
	* Process closed case records, make callout request to WP endpoint, update secret key returned.
	* Process failed callouts by chainnig queue requests                        
	* LIMITATION -- It looks like WP endpoint can only accept a single Case Record with case id and agent id
	*
	* @param List<Case> recordIds  Description, case record ids
	* @return set to always return null 
	*/
	public static void sendCaseUpdate(List<String> recordIds) {
		    System.debug('WpApiController sendCase recordIds' +recordIds);		

			List<Case> caseList = new List<Case>();
			List<Case> retrycaseList = new List<Case>();
			Map<String, Case> case_Map = new Map<String, Case>();
			Map<Id, Case> caseUpdate_Map = new Map<Id, Case>();
			dateTime nowPlus5Min = Datetime.now().addMinutes(5);
			Global_Variables__c gv = Global_Variables__c.getOrgDefaults();
			integer QUERYlimit = integer.valueOf(gv.Batch_Case_Update_Query_LIMIT__c);
			string ErrorMessages = '';

			caseList = [SELECT 	Id,	secret_Key__c, OwnerId
							FROM Case
							WHERE Id=:recordIds
							LIMIT :QUERYlimit
							];
            System.debug('WpApiController Cases from Query' +caseList.size()+' and QUERYlimit '+QUERYlimit);
			for(Case caseRec : caseList){
				if(string.isBlank(caseRec.secret_Key__c)){
					case_Map.put('', caseRec);
				}
			}	
			
			system.debug('WpApiController Cases to Update size : '+ case_Map.Size());

			for(Case caseRec1 : caseList){
				try {
				system.debug('WpApiController Cases Id :'+caseRec1.id);
				String urlEncodedString = 'id='+EncodingUtil.urlEncode(caseRec1.Id,'UTF-8')+'&agentid='+EncodingUtil.urlEncode(caseRec1.OwnerId,'UTF-8');
				HTTPResponse response = IntegrationHelper.makeRequest(urlEncodedString,'NOT YET NEEDED','POST');
				String errorbody =response.toString();
				system.debug('SEND CASE TO WP RESPONSE START');
				if (response.getStatusCode() == 201 || response.getStatusCode() == 200) {
					JSONParser parser =JSON.createParser(response.getBody());
					parser.nextToken();
					parser.nextValue();
					parser.nextToken();
					parser.nextValue();
					caseRec1.secret_Key__c=parser.getText();
					caseRec1.isProcessed__c=true;
	                caseUpdate_Map.put(caseRec1.Id, caseRec1);
					System.debug('Secretkey from WP: '+parser.getText());
					System.debug('Response: '+response.getBody());
					System.debug('Case update API req SUCCESSFUL: '+errorbody);
							
				}
				else {
					System.debug('HTTP Response : '+response.getBody());
					System.debug('The status code returned was not expected: '+errorbody);
					retrycaseList.add(caseRec1);
				}
				} catch(System.calloutException ex) {
					System.debug(ex.getMessage());
					retrycaseList.add(caseRec1);

					// if (ex.getmessage().containsIgnoreCase('read timed out')) 
					// Do something for batch retry
				}

			}

			if (caseUpdate_Map.size() > 0) {
				system.debug('WpApiController Cases to update in SF size ' + caseUpdate_Map.size());
				List<Case> updateCases = caseUpdate_Map.values();
				update updateCases;
			}

			//Try to see if there are any case updates that failed to get secret key and queue a job with those Ids
						
			gv = Global_Variables__c.getOrgDefaults();
			if(!gv.Batch_Case_Process_Stopped__c && retrycaseList.size() >0){
				system.debug('Cases to Process after finishing batch >0');
				retrycaseList = [SELECT Id,	secret_Key__c, OwnerId
							FROM Case
							WHERE Id=:retrycaseList
							LIMIT :QUERYlimit
							];
				
				try{
					String jobId = '';
					if(!Test.isRunningTest() && retrycaseList.size()>0){
					    List<String> retrycaseIdList = new List<String>();
			            for(SObject caseRecRetry : retrycaseList){ //get the case ids in a list
					        retrycaseIdList.add(caseRecRetry.Id);
			            }
						jobId = System.enqueueJob(new QueueableWP('Case',retrycaseIdList));
					}
					if(string.isBlank(jobId)){
						nullTimeStampStopProcess('WPApiController - Falied - No jobId for Case queue');
					}else{
						gv.Batch_Case_Process_Timestamp__c = DateTime.now();
						update gv;
					}
				}catch (Exception e) {
					nullTimeStampStopProcess('WPApiController - Catch Exception :'+e);
				}
			
			//We can futher use schedulable batch classes to run hourly or daily using CRON expressions
	

	}
	

}

		/*
		* Name nullTimeStampStopProcess
		* Update custom setting process timestamp to null.
		*/
		public static void nullTimeStampStopProcess(string message){
	
			system.debug(message);
			Global_Variables__c gv = Global_Variables__c.getOrgDefaults();
			gv.Batch_Case_Process_Timestamp__c = null;
			update gv;
		}
}

