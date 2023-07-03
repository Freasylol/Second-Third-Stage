public with sharing class GetReceiver {

  @AuraEnabled(cacheable=true)
  public static String getReceiverEmail(String recordId) {
    return [
        SELECT Id, ContactId, OpportunityId, Contact.Email
        FROM OpportunityContactRole
        WHERE OpportunityId=:recordId
        LIMIT 1
    ][0].Contact.Email;
  }

  @AuraEnabled(cacheable=true)
  public static String getReceiverName(String recordId) {
    return [
        SELECT Id, ContactId, OpportunityId, Contact.Name
        FROM OpportunityContactRole
        WHERE OpportunityId=:recordId
        LIMIT 1
    ][0].Contact.Name;
  }
}