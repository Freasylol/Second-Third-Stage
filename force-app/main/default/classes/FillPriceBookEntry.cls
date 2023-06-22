public class FillPriceBookEntry {
    public static void initPricebookEntry() {
    List<Product2> products = new List<Product2>([SELECT Id FROM Product2]);
    Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE isActive=true LIMIT 1];
        
    List<PricebookEntry> pricebookEntries = new List<PricebookEntry>(); 
        
    for (Product2 product : products) {
        Integer randomPrice = Integer.valueOf(Math.random() * 100);
        PricebookEntry pricebookEntry = new PricebookEntry(UseStandardPrice = FALSE, Product2Id=product.Id, Pricebook2Id=pricebook.Id,
                                                           UnitPrice=randomPrice, isActive=true);
        pricebookEntries.add(pricebookEntry);
		
    }
        
    insert pricebookEntries;
    }
}