@isTest
public class CreateApexBatchSchedulerTest {
    public CreateApexBatchSchedulerTest() {

    }

    @isTest
    static void testCreateApexBatchable() {
        Test.startTest();
        CreateApexBatchScheduler.createApexBatchable('ContactBirthdayBatch');
        Test.stopTest();
    }

    @isTest
    static void testCreateApexSchedulable() {
        Test.startTest();
        CreateApexBatchScheduler.createApexSchedulable('ContactBirthdayScheduler', '0 0 0 * * ?');
        Test.stopTest();
    }

    @isTest
    static void testAbortApexSchedulable() {
        Test.startTest();
        String jobId = CreateApexBatchScheduler.createApexSchedulable('ContactBirthdayScheduler', '0 0 0 * * ?');
        CreateApexBatchScheduler.abortApexSchedulable(jobId);
        Test.stopTest();
    }
}