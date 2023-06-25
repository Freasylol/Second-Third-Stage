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
      // SavePoint sp = Database.setSavePoint();
      // insert opportunity;
      // Opportunity getOpp = [SELECT Invoice_Number__c FROM Opportunity WHERE Id=:opportunity.Id];
      // System.debug(getOpp.Invoice_Number__c);
      // Database.rollback(sp);
      Opportunity testOpp = [SELECT Id, Invoice_Number__c FROM Opportunity WHERE Name='Test opportunity' LIMIT 1];
      // System.debug(testOpp.Invoice_Number__c.getAutoNumber());
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
      // contentVersion.ContentDocumentId = '069Dn000003hFSpIAM';
      insert contentVersion;

      ContentDocument contentDocument = new ContentDocument();
      // contentDocument = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId=:contentVersion.Id];
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