@isTest
public class GetReceiverTest {
    public GetReceiverTest() {

    }

    @isTest
    static void testGetReceiverName() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Contact contact = new Contact();
        contact.FirstName = 'Test First Name';
        contact.LastName = 'Test Last Name';
        contact.AccountId = account.Id;
        insert contact;
        
        OpportunityContactRole oppContactRole = new OpportunityContactRole();
        oppContactRole.ContactId = contact.Id;
        oppContactRole.OpportunityId = opportunity.Id;
        insert oppContactRole;

        Contact contactSoql = [
            SELECT Name
            FROM Contact
            WHERE Id=:contact.Id
        ];

        String receiverName = GetReceiver.getReceiverName(opportunity.Id);

        System.assertEquals(contactSoql.Name, receiverName);
    }

    @isTest
    static void testGetReceiverEmail() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Contact contact = new Contact();
        contact.FirstName = 'Test First Name';
        contact.LastName = 'Test Last Name';
        contact.Email = 'test@email.com';
        contact.AccountId = account.Id;
        insert contact;
        
        OpportunityContactRole oppContactRole = new OpportunityContactRole();
        oppContactRole.ContactId = contact.Id;
        oppContactRole.OpportunityId = opportunity.Id;
        insert oppContactRole;

        String receiverEmail = GetReceiver.getReceiverEmail(opportunity.Id);

        System.assertEquals(contact.Email, receiverEmail);
    }


}