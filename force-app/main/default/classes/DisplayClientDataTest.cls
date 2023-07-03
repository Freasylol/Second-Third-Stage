@isTest
public class DisplayClientDataTest {
    public DisplayClientDataTest() {

    }

    @isTest static void testGetClosedOpportunitiesByAccountId() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity Name';
        opportunity.AccountId = account.Id;
        opportunity.StageName = 'Closed Won';
        opportunity.CloseDate = Date.today();
        opportunity.Amount = 10;
        insert opportunity;
     
        List<Opportunity> opportunities = DisplayClientData.getClosedOpportunitiesByAccountId(account.Id);

        System.assertEquals(opportunity.Name, opportunities[0].Name);
        System.assertEquals(opportunity.Id, opportunities[0].Id);
    }

    @isTest static void testGetClosedOpportunities() {
      Account account = new Account();
      account.Name = 'Test Account';
      insert account;

      Opportunity opportunity = new Opportunity();
      opportunity.Name = 'Test opportunity Name';
      opportunity.AccountId = account.Id;
      opportunity.StageName = 'Closed Won';
      opportunity.CloseDate = Date.today();
      opportunity.Amount = 10;
      insert opportunity;
     
      List<Opportunity> opportunities = DisplayClientData.getClosedOpportunities();

      System.assertEquals(opportunity.Name, opportunities[0].Name);
      System.assertEquals(opportunity.Id, opportunities[0].Id);
    }

    @isTest static void testGetOpportunitiesProductByOpportunityId() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity Name';
        opportunity.AccountId = account.Id;
        opportunity.StageName = 'Closed Won';
        opportunity.CloseDate = Date.today();
        opportunity.Amount = 10;
        insert opportunity;

        Product2 product = new Product2();
        product.Name = 'Sample product';
        product.IsActive = true;
        product.ProductCode = '1001';
        insert product;
    
        Id standardPriceBookId = Test.getStandardPricebookId();
    
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Product2Id = product.Id;
        pricebookEntry.PriceBook2Id = standardPriceBookId;
        pricebookEntry.UnitPrice = 100.00;
        pricebookEntry.IsActive = true;
        insert pricebookEntry;    
    
        OpportunityLineItem oppProduct = new OpportunityLineItem();
        oppProduct.OpportunityId = opportunity.Id;
        oppProduct.Product2Id = product.Id;
        oppProduct.Quantity = 10;
        oppProduct.PriceBookEntryId = pricebookEntry.Id;
        oppProduct.TotalPrice = oppProduct.Quantity * pricebookEntry.UnitPrice;
        insert oppProduct;
        
        List<OpportunityLineItem> opportunityProducts = DisplayClientData.getOpportunitiesProductByOpportunityId(opportunity.Id);

        System.assertEquals(oppProduct.Id, opportunityProducts[0].Id);
    }

    @isTest static void testSearchAccountsByName() {
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        List<Account> accounts = DisplayClientData.searchAccountsByName(account.Name);

        System.assertEquals(account.Name, accounts[0].Name);
        System.assertEquals(account.Id, accounts[0].Id);
    }
}