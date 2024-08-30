/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
public class ConfigurationItems {
    @InvocableVariable(label='Configuration Items' required=false )  
    @AuraEnabled public String parentId;
    @AuraEnabled public List<PricingItem> lineItems;
    @AuraEnabled public String organization;
    @AuraEnabled public String countryCode;
    @AuraEnabled public String territory;
    @AuraEnabled public String businesType;
    @AuraEnabled public String profitCenter;
    @AuraEnabled public String customerNumber;
    public class PricingItem {
        @AuraEnabled public String ProductCode;// Product Identifier "<Group>-<SalesCode>"
        @AuraEnabled public String ProductGroup;// Product Grouping
        @AuraEnabled public String CostCategory;// Cost Categorization
        @AuraEnabled public String CostType;// Cost Categorization
        @AuraEnabled public String Product2Id; // Product2 Table Record
        @AuraEnabled public Double Quantity; // Quantity in Units Of Measure
        @AuraEnabled public String UnitOfMeasure; //Quantity Unit of Measure 
        @AuraEnabled public Double BasePrice; // PriceList Price 
        @AuraEnabled public Double FactoryMultiplier; // Tier 1 Factory Price Parameter Value
        @AuraEnabled public Double FactoryPrice; // BasePrice * FactoryMultiplier
        @AuraEnabled public Double CostMultiplier; // Tier 2 Product Cost Parameter Value
        @AuraEnabled public Double Cost; // BasePrice * CostMultiplier
        @AuraEnabled public Double SalesMultiplier; // Tier 3 Sales Price Parameter Value
        @AuraEnabled public Double UnitPrice; // BasePrice * SalesMultiplier
        @AuraEnabled public Double SalesPrice; // Actual SalesPrice

    }
    public static ConfigurationItems parseConfigurationItems(String itemJSON) {
        return (ConfigurationItems) System.JSON.deserialize(itemJSON, ConfigurationItems.class);
    }
}