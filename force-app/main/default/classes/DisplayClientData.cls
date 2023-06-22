public with sharing class DisplayClientData {
    public DisplayClientData() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
      return [
        SELECT Id, Name
        FROM Account
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getClosedOpportunitiesByAccountId(String accountId) {
      return [
        SELECT Id, Name, AccountId, StageName, CreatedDate, CloseDate, Amount
        FROM Opportunity
        WHERE StageName='Closed Won' AND AccountId=:accountId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunitiesProductByOpportunityId(String opportunityId) {
      return [
        SELECT Id, Name, Quantity, TotalPrice, UnitPrice
        FROM OpportunityLineItem 
        WHERE OpportunityId=:opportunityId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccountsByName (String searchInput) {
      String newString = '%';
      newString += searchInput;
      newString += '%';
      return [
        SELECT Id, Name
        FROM Account
        WHERE Name
        LIKE :newString
      ];
    }

    // @AuraEnabled(cacheable=true)
    // public static List<Account> searchAccountsByNameAndNum (String searchInput) {
    //   String newString = '%';
    //   newString += searchInput;
    //   newString += '%';
    //   return [
    //     SELECT Id, Name
    //     FROM Account
    //     WHERE Name
    //     LIKE :newString
    //   ];
    // }
}