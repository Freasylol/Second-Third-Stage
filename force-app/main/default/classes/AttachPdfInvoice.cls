public with sharing class AttachPdfInvoice {
  @AuraEnabled(cacheable=false)
  public static void attachPDF(String opportunityId) {
      Pagereference pdf = Page.TestInvoice;
      pdf.getParameters().put('Id', opportunityId);
      pdf.setRedirect(true);
      Blob b;
      b = pdf.getContent();
      Opportunity opportunity = [SELECT Invoice_Number__c FROM Opportunity WHERE Id=:opportunityId];
      String invoiceName = opportunity.Invoice_Number__c;

      ContentVersion cVersion = new ContentVersion();
      cVersion.ContentLocation = 'S';
      // cVersion.VersionData = b;
      List<ContentDocument> contentDocumentList = [SELECT Id, Title, PublishStatus
                                                   FROM ContentDocument
                                                   WHERE PublishStatus='P'];
      System.debug('ContentDocument is ' + contentDocumentList[0]);
      String contentDocumentId = contentDocumentList[0].Id;
      if (contentDocumentList.size() == 0) {
        cVersion.Title = invoiceName;
        cVersion.VersionData = b;
        cVersion.PathOnClient = invoiceName + '.pdf';
        cVersion.isMajorVersion = true;
        insert cVersion;
      } else {
        cVersion.Title = invoiceName;
        cVersion.ContentDocumentId = contentDocumentId;
        cVersion.VersionData = b;
        cVersion.PathOnClient = invoiceName + '.pdf';
        cVersion.isMajorVersion = true;
        insert cVersion;
      }

      id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:cVersion.Id].ContentDocumentId;
      ContentDocumentLink cDocLink = new ContentDocumentLink();
      cDocLink.ContentDocumentId = conDocument;
      cDocLink.LinkedEntityId = opportunityId;
      cDocLink.Visibility = 'AllUsers';
      cDocLink.ShareType = 'V';
      insert cDocLink;
  }


}