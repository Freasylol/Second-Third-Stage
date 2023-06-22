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
      cVersion.VersionData = b;
      List<ContentDocument> contentDocumentList = [SELECT Id, Title FROM ContentDocument];
      // for (ContentDocument el : contentDocumentList) {
      //   if (el.Title == invoiceName) {
          // cVersion.ContentDocumentId = el.Id;
          // cVersion.Title = el.Title;
   
      //     break;
      //   }
      // }
      // if (invoiceName != null) {
      //   cVersion.Title = invoiceName;
      //   cVersion.PathOnClient = invoiceName + '.pdf';
      //   insert cVersion;
      // } else {
      //   cVersion.Title = 'test';
      //   cVersion.PathOnClient = cVersion.Title + '.pdf';
      //   insert cVersion;
      // }

      // for (ContentVersion el : contentVersionList) {
      //   if (el.PathOnClient == invoiceName + '.pdf') {
      //     cVersion.ContentDocumentId = el.ContentDocumentId
      //     //  = cVersion.ContentDocumentId;
      //     el.VersionData = b;
      //     isCoincidence = true;
      //     insert el;
      //     break;
      //   } 
      // }

      // el.ContentDocumentId = cVersion.ContentDocumentId;
      // el.VersionData = b;
      // isCoincidence = true;
      // insert el;
      
      // if (isCoincidence == false) {
      // cVersion.Title = invoiceName;
      // cVersion.PathOnClient = invoiceName + '.pdf';
      // insert cVersion;
      // }

      cVersion.Title = invoiceName;
      cVersion.VersionData = b;
      cVersion.PathOnClient = invoiceName + '.pdf';
      insert cVersion;

      id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:cVersion.Id].ContentDocumentId;
      ContentDocumentLink cDocLink = new ContentDocumentLink();
      cDocLink.ContentDocumentId = conDocument;
      cDocLink.LinkedEntityId = opportunityId;
      cDocLink.Visibility = 'AllUsers';
      cDocLink.ShareType = 'V';
      insert cDocLink;
  }
}