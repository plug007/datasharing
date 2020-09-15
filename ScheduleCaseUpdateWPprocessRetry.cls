/*
 * Name ScheduleCaseUpdateWPprocessRetry
 * @author Vijay
 * @description Schedulable class to call batchable class which queries for and reprocesses cases failed to update secret key.
 * Example Schedule Jobs every 15 min
 * System.schedule('Scheduled Job 1', '0 0 * * * ?', new ScheduleCaseUpdateWPprocessRetry());
 * System.schedule('Scheduled Job 2', '0 15 * * * ?', new ScheduleCaseUpdateWPprocessRetry());
 * System.schedule('Scheduled Job 3', '0 30 * * * ?', new ScheduleCaseUpdateWPprocessRetry());
 * System.schedule('Scheduled Job 4', '0 45 * * * ?', new ScheduleCaseUpdateWPprocessRetry());
 * @version 1.0
 *
 *  Version     Modified By                     Date Modification       Description of the update
 *   v1.0      vijayraghava.k@gmail.com		       12/09/2020           Initial Baseline
 *
 */

global class ScheduleCaseUpdateWPprocessRetry implements Schedulable {

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new BatchCaseUpdateWPprocessRetry(),50);
    }
}