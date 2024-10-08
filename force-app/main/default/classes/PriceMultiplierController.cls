/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PriceMultiplierController{
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,Factory_Price__c>> getFactoryPrices(List<String> productGroups, String recordOrg,String recordCountry, String recordBusiness){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        List<Factory_Price__c> factoryPrices = new List<Factory_Price__c>();
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = new  Map<String,Map<String,Factory_Price__c>>();
        if (String.isNotBlank(recordOrg) || String.isNotBlank(recordCountry) ||String.isNotBlank(recordBusiness)) {            
            factoryPrices = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Factory_Multiplier__c,
                                    IsActive__c
                            FROM Factory_Price__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND IsActive__c = true
                            AND Product_Group__c IN: productGroups];
        }
        System.debug('--- PriceMultiplierController - '+factoryPrices.size() +' Factory Prices retrieved');
        if (!factoryPrices.isEmpty()) {
            for (Factory_Price__c factoryPrice : factoryPrices) {
                String productGroup = factoryPrice.Product_Group__c;
                String costType = factoryPrice.Cost_Type__c;

                if(!factoryPriceMap.containsKey(productGroup)) {
                    factoryPriceMap.put(productGroup, new Map<String,Factory_Price__c>());
                }
                factoryPriceMap.get(productGroup).put(costType, factoryPrice);
            }
        }
        return factoryPriceMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,Product_Cost__c>> getProductCosts(List<String> productGroups, String recordOrg,String recordCountry,
                                                                             String recordBusiness,String recordDistrict){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        List<Product_Cost__c> productCosts = new List<Product_Cost__c>();
        Map<String,Map<String,Product_Cost__c>> productCostMap = new  Map<String,Map<String,Product_Cost__c>>();
        if (String.isNotBlank(recordOrg) && String.isNotBlank(recordCountry) 
            && String.isNotBlank(recordBusiness) && String.isNotBlank(recordDistrict)) {
            productCosts = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    District__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Cost_Multiplier__c,
                                    Max_Value__c,
                                    Min_Value__c,
                                    IsActive__c
                            FROM Product_Cost__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND District__c =: recordDistrict
                            AND IsActive__c = true
                            AND Product_Group__c IN: productGroups];
        }
        System.debug('--- PriceMultiplierController - '+productCosts.size() +' Product Costs retrieved');
        if (!productCosts.isEmpty()) {
            for (Product_Cost__c productCost: productCosts) {
                String productGroup = productCost.Product_Group__c;
                String costType = productCost.Cost_Type__c;
                if(!productCostMap.containsKey(productGroup)) {
                    productCostMap.put(productGroup, new Map<String, Product_Cost__c>());
                }
                productCostMap.get(productGroup).put(costType, productCost);
            }
        }
        return productCostMap;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,Sales_Price__c>> getSalesPrices(List<String> productGroups,String recordOrg,String recordCountry,
                                                                             String recordBusiness,String recordDistrict,
                                                                             String recordProfitCenter, String recordBusinessId){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        List<Sales_Price__c> salesPrices = new List<Sales_Price__c>();
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = new  Map<String,Map<String,Sales_Price__c>>();
        if (String.isNotBlank(recordOrg) && String.isNotBlank(recordCountry) 
            && String.isNotBlank(recordBusiness) && String.isNotBlank(recordDistrict)
            && String.isNotBlank(recordProfitCenter)) {
            salesPrices = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    BusinessId__c,
                                    Business_Type__c,
                                    District__c,
                                    Profit_Center__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Sales_Multiplier__c,
                                    Max_Value__c,
                                    Min_Value__c,
                                    IsSellable__c,
                                    IsActive__c
                            FROM Sales_Price__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND (
                                (District__c =: recordDistrict AND Profit_Center__c = null)
                                OR (Profit_Center__c =: recordProfitCenter)
                                OR (BusinessId__c =: recordBusinessId)
                                )
                            AND IsActive__c = true
                            AND Product_Group__c IN: productGroups];
        }
        System.debug('--- PriceMultiplierController -'+salesPrices.size() +' Sales Prices retrieved');
        if (!salesPrices.isEmpty()) {
            for (Sales_Price__c salesPrice : salesPrices) {
                String productGroup = salesPrice.Product_Group__c;
                String costType = salesPrice.Cost_Type__c;

                if(!salesPriceMap.containsKey(productGroup)) {
                    salesPriceMap.put(productGroup, new Map<String, Sales_Price__c>());
                }
                salesPriceMap.get(productGroup).put(costType, salesPrice);
            }
        }
        return salesPriceMap;
    }
    @AuraEnabled(cacheable=true)
    public static Factory_Price__c getFactoryPrice(String productGroup, String costType,
                                                    String recordOrg,String recordCountry, String recordBusiness){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        Factory_Price__c factoryPrice = new Factory_Price__c();
        if (String.isNotBlank(recordOrg) || String.isNotBlank(recordCountry) ||String.isNotBlank(recordBusiness)) {
            System.debug('---  Retrieving Factory Prices');
            
            factoryPrice = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Factory_Multiplier__c,
                                    IsActive__c
                            FROM Factory_Price__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND IsActive__c = true
                            AND Product_Group__c =: productGroup
                            AND Cost_Type__c =: costType
                            LIMIT 1];
        }
        System.debug('--- PriceMultiplierController - Factory Price: '+factoryPrice);
        return factoryPrice;
    }
    @AuraEnabled(cacheable=true)
    public static Product_Cost__c getProductCost(String productGroup,String costType, 
                                                    String recordOrg,String recordCountry,
                                                    String recordBusiness,String recordDistrict){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        Product_Cost__c productCost = new Product_Cost__c();
        if (String.isNotBlank(recordOrg) && String.isNotBlank(recordCountry) 
            && String.isNotBlank(recordBusiness) && String.isNotBlank(recordDistrict)) {
            productCost = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    District__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Cost_Multiplier__c,
                                    Max_Value__c,
                                    Min_Value__c,
                                    IsActive__c
                            FROM Product_Cost__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND District__c =: recordDistrict
                            AND Product_Group__c =: productGroup
                            AND Cost_Type__c =: costType
                            LIMIT 1];
        }
        System.debug('--- PriceMultiplierController - Product Cost: '+productCost);
        return productCost;
    }
    @AuraEnabled(cacheable=true)
    public static Sales_Price__c getSalesPrice(String productGroup, String costType, 
                                                String recordOrg,String recordCountry,
                                                String recordBusiness,String recordDistrict,
                                                String recordProfitCenter, String recordBusinessId){
        //Input: Organization and Business Type
        //Output: Factory Multiplier per ProductGroup and Cost Type
        Sales_Price__c salesPrice = new Sales_Price__c();
        if (String.isNotBlank(recordOrg) && String.isNotBlank(recordCountry) 
            && String.isNotBlank(recordBusiness) && String.isNotBlank(recordDistrict)
            && String.isNotBlank(recordProfitCenter)) {
            salesPrice = [SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    BusinessId__c,
                                    Business_Type__c,
                                    District__c,
                                    Profit_Center__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Sales_Multiplier__c,
                                    Max_Value__c,
                                    Min_Value__c,
                                    IsSellable__c,
                                    IsActive__c
                            FROM Sales_Price__c
                            WHERE Organization__c =: recordOrg
                            AND Country__c =: recordCountry
                            AND Business_Type__c =: recordBusiness
                            AND (
                                (District__c =: recordDistrict AND Profit_Center__c = null)
                                OR (Profit_Center__c =: recordProfitCenter)
                                OR (BusinessId__c =: recordBusinessId)
                                )
                            AND Product_Group__c =: productGroup
                            AND Cost_Type__c =: costType
                            LIMIT 1];
        }
        System.debug('--- PriceMultiplierController - Sales Price: '+SalesPrice);
        return salesPrice;
    }
}