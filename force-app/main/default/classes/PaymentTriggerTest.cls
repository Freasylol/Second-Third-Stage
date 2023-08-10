@isTest
public class PaymentTriggerTest {
    @isTest
    static void testPaymentTriggerMethod() {
        User user = new User();
        user.FirstName = 'test invoice name';
        user.LastName = 'test invoice last name';
        user.Email = 'test@example.com';
        user.UserName = 'testinvoice@example.com';
        user.Alias = 'testUser';
        user.CommunityNickName = 'testuser';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.ProfileId = '00eDn0000013AECIA2';
        user.LanguageLocaleKey = 'en_US';
        insert user;

        Opportunity partOpp = new Opportunity();
        partOpp.Name = 'partOpp';
        partOpp.PaymentSum__c = 0;
        partOpp.Amount = 1000;
        partOpp.OwnerId = user.Id;
        partOpp.StageName = 'Prospecting';
        partOpp.CloseDate = Date.today();
        insert partOpp;

        Opportunity fullOpp = new Opportunity();
        fullOpp.Name = 'fullOpp';
        fullOpp.PaymentSum__c = 0;
        fullOpp.Amount = 1000;
        fullOpp.OwnerId = user.Id;
        fullOpp.StageName = 'Prospecting';
        fullOpp.CloseDate = Date.today();
        insert fullOpp;

        Payment__c partPayment = new Payment__c();
        partPayment.FirstName__c = 'partName';
        partPayment.LastName__c = 'partLastName';
        partPayment.Amount__c = 500;
        partPayment.OpportunityName__c = 'partOpp';
        insert partPayment;

        Payment__c fullPayment = new Payment__c();
        fullPayment.FirstName__c = 'fullName';
        fullPayment.LastName__c = 'fullLastName';
        fullPayment.Amount__c = 1000;
        fullPayment.OpportunityName__c = 'fullOpp';
        insert fullPayment;

        Opportunity updPartOpp = [
            SELECT Id, Name, StageName
            FROM Opportunity
            WHERE Id=:partOpp.Id
        ];

        Opportunity updFullOpp = [
            SELECT Id, Name, StageName
            FROM Opportunity
            WHERE Id=:fullOpp.Id
        ];

        System.AssertEquals('Partially Paid', updPartOpp.StageName);
        System.AssertEquals('Fully Paid', updFullOpp.StageName);
    }

}