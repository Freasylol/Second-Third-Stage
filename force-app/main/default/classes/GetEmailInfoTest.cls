@isTest
public class GetEmailInfoTest {
    public GetEmailInfoTest() {

    }

    @isTest
    static void testGetEmailInfo() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity Name';
        opportunity.AccountId = account.Id;
        opportunity.StageName = 'Closed Won';
        opportunity.CloseDate = Date.today();
        opportunity.Amount = 10;
        insert opportunity;

        Opportunity oppSoql = [
            SELECT Invoice_Number__c
            FROM Opportunity
            WHERE Id=:opportunity.Id
        ];

        String result = GetEmailInfo.getEmailInfo(opportunity.Id);

        System.assertEquals(oppSoql.Invoice_Number__c, result);
    }
}