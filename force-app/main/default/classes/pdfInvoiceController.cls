public class PdfInvoiceController {
    public Organization organization {get; set;}
    public Account account {get; set;}
    public User user {get; set;}
    public OpportunityContactRole opportunityContactRole {get; set;}
    public List<Product2> products {get; set;}
    public List<OpportunityLineItem> opportunityProducts {get; set;}
    public Opportunity opportunityObj {get; set;}
    public Contact contact {get; set;}
    public Decimal totalSum {get; set;}
    public Opportunity curOpportunityId {get; set;}
    public static String opportunityId {get; set;}
  
    public PdfInvoiceController(ApexPages.StandardController stdController) {
        curOpportunityId = (Opportunity)stdController.getRecord();
        opportunityId = curOpportunityId.Id;

        if (totalSum == null) {
            totalSum = 0;
        }
      
        this.organization = [SELECT Id, PrimaryContact, Name, Country, City, Street FROM Organization];
        System.debug(organization);
        this.opportunityObj = [SELECT Id, Name, OwnerId, Invoice_Number__c, Amount FROM Opportunity WHERE Id=:opportunityId LIMIT 1];
        System.debug(opportunityObj);
        this.opportunityContactRole = [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole WHERE OpportunityId=:opportunityId];
        System.debug(opportunityContactRole);

        this.opportunityProducts = [SELECT Id, Name, Quantity, TotalPrice, UnitPrice, Product2Id FROM OpportunityLineItem WHERE OpportunityId=:opportunityId];
        System.debug(opportunityProducts);

        List<Product2> assignProduct = new List<Product2>();

        List<Product2> allProducts = [SELECT Name FROM Product2];


        for (OpportunityLineItem el : opportunityProducts) {
            for (Product2 productEl: allProducts) {
                if (el.Product2Id == productEl.Id) {
                    totalSum += el.TotalPrice;
                    assignProduct.add(productEl); 
                }
            }
        }
      
    this.products = assignProduct;
      
    this.contact = [SELECT Id, Name, AccountId, MobilePhone, Email FROM Contact WHERE Id=:opportunityContactRole.ContactId];
    System.debug(contact);

    this.account = [SELECT Id, Name FROM Account WHERE Id=:contact.AccountId];
    System.debug(account);

    this.user = [SELECT Id, Name FROM User WHERE Id=:opportunityObj.OwnerId];
    System.debug(user);
  }
}