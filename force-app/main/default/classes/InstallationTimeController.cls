/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 02-12-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class InstallationTimeController {
    @AuraEnabled(cacheable=true)
    public static List<Installation_Time__c> getInstallationTimes(Boolean isActive) {
        // Populate map from SOQL query on Installation Time
        List<Installation_Time__c> installationTimes = ([SELECT  Id,
                                                            Name,
                                                            Product__c, 
                                                            Product__r.Name,
                                                            Product__r.ProductCode,
                                                            Product__r.Sales_Code__c,
                                                            Product__r.Product_Group__c,
                                                            Product__r.Product_Model__c,
                                                            Product__r.Product_Category__c,
                                                            Product__r.Product_Type__c,
                                                            Product__r.Product_Item__c,
                                                            Product__r.IsActive,
                                                            Product__r.Batch_Size__c,
                                                            Product_Name__c, 
                                                            Product_Code__c, 
                                                            Product_Group__c,
                                                            Hours__c, 
                                                            Minutes__c,
                                                            IsActive__c
                                                    FROM Installation_Time__c
                                                    WHERE IsActive__c =: isActive]);
        System.debug('---  InstallationTimeController - Installation Times: '+installationTimes);                                         
        return installationTimes;
    } 
    @AuraEnabled(cacheable=false)
    public static Map<String,Installation_Time__c> getInstallationTimeMap(Boolean isActive) {
        // Populate List from SOQL query on Installation Time
        System.debug('--- InstallationTimeController - Get Installation Times'); 
        List<Installation_Time__c> installationTimes = getInstallationTimes(isActive);
        System.debug('--- InstallationTimeController - Returned Installation Times: '+installationTimes.size()); 
        Map<String,Installation_Time__c> installationTimeMap  = New Map<String,Installation_Time__c>();  
        if (installationTimes.size()>0)  {                                
            for (Installation_Time__c installationTime :installationTimes) {
                String productCode = installationTime.Product__r.ProductCode;
                String product2Id = installationTime.Product__c;
                installationTimeMap.put(productCode,installationTime);
            }
        }  
        return installationTimeMap;  
    } 
    @AuraEnabled(cacheable=true)
    public static List<Product2> getInstallationTimeProducts(Boolean isActive) {
        // Populate map from SOQL query on Product2
        List<Product2> installationTimeProducts = ([SELECT  Id,
                                                            Name,
                                                            ProductCode, 
                                                            Product_Group__c, 
                                                            Product_Model__c, 
                                                            Product_Category__c, 
                                                            Product_Type__c,
                                                            Product_Item__c, 
                                                            Cost_Category__c,
                                                            Batch_Size__c,
                                                            Cost_Type__c,
                                                            Sales_Code__c,
                                                            QuantityUnitOfMeasure,
                                                            IsActive
                                                    FROM Product2
                                                    WHERE IsActive =: isActive
                                                    AND (Cost_Category__c =: 'Manhours'
                                                    OR QuantityUnitOfMeasure =: 'h'
                                                    OR Cost_Type__c =: 'askuormitu')]);
        System.debug('--- InstallationTimeController - Installation Time Products: '+installationTimeProducts);                                         
        return installationTimeProducts;
    } 
    @AuraEnabled(cacheable=false)
    public static Map<String,Product2> getInstallationTimeProductMap(Boolean isActive) {
        // Populate List from SOQL query on Product2
        System.debug('--- InstallationTimeController - Get Installation Time Products'); 
        List<Product2> installationTimeProducts = getInstallationTimeProducts(isActive);
        System.debug('--- InstallationTimeController - Returned Installation Time Products: '+installationTimeProducts.size()); 
        Map<String,Product2> installationTimeProductMap  = New Map<String,Product2>();  
        if (installationTimeProducts.size()>0)  {                                
            for (Product2 installationTimeProduct :installationTimeProducts) {
                String productCode = installationTimeProduct.ProductCode;
                String product2Id = installationTimeProduct.Id;
                installationTimeProductMap.put(productCode,installationTimeProduct);
            }
        }  
        return installationTimeProductMap;  
    } 
}