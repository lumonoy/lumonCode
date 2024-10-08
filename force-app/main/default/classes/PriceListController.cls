/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PriceListController {
    @AuraEnabled(cacheable=true)
    public static List<Base_Price__c> getBasePrices() {
        // Populate map from SOQL query on PricebookEntry
        List<Base_Price__c> basePrices = ([SELECT  Id,
                                                        CurrencyIsoCode, 
                                                        Item_Code__c, 
                                                        Batch_Price__c, 
                                                        Salestori_Id__c, 
                                                        Minumum_Price__c, 
                                                        Product_Code__c, 
                                                        Manual_Processing__c, 
                                                        Delivery_Time__c, 
                                                        Cost_Multiplier__c, 
                                                        Commission__c, 
                                                        Base_Price__c, 
                                                        Volume_Discount__c, 
                                                        Emphasis__c, 
                                                        Variant__c, 
                                                        IsActive__c, 
                                                        Cost_Type__c, 
                                                        Name__c, 
                                                        Description__c, 
                                                        Unit_Of_Measure__c, 
                                                        Maintori_Id__c, 
                                                        Site_Discount__c 
                                                FROM Base_Price__c 
                                            ]);
        System.debug('--- Base Price Entries: '+basePrices);                                         
        return basePrices;
    }   
    @AuraEnabled(cacheable=true)
    public static Map<String,Base_Price__c> getBasePriceToItemMap() {
        Map<String,Base_Price__c> basePriceToItemMap = new  Map<String,Base_Price__c>();
        List<Base_Price__c> basePrices = getBasePrices();
        System.debug('--- PriceListController - '+basePrices?.size()+' Prices in List');
        for (Base_Price__c basePriceEntry : basePrices){
            String productCode = basePriceEntry.product_Code__c;
            String itemCode = basePriceEntry.item_Code__c;
            basePriceToItemMap.put(productCode+'-'+itemCode, basePriceEntry);
        }
        System.debug('--- PriceListController - '+basePriceToItemMap?.keySet().size()+' Keys in Map');
        return basePriceToItemMap;
    }
}