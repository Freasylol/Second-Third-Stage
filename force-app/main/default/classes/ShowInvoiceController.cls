public with sharing class ShowInvoiceController {
    @AuraEnabled(cacheable=true)
    public static String getOpportunityInvoiceNum(String recordId) {
        return String.valueOf([
            SELECT Invoice_Number__c 
            FROM Opportunity 
            WHERE Id=:recordId
            LIMIT 1
        ][0].Invoice_Number__c);
    }

    @AuraEnabled(cacheable=true)
    public static String getContentDocumentId(String test) {
        return String.valueOf([
            SELECT Id
            FROM ContentDocument 
            WHERE Title=:test
            LIMIT 1
        ][0].Id);
    }
}