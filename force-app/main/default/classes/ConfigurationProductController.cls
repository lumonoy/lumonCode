/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-09-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationProductController {
    @AuraEnabled(cacheable=true)
    public static Configuration_Product__c getConfigurationProduct(Id recordId) { 
        // Find Configuration Product based on recordId
        List<Id> recordIds = new List<Id>{recordId};
        List<Configuration_Product__c> configProducts = getConfigurationProducts(recordIds);
        Configuration_Product__c configProduct = configProducts[0];
        return configProduct;
    }   
    @AuraEnabled(cacheable=false)
    public static Configuration_Product__c getConfigurationProductByNumber(String rvnNumber) {
        // Populate List from SOQL query on Product
        Id configProductId = [SELECT Id, SerialNumber__c FROM Configuration_Product__c WHERE ProductIdentifier__c =: rvnNumber LIMIT 1]?.Id; 
        List<Id> configProductIds = new List<Id>();
        configProductIds.add(configProductId);
        Configuration_Product__c configProduct = new Configuration_Product__c();
        System.debug('--- ConfigurationProductController - Get Configuration Product with Id '+configProductId); 
        List<Configuration_Product__c> configProducts =  getConfigurationProducts(configProductIds); 
        if  (configProducts?.size()>0) {
            configProduct = configProducts[0];
            System.debug('--- ConfigurationProductController - Configuration Product: '+configProduct.Name); 
        }        
        return configProduct;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration_Product__c> getConfigurationProducts(List<Id> recordIds){
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        configProducts = [  SELECT  Id,
                                    Name,
                                    Configuration__c, // Keep
                                    ProductCode__c, //New
                                    SerialNumber__c, //New
                                    Configuration__r.Opportunity__c,
                                    Configuration__r.Plan_Type__c,
                                    Product_Group__c,
                                    Product_Model__c,
                                    Sales_Code__c,
                                    Quantity__c,
                                    Product__c,
                                    Product__r.Name,
                                    Product__r.Product_Group__c,
                                    Product__r.Cost_Category__c,
                                    Product__r.Cost_Type__c,
                                    Product__r.Product_Category__c, 
                                    Product__r.Product_Type__c, 
                                    Product__r.Product_Item__c, 
                                    Product__r.ProductCode, 
                                    Product__r.Sales_Code__c,
                                    Product__r.QuantityUnitOfMeasure,
                                    Product__r.Reclamation__c,
                                    Product__r.Installation__c,
                                    Product__r.IsActive,
                                    RVN_Number__c,
                                    RVN__c,
                                    Inspection_Code__c,
                                    Configuration__r.Plan_Apartment__c,
                                    Configuration__r.Plan_Line__c,
                                    Configuration__r.Plan_Floor__c,
                                    Configuration__r.Plan_Name__c,
                                    Count_Items__c
                            FROM Configuration_Product__c 
                            WHERE Id IN: recordIds
                            OR Configuration__c IN: recordIds
                            OR Configuration__r.Opportunity__c IN: recordIds 
                            OR Product__c IN: recordIds];
        return configProducts;
    }
}