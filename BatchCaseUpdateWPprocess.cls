/*
 * Name BatchCaseUpdateWPprocess
 * @author Vijay
 * @description Batch class to query & process failed case updates
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0        vijayraghava.k@gmail.com	       12/09/2020           Initial release
 *
 */
global class BatchCaseUpdateWPprocess implements Database.Batchable<SObject>,Database.AllowsCallouts {
	
	public Global_Variables__c gv = Global_Variables__c.getOrgDefaults();
	public integer QUERYlimit = integer.valueOf(gv.Batch_Case_Update_Query_LIMIT__c);
	public integer iteration;
	global BatchCaseUpdateWPprocess() {
		
	}
	
	/**
	 * @description gets invoked when the batch job starts. Query for closed case records and have not yet been updated with a secretKey from WP   
	 * @param context contains the job ID
	 * @returns the record set as a QueryLocator object that will be batched for execution
	 */ 
	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator('SELECT Id,secret_Key__c,CaseNumber FROM Case WHERE (status=\'Closed\' AND secret_Key__c = null AND IsProcessed__c = false) LIMIT '+QUERYlimit);
	}

	/**
	 * @description gets invoked when the batch job executes and operates on one batch of records. Contains or calls the main execution logic for the batch job.
	 * @param context contains the job ID
	 * @param scope contains the batch of records to process.
	 */ 
   	global void execute(Database.BatchableContext context, List<Case> caseList) {
	
			
		system.debug('BatchCaseUpdateWPprocess EXECUTE size: '+caseList.size());
        system.debug(caseList);

		if(caseList.size()>0){
		    system.debug('enqueing Job: as case numbers to process are '+caseList.size());
			List<String> caseIdList = new List<String>();
			for(CASE caseRec : caseList){ //get the case ids in a list
					caseIdList.add(caseRec.Id);
			}
			system.debug('enqueing Job: as case numbers to process are '+caseIdList);
			System.enqueueJob(new QueueableWP('Case', caseIdList));
		}
	}
	
	/**
	 * @description gets invoked when the batch job finishes. Place any clean up code in this method.
	 * @param context contains the job ID
	 */ 
	global void finish(Database.BatchableContext context) {
		
	}
}

