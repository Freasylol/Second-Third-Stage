@isTest
public class ContactBirthdayBatchTest {
    public ContactBirthdayBatchTest() {

    }

    @isTest
    static void testBatch() {
        ContactBirthdayBatch contactBirthdayBatch = new ContactBirthdayBatch();

        Contact testContact = new Contact();
        testContact.BirthDate = System.today();
        testContact.FirstName = 'Test Name';
        testContact.LastName = 'Test LastName';

        insert testContact;

        Test.startTest();
        Id batchJobId = Database.executeBatch(contactBirthdayBatch);
        Test.stopTest();
    }

    
}