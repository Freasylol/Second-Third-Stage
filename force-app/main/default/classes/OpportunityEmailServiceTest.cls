@isTest
public class OpportunityEmailServiceTest {
    @isTest 
    static void testEmailService() {
        Test.startTest();
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Name';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Opportunity oppAppoveSoql = [
            SELECT Invoice_Number__c, StageName
            FROM Opportunity
            WHERE Id=:opportunity.Id
        ];
        System.debug(oppAppoveSoql);
        System.debug(opportunity);
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        email.subject = oppAppoveSoql.Invoice_Number__c + 'Opportunity Invoice';
        email.plainTextBody = 'Approved';
        String toAddresses = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';
        envelope.fromAddress = 'romalepeshko42@gmail.com';
        
        OpportunityEmailService oppMessService = new OpportunityEmailService();
        oppMessService.handleInboundEmail(email, envelope);

        oppAppoveSoql = [
            SELECT Invoice_Number__c, StageName
            FROM Opportunity
            WHERE Id=:opportunity.Id 
        ];

        System.debug(oppAppoveSoql);

        System.assertEquals('Qualification', oppAppoveSoql.StageName);

        email.plainTextBody = 'Rejected';
        
        oppMessService.handleInboundEmail(email, envelope);

        oppAppoveSoql = [
            SELECT Invoice_Number__c, StageName
            FROM Opportunity
            WHERE Id=:opportunity.Id
        ];

      System.assertEquals('Closed Lost', oppAppoveSoql.StageName);

      Test.stopTest();
    }
}