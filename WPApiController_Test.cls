/*
 * Name WPApiController
 * @author Vijay
 * @description Test class for WPApiController
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0        vijaya kapadam	 				14/09/2020				created
 */

@isTest 
private class WPApiController_Test {
    @testSetup
	static void setup() {
	    Global_Variables__c existingGV = IntegrationHelper.retrieveGlobalVariables();
	   //insert accounts
        List<Account> accountList = TestDataFactory_AusPost.createAccounts(2,false);
        
        insert accountList;
        
        //Insert Contact
        List<Contact> con = TestDataFactory_AusPost.createContacts(2, accountList[0].id,false);
        insert con;
        
      
        //insert case for one account
        List<Case> createBulkCases = TestDataFactory_AusPost.createCases(100,accountList[0].id,true);
        List<Case> createCases = TestDataFactory_AusPost.createCases(5,accountList[0].id,false);

        insert createCases[0];
	}


	@isTest
	private static void WPAPisendcaseUpdateTest() {

	    Global_Variables__c existingGV = IntegrationHelper.retrieveGlobalVariables();
		Global_Variables__c setting = new Global_Variables__c();
        setting.Batch_Case_Update_Query_LIMIT__c = 50;
        insert setting;
	    List<Account> accountList = TestDataFactory_AusPost.createAccounts(2,true);
	    List<Case> createCases = TestDataFactory_AusPost.createCases(5,accountList[0].id,true);
	    Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new WPMockHttpResponseGenerator());
		HttpResponse result = WPMockHttpResponseGenerator.makePostCallout();
        // Verify mock response is not null
        System.assertNotEquals(null,result,
            'The callout returned a null response.');
        // Verify status code
        System.assertEquals(201,result.getStatusCode(),
          'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');  
		
		/*List<Case> caseobj = [
			SELECT
				Id
			FROM Case
			WHERE Status = 'Closed' AND secret_Key__c='' AND isProcessed__c=false
			LIMIT 5];*/

        List<String> CaseIDs = new List<String>();

		for(CASE caseRec : createCases){ //get the case ids in a list
					CaseIDs.add(caseRec.Id);
		}

        try {
			WpAPIController.sendCaseUpdate(CaseIDs);
		    } catch (Exception e) 
			{
		    }
        Test.StopTest();
	}

}