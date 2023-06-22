public with sharing class EmailTemplateController {
  @AuraEnabled(cacheable=true)
  public static List<EmailTemplate> getEmailTemplates() {
      return [
        SELECT Body, Subject 
        FROM EmailTemplate
        WHERE Name='SendInvoiceTemplate'
      ];
  }
}