/*
 * Name ScheduleCaseUpdateWpProcessRetry_Test
 * @author Vijay
 * @description Test class for ScheduleCaseUpdateWpProcessRetry
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0        vijaya kapadam	 				14/09/2020				created
 */
@isTest 
private class ScheduleCaseUpdateWpProcessRetry_Test {

	@isTest
	static void ScheduleCaseUpdateWPprocessRetryTest() {
	    
		Global_Variables__c existingGV = IntegrationHelper.retrieveGlobalVariables();
		Global_Variables__c setting = new Global_Variables__c();
        setting.Batch_Case_Update_Query_LIMIT__c = 50;
        insert setting;
	    List<Account> accountList = TestDataFactory_AusPost.createAccounts(2,true);
	    List<Case> createCases = TestDataFactory_AusPost.createCases(5,accountList[0].id,true);
        Test.StartTest();
		Test.setMock(HttpCalloutMock.class, new WPMockHttpResponseGenerator());
		try {
		    ScheduleCaseUpdateWPprocessRetry sh1 = new ScheduleCaseUpdateWPprocessRetry();
		    String sch = '0 0 * * * ?'; 
			String jobId   = System.schedule('Scheduled Job 1',sch, sh1);
			CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
            System.assertEquals(sch,ct.CronExpression); // added system asserts to check expected behaviour
		} catch (Exception e) {
			system.debug(e);
		}
        Test.StopTest();
    }

}