@isTest
private class PdfInvoiceControllerTest {
  @isTest 
  static void testCurOpportunity() {
    // Test.startTest();

    Account account = new Account();
    account.Name = 'Test Account';
    insert account;

    User user = new User();
    user.FirstName = 'test invoice name';
    user.LastName = 'test invoice last name';
    user.Email = 'test@example.com';
    user.UserName = 'testinvoice@example.com';
    user.Alias = 'testUser';
    user.CommunityNickName = 'testuser';
    user.TimeZoneSidKey = 'America/Los_Angeles';
    user.LocaleSidKey = 'en_US';
    user.EmailEncodingKey = 'UTF-8';
    user.ProfileId = '00eDn0000013AECIA2';
    user.LanguageLocaleKey = 'en_US';
    insert user;

    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'Test Opportunity';
    opportunity.StageName = 'Prospecting';
    opportunity.CloseDate = Date.today();
    opportunity.OwnerId = user.id;
    opportunity.Amount = 10;
    insert opportunity;

    Contact contact = new Contact();
    contact.FirstName = 'Test First Name';
    contact.LastName = 'Test Last Name';
    contact.AccountId = account.Id;
    insert contact;
    
    OpportunityContactRole oppContactRole = new OpportunityContactRole();
    oppContactRole.ContactId = contact.Id;
    oppContactRole.OpportunityId = opportunity.Id;
    insert oppContactRole;

    Product2 product = new Product2();
    product.Name = 'Sample product';
    product.IsActive = true;
    product.ProductCode = '1001';
    insert product;

    // Pricebook2 customPriceBook = new Pricebook2(Name='Custom Pricebook', isActive=true);
    // insert customPriceBook;

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

    System.debug('Opportunity name is ' + opportunity.Name);
    // System.debug('Opportunity stage name is ' + opportunity.StageName);
    // System.debug('Opportunity closeDate is ' + opportunity.CloseDate);

    Opportunity newOPP = [SELECT Invoice_Number__c FROM Opportunity WHERE Id=:opportunity.id];
    // System.debug(newOPP.Invoice_Number__c);
    // System.debug(newOPP.Name);
    // System.debug(newOPP.OwnerId);

    Opportunity testOpp = [SELECT Id, Name, OwnerId, Invoice_Number__c, Amount FROM Opportunity LIMIT 1];
    System.debug('testOpp name is ' + testOpp.Name);
    ApexPages.StandardController oppController = new ApexPages.StandardController(testOpp);
    Opportunity testOp = (Opportunity)oppController.getRecord();
    System.debug('Opp Id is ' + testOp.Id);
    System.debug('Opp Name is ' + testOp.Name);
    // System.debug('Opp instance of list' + testOp instanceof Opportunity);
    PdfInvoiceController invoiceController = new PdfInvoiceController(oppController);
    System.debug('CurOpportunity name is ' + opportunity.Name);
   
    System.assertEquals('Test Opportunity', opportunity.Name);
    // Test.stopTest();
  }
}