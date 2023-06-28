public with sharing class AttachPdfInvoice {
    @AuraEnabled(cacheable=false)
    public static void attachPDF(String opportunityId) {
        Blob b;
        if (Test.isRunningTest()) {
            System.debug('test');
            b = Blob.valueOf('test string');
        } else {
            b = generatePDF(opportunityId);
        }
        Opportunity opportunity = [SELECT Invoice_Number__c FROM Opportunity WHERE Id=:opportunityId];
        String invoiceName = opportunity.Invoice_Number__c;
        System.debug(invoiceName);
        List<ContentDocument> contentDocumentList = [SELECT Id, Title, PublishStatus
                                                   FROM ContentDocument
                                                   WHERE PublishStatus='P' AND
                                                   Title=:invoiceName];
        System.debug('Content document list size is ' + contentDocumentList.size());

        if (contentDocumentList.size() == 0) {
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S';
            cVersion.Title = invoiceName;
            cVersion.VersionData = b;
            cVersion.PathOnClient = invoiceName + '.pdf';
            cVersion.isMajorVersion = true;
            insert cVersion;

            id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:cVersion.Id].ContentDocumentId;
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;
            cDocLink.LinkedEntityId = opportunityId;
            cDocLink.Visibility = 'AllUsers';
            cDocLink.ShareType = 'V';
            insert cDocLink;
        } else {
            String contentDocumentId = contentDocumentList[0].Id;
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S';
            cVersion.Title = invoiceName;
            cVersion.ContentDocumentId = contentDocumentId;
            cVersion.VersionData = b;
            cVersion.PathOnClient = invoiceName + '.pdf';
            cVersion.isMajorVersion = true;
            insert cVersion;
        } 
    }

    @AuraEnabled(cacheable=true)
    public static Blob generatePDF(String opportunityId) {
        Pagereference pdf = Page.TestInvoice;
        pdf.getParameters().put('Id', opportunityId);
        pdf.setRedirect(true);
        Blob b;
        b = pdf.getContent();
        return b;
    }
}