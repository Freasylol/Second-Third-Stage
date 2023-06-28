@isTest
public class EmailSenderTest {
    public EmailSenderTest() {

    }

    @isTest
    static  void testSendEmail() {
        Test.startTest();

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Contact contact = new Contact();
        contact.FirstName = 'Test Contact FirstName';
        contact.LastName = 'Test Contact LastName';
        contact.Email = 'lepeshkoroman42@gmail.com';
        insert contact;

        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = opportunity.Id;
        ocr.ContactId = contact.Id;
        ocr.Role = 'Decision Maker';
        insert ocr;

        Opportunity oppSoql = [
            SELECT Name, StageName, CloseDate, Invoice_Number__c
            FROM Opportunity
            WHERE Id=:opportunity.Id
        ];

        String replyToAddress = 'romalepeshko42@25adcwrcw23mhcv73u73f3ytceai98rgn0rav6it53c9nik7jf.dn-9taimmaw.na224.apex.salesforce.com';

        String subject = oppSoql.Invoice_Number__c + 'Test Subject';

        String body = 'Test email body';

        String invoiceNum = oppSoql.Invoice_Number__c;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = oppSoql.Invoice_Number__c;
        contentVersion.PathOnClient = 'Myfile.txt';
        contentVersion.VersionData = Blob.valueOf('My content');
        contentVersion.isMajorVersion = true;
        insert contentVersion;

        ContentDocument contentDocument = new ContentDocument();
        ContentVersion testContentVersion  = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:contentVersion.Id];

        ContentDocumentLink doc = new ContentDocumentLink();
        doc.ContentDocumentId = testContentVersion.ContentDocumentId;
        doc.LinkedEntityId = opportunity.Id;
        doc.ShareType = 'V';
        doc.Visibility = 'AllUsers';
        insert doc;

        String contentDocumentId = doc.ContentDocumentId;

        String toAddress = contact.Email;

        EmailSender.sendEmail(toAddress, replyToAddress, subject,
                                body, invoiceNum, contentDocumentId);

        Test.stopTest();
    }
}