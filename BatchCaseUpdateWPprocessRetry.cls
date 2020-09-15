/*
 * Name BatchCaseUpdateWPprocessRetry
 * @author Vijay
 * @description Batch class to query failed case record updates from WP system
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *   v1.0      vijayraghava.k@gmail.com         12/09/2020           Initial Baseline
 *
 */
public with sharing class BatchCaseUpdateWPprocessRetry implements Database.Batchable<SObject>, Database.AllowsCallouts {

    /*
    * Name start
    * Start of batchable context
    *                         
    * Query for closed case records hourly and that have not yet been updated with a secret key. 
    *
    * @param Database.BatchableContext BC  Description, Batch context
    * @return Database.QueryLocator Description, query locator for execution
    */
    public Global_Variables__c gv = Global_Variables__c.getOrgDefaults();
    public integer QUERYlimit = integer.valueOf(gv.Batch_Case_Update_Query_LIMIT__c);
    public integer iteration;
    public Database.QueryLocator start(Database.BatchableContext BC) { 
	    system.debug('START BatchCaseUpdateWPprocessRetry START');
		return Database.getQueryLocator('SELECT Id,secret_Key__c,CaseNumber FROM Case WHERE (status=\'Closed\' AND secret_Key__c = null AND IsProcessed__c = false)'); 
    }

    /*
    * Name execute
    * Execution of batchable context
    *                         
    * Callouts made from this batch for failed case records on an hourly schedule. Easily configurable for cutom scheduling.
    * This helps in retrying failures hourly, in case the WP end point is experience service issues or timeouts.
	*
    * @param Database.BatchableContext info  Description, Batch context
    * @param List<Case> caseList  Description, List of Cases
    * @return null
    */
    public void execute(Database.BatchableContext info, List<Case> caseList) {

        List<String> caseIdList = new List<String>();
        
        system.debug('case list size for retry: '+caseList.size());
        system.debug(caseList);

		for(CASE caseRec : caseList){ //get the case ids in a list
					caseIdList.add(caseRec.Id);
			}
		system.debug('enqueing Job: as case numbers to process are '+caseIdList);

        if(caseList.size()>0){
            WpAPIController.sendCaseUpdate(caseIdList);
        }

        system.debug('END BatchCaseUpdateWPprocessRetry END');
    }

    public void finish(Database.BatchableContext info) { }
}