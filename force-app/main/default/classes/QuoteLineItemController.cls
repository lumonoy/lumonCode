/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-14-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class QuoteLineItemController {
    public static List<QuoteLineItem> getQuoteLines(Id recordId) {
         // Populate List from SOQL query on QuoteLineItem
         List<Id> recordIds = new List<Id>();
         recordIds.add(recordId);
         System.debug('--- Get QuoteLines for Id '+recordId); 
         List<QuoteLineItem> quotelineItems =  getQuoteLineItems(recordIds);  
         // Populate map from SOQL query on QuotelineItem
        System.debug('--- Quote Line Items: '+quotelineItems);                                         
        return quotelineItems;
    }
    public static List<QuoteLineItem> getQuoteLineItems(Id recordId) {
         // Populate List from SOQL query on QuoteLineItem
         List<Id> recordIds = new List<Id>();
         recordIds.add(recordId);
         System.debug('--- Get QuoteLines for Id '+recordId); 
         List<QuoteLineItem> quotelineItems =  getQuoteLineItems(recordIds);  
         // Populate map from SOQL query on QuotelineItem
        System.debug('--- Quote Line Items: '+quotelineItems);                                         
        return quotelineItems;
    }

    public static List<QuoteLineItem> getQuoteLineItemsById(List<Id> recordIds) {
        List<QuoteLineItem> quotelineItems =  getQuoteLineItems(recordIds);  
        // Populate map from SOQL query on QuotelineItem
       System.debug('--- Quote Line Items: '+quotelineItems);                                         
       return quotelineItems;
    }
    public static List<QuoteLineItem> getQuoteLineItems(List<Id> recordIds) {
        // Populate map from SOQL query on QuotelineItem
        List<QuoteLineItem> quotelineItems = ([ SELECT  Id,
                                                        LineNumber,
                                                        Line_Number__c,                                                        
                                                        Description,
                                                        CurrencyIsoCode,
                                                        PricebookEntryId,
                                                        PricebookEntry.Pricebook2Id,                                                      
                                                        Sales_Code__c,   
                                                        QuoteId,
                                                        Quote.OpportunityId,
                                                        Opportunity_Number__c,
                                                        fxProductGroup__c,
                                                        fxCostCategory__c,
                                                        fxCostType__c,
                                                        Product_Group__c,
                                                        Product_Model__c,
                                                        Cost_Category__c,
                                                        Cost_Type__c,
                                                        Base_Price__c,
                                                        Factory_Multiplier__c,
                                                        Factory_Price__c,
                                                        fxUnitFactoryPrice__c,
                                                        fxFactory__c,
                                                        Cost_Multiplier__c,
                                                        Product_Cost__c,
                                                        fxUnitCost__c,
                                                        fxCost__c,
                                                        Sales_Multiplier__c,
                                                        fxUnitSalesPrice__c,
                                                        fxSales__c,                                                  
                                                        ListPrice,
                                                        List_Price__c,                                                                                
                                                        fxList__c,
                                                        UnitPrice,
                                                        Min_Sales_Price__c,
                                                        Min_Price__c,
                                                        Max_Quantity__c,
                                                        Transmission__c,
                                                        Contracted_Sales_Price__c,
                                                        Discount,
                                                        Discount__c,
                                                        fxDiscount__c,
                                                        Sales_Margin__c,
                                                        SubTotal,
                                                        TotalPrice,
                                                        Product_Code__c,
                                                        Quantity,
                                                        Product2Id,
                                                        Product2.Name,
                                                        Product2.Product_Group__c,
                                                        Product2.Cost_Category__c,
                                                        Product2.Cost_Type__c,
                                                        Product2.Product_Category__c, 
                                                        Product2.Product_Type__c, 
                                                        Product2.Product_Item__c, 
                                                        Product2.ProductCode, 
                                                        Product2.Sales_Code__c,
                                                        Product2.QuantityUnitOfMeasure,
                                                        Product2.Reclamation__c,
                                                        Product2.Installation__c,
                                                        Product2.Special__c,
                                                        Product2.Manual_Processing__c,
                                                        Product2.Service__c,
                                                        Product2.Sovelia__c,
                                                        Product2.Visual__c,
                                                        Product2.IsActive,
                                                        Configuration_Plan__c,
                                                        Configuration_Product__c,
                                                        Configuration_Option__c,
                                                        Configuration_Product__r.RVN__c,
                                                        RVN__c,
                                                        RVN_Number__c,                                                        
                                                        Tax__c,
                                                        UniqueId__c
                                                    FROM QuoteLineItem
                                                    WHERE Id IN: recordIds 
                                                    OR QuoteId IN :recordIds
                                                    ORDER BY QuoteId, Product2.Product_Group__c, Product2.Cost_Type__c]);
        System.debug('--- Quote Line Items: '+quotelineItems);                                         
        return quotelineItems;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,QuoteLineItem> getQuoteLineItemsToProductMap(List<QuoteLineItem> quoteLineItems){
        Map<String,QuoteLineItem> qliMap = New Map<String,QuoteLineItem>();     
        if (quotelineItems.size()>0) {                               
            for (QuoteLineItem quotelineItem :quotelineItems) {
                String productCode = quotelineItem.Product2.ProductCode;
                String product2Id = quotelineItem.Product2Id;
                Decimal quantity = quotelineItem.Quantity;
                qliMap.put(productCode,quotelineItem);
            }
        }  
        return qliMap;  
    } 
    @AuraEnabled(cacheable=true)
    public static Map<String,QuoteLineItem> getQuoteLineItemsToGroupMap(List<QuoteLineItem> quoteLineItems) {
        // Populate List from SOQL query on QuoteLine
        System.debug('--- QuoteLine Items: '+quotelineItems.size()); 
        Map<String,QuoteLineItem> qliMap = New Map<String,QuoteLineItem>();     
        if (quotelineItems.size()>0) {                               
            for (QuoteLineItem quotelineItem :quotelineItems) {
                String productGroup = quotelineItem.Product2.Product_Group__c;
                String product2Id = quotelineItem.Product2Id;
                Decimal quantity = quotelineItem.Quantity;
                qliMap.put(productGroup,quotelineItem);
            }
        }  
        return qliMap;  
    } 
}