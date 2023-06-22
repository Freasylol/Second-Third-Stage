public with sharing class GetEmailInfo {
  @AuraEnabled(cacheable=true)
  public static String getEmailInfo(String recordId) {
    return [
      SELECT Invoice_Number__c
      FROM Opportunity
      WHERE Id=:recordId
      LIMIT 1
    ][0].Invoice_Number__c;
  }
}