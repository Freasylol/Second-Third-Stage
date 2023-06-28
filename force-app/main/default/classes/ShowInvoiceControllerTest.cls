@isTest
public class ShowInvoiceControllerTest {
    public ShowInvoiceControllerTest() {

    }

    @isTest static void testGetOpportunityInvoiceNum() {
        Test.startTest();
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;
        Opportunity testOpp = [SELECT Id, Invoice_Number__c FROM Opportunity WHERE Name='Test opportunity' LIMIT 1];
        System.debug('Invoice_Number__c is ' + testOpp.Invoice_Number__c);      
        String testInvoiceNum = ShowInvoiceController.getOpportunityInvoiceNum(testOpp.Id);
        System.assertEquals(testOpp.Invoice_Number__c, testInvoiceNum);
        Test.stopTest();
    }

    @isTest static void testGetContentDocumentId() {
        Test.startTest();
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today();
        insert opportunity;

        Opportunity newOpp = [SELECT Invoice_Number__c FROM Opportunity WHERE Id=:opportunity.Id];

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = newOpp.Invoice_Number__c;
        contentVersion.PathOnClient = 'Myfile.txt';
        contentVersion.VersionData = Blob.valueOf('My content');
        contentVersion.isMajorVersion = true;
        insert contentVersion;

        ContentDocument contentDocument = new ContentDocument();
        ContentVersion testContentVersion  = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:contentVersion.Id];

        System.debug(testContentVersion.Id);

        ContentDocumentLink doc = new ContentDocumentLink();
        doc.ContentDocumentId = testContentVersion.ContentDocumentId;
        doc.LinkedEntityId = opportunity.Id;
        doc.ShareType = 'V';
        doc.Visibility = 'AllUsers';
        insert doc;

        String docId = ShowInvoiceController.getContentDocumentId(contentVersion.Title);
        System.assertEquals(doc.ContentDocumentId, docId);
        Test.stopTest();
    }
}