/*
 * Name QueueableWP
 * @author Vijay
 * @description Queable class to call Workforce Planning API and extensible for future changes
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *  v1.0        vijaya kapadam	 				12/09/2020				created
 */

public class QueueableWP implements Queueable, Database.AllowsCallouts {
    public String Id;
    public String objectName;
    public Integer count;
    public List<String> ids;
	public List<sObject> objLst;

   
    public QueueableWP(String recordId, String sObjectName) {
        Id = recordId;
        objectName = sObjectName;
    }
    public QueueableWP(String sObjectName, List<String> recordIds) {
        objectName = sObjectName;
        Ids = recordIds;
    }

    public QueueableWP(String sObjectName){
        objectName = sObjectName;
    }
    public void execute(QueueableContext context) {

		if (objectName.equals('Case')) {
            WpAPIController.sendCaseUpdate(ids);
        } 
    }
}