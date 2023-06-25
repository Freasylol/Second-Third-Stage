public with sharing class EmailTemplateController {
  @AuraEnabled(cacheable=true)
  public static List<EmailTemplate> getEmailTemplates() {
      return [
        SELECT Name, Body, Subject 
        FROM EmailTemplate
        WHERE Name='SendInvoiceTemplate'
        LIMIT 1
      ];
  }
}