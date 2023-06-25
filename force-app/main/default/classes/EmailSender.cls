public with sharing class EmailSender {
     @AuraEnabled
    public static void sendEmail(String toAddress, String replyToAddress, String subject, String body, String invoiceNum, String contentDocumentId){
      Messaging.reserveSingleEmailCapacity(2);

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new List<String>{toAddress});
      mail.setReplyTo(replyToAddress);
      // mail.setCCAddresses(new List<String>{ccAddress});
      mail.setSubject(subject);
      mail.setHtmlBody(body);
      
      Messaging.EmailFileAttachment pdfAttachment = new Messaging.EmailFileAttachment();

      pdfAttachment.setFileName(invoiceNum + '.pdf');

      Blob pdfContent = [
        SELECT VersionData
        FROM ContentVersion 
        WHERE ContentDocumentId=:contentDocumentId
        AND IsLatest=true
        LIMIT 1][0].VersionData;

      pdfAttachment.setBody(pdfContent);

      mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{pdfAttachment});
      
      // mail.setPlainTextBody(body);
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}