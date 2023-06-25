public with sharing class GetReceiver {

  @AuraEnabled(cacheable=true)
  public static String getReceiverName(String recordId) {
    return getContactName(String.valueOf([
      SELECT Id, ContactId, OpportunityId
      FROM OpportunityContactRole
      WHERE OpportunityId=:recordId
      LIMIT 1][0].ContactId));
  }

  @AuraEnabled(cacheable=true)
  public static String getReceiverEmail(String recordId) {
    return getContactEmail(String.valueOf([
      SELECT Id, ContactId, OpportunityId
      FROM OpportunityContactRole
      WHERE OpportunityId=:recordId
      LIMIT 1][0].ContactId));
  }

  @AuraEnabled(cacheable=true)
  public static String getContactName(String contactId) {
    return [
        SELECT Id, Name
        FROM Contact
        WHERE Id=:contactId
        LIMIT 1
      ][0].Name;
  }

  @AuraEnabled(cacheable=true)
  public static String getContactEmail(String contactId) {
    return [
        SELECT Id, Email
        FROM Contact
        WHERE Id=:contactId
        LIMIT 1
      ][0].Email;
  }
}