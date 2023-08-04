@isTest
public class ContactBirthdaySchedulerTest {
    public ContactBirthdaySchedulerTest() {

    }

    @isTest
    static void testScheduler() {
        Contact testContact = new Contact();
        testContact.BirthDate = System.today();
        testContact.FirstName = 'Test Name';
        testContact.LastName = 'Test LastName';

        Test.startTest();
        String jobName = 'Test Schedule Contact Birthday';
        String cronExpr = '0 0 0 * * ?';
        ContactBirthdayScheduler contactBirthdayScheduler = new ContactBirthdayScheduler();
        String jobId = System.schedule(jobName, cronExpr, contactBirthdayScheduler);
        Test.stopTest();
    }
}