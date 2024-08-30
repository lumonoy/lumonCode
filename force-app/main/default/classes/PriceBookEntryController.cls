/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PriceBookEntryController {
    @AuraEnabled(cacheable=false)
    public static Pricebook2 getPricebookRecord(Id pricebookId) {
        // Populate map from SOQL query on Pricebook
        if(Test.isRunningTest()){
            //Invoke mock web service response
            pricebookId = Test.getStandardPricebookId();
        }
        System.debug('--- Get Data for Pricebook: '+pricebookId);
        Pricebook2 pricebookRecord = ([SELECT Id, Name,CurrencyIsoCode,
                                                Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                                                Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                                                Profit_Center__c, Customer_Attribute__c //Tier 3 Sales Prices  
                                    FROM Pricebook2 
                                    WHERE Id = :pricebookId]);
        System.debug('--- Pricebook Record: '+pricebookRecord);
        return pricebookRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static Pricebook2 getPriceList(Date closureDate) {
        // Populate map from SOQL query on Pricebook
        System.debug('--- Get PriceList valid on Date : '+closureDate);
        Pricebook2 pricelistRecord = new Pricebook2();
        if(Test.isRunningTest()){
            //Invoke mock web service response
            Id pbid = Test.getStandardPricebookId();
            pricelistRecord.Id = pbId;
         } else{
            pricelistRecord = ([SELECT Id, Name,CurrencyIsoCode,
                                                    Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                                                    Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                                                    Profit_Center__c, Customer_Attribute__c //Tier 3 Sales Prices                                              
                                    FROM Pricebook2 
                                    WHERE Start_Date__c <:closureDate
                                    AND (End_Date__c >:closureDate
                                    OR End_Date__c = null)
                                    AND IsPriceList__c = true]);
            System.debug('--- PriceList Record: '+pricelistRecord);
         }
        return pricelistRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookEntries(String pricebookId) {
        // Populate map from SOQL query on PricebookEntry
        List<PricebookEntry> pricebookEntries = ([SELECT  Id,
                                                            Name,
                                                            Pricebook2Id, 
                                                            Pricebook2.Name,
                                                            Product2Id,
                                                            Product2.Name,
                                                            Product2.QuantityUnitOfMeasure,
                                                            Product2.ProductCode,
                                                            Product2.Reclamation__c,
                                                            Product2.Installation__c,
                                                            Product2.Cost_Category__c,
                                                            Product2.Cost_Type__c,
                                                            Product2.Product_Category__c,
                                                            Product2.Product_Type__c,
                                                            Product2.Product_Item__c,
                                                            Product2.Product_Group__c,
                                                            Product2.Sales_Code__c,
                                                            Product2.IsActive,
                                                            UnitPrice, 
                                                            Minimum_Price__c,
                                                            Quantity_Per_Order__c, 
                                                            Transmission__c,
                                                            //StandardPrice,
                                                            UseStandardPrice,
                                                            IsActive,
                                                            CurrencyIsoCode  
                                                    FROM PricebookEntry 
                                                    WHERE Pricebook2Id = :pricebookId]);
        System.debug('--- Pricebook Entries: '+pricebookEntries);                                         
        return pricebookEntries;
    } 

    public static Map<String,PricebookEntry> getPricebookEntryMap(String pricebookId, String currencyCode) {
        return getPricebookEntryMap(pricebookId, currencyCode, null);
    }

    public static Map<String,PricebookEntry> getPricebookEntryMap(
        String pricebookId,
        String currencyCode,
        Opportunity opportunityRecord
    ) {
        // Populate List from SOQL query on PriceBookEntry
        Boolean reclamation = opportunityRecord?.Order_type__c == 'Reclamation';
        Boolean isActive = true;
        System.debug('--- Get Pricebook Entries in '+currencyCode+' for Pricebook '+pricebookId); 
        List<PricebookEntry> pricebookEntries = ([  SELECT  Id,
                                                            Name,
                                                            Pricebook2Id, 
                                                            Pricebook2.Name,
                                                            Product2Id,
                                                            Product2.Name,
                                                            Product2.QuantityUnitOfMeasure,
                                                            Product2.ProductCode,
                                                            Product2.Reclamation__c,
                                                            Product2.Installation__c,
                                                            Product2.Cost_Category__c,
                                                            Product2.Cost_Type__c,
                                                            Product2.Product_Category__c,
                                                            Product2.Product_Type__c,
                                                            Product2.Product_Item__c,
                                                            Product2.Product_Group__c,
                                                            Product2.Sales_Code__c,
                                                            Product2.IsActive,
                                                            UnitPrice, 
                                                            Minimum_Price__c,
                                                            Quantity_Per_Order__c, 
                                                            Transmission__c,
                                                            //StandardPrice,
                                                            UseStandardPrice,
                                                            IsActive,
                                                            CurrencyIsoCode                                    
                                                    FROM PricebookEntry 
                                                    WHERE Pricebook2Id = :pricebookId
                                                    AND IsActive =: isActive
                                                    AND CurrencyIsoCode =: currencyCode
                                                    AND Product2.Reclamation__c =: reclamation
                                                    ]);  
            System.debug('--- Active Pricebook Entries: '+pricebookEntries.size()); 
        
        Map<String,PricebookEntry> pbeMap  = New Map<String,PricebookEntry>();  
        if (pricebookEntries.size()>0)  {                                
            for (PricebookEntry pricebookProduct :pricebookEntries) {
                String productCode = pricebookProduct.Product2.ProductCode;
                String product2Id = pricebookProduct.Product2Id;
                pbeMap.put(productCode,pricebookProduct);
            }
        }  
        return pbeMap;  
    }  
    
    public static Map<String, PricebookEntry> getPricebookEntriesByProductCodes(
        String pricebookId,
        String currencyCode,
        Opportunity opportunityRecord,
        List<String> productCodes
    ) {
        Boolean reclamation = opportunityRecord?.Order_type__c == 'Reclamation';
        List<PricebookEntry> pricebookEntries = [
            SELECT
                Id,
                Name,
                Pricebook2Id,
                Pricebook2.Name,
                Product2Id,
                Product2.Name,
                Product2.QuantityUnitOfMeasure,
                Product2.ProductCode,
                Product2.Reclamation__c,
                Product2.Installation__c,
                Product2.Cost_Category__c,
                Product2.Cost_Type__c,
                Product2.Product_Category__c,
                Product2.Product_Type__c,
                Product2.Product_Item__c,
                Product2.Product_Group__c,
                Product2.Sales_Code__c,
                Product2.IsActive,
                UnitPrice,
                Minimum_Price__c,
                Quantity_Per_Order__c,
                Transmission__c,
                UseStandardPrice,
                IsActive,
                CurrencyIsoCode
            FROM PricebookEntry
            WHERE
                Pricebook2Id = :pricebookId
                AND IsActive = TRUE
                AND CurrencyIsoCode = :currencyCode
                AND Product2.Reclamation__c = :reclamation
                AND Product2.ProductCode IN :productCodes
        ];
        Map<String, PricebookEntry> pricebookEntriesByProductCode = new Map<String, PricebookEntry>();
        for (PricebookEntry pricebookProduct : pricebookEntries) {
            pricebookEntriesByProductCode.put(pricebookProduct.Product2.ProductCode, pricebookProduct);
        }
        return pricebookEntriesByProductCode;
    }

}