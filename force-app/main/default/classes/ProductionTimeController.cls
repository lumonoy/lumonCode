/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ProductionTimeController {
    @AuraEnabled(cacheable=true)
    public static List<Production_Time__c> getProductionTimes(Boolean isActive) {
        // Populate map from SOQL query on Production Time
        List<Production_Time__c> productionTimes = ([SELECT Id,
                                                            Name,
                                                            Factory__c,
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
                                                            Days__c, 
                                                            Extra_Days__c,
                                                            Business_Type__c, 
                                                            Reference__c, 
                                                            Reclamation__c, 
                                                            Order_Type__c, 
                                                            IsActive__c
                                                    FROM Production_Time__c
                                                    WHERE IsActive__c =: isActive]);
        System.debug('--- Production Times: '+productionTimes);                                         
        return productionTimes;
    } 
    @AuraEnabled(cacheable=false)
    public static Map<String,Production_Time__c> getProductionTimeMap(Boolean isActive) {
        // Populate List from SOQL query on Production Time
        System.debug('--- Get Production Times'); 
        List<Production_Time__c> productionTimes = getProductionTimes(isActive);
        System.debug('--- Returned Production Times: '+productionTimes.size()); 
        Map<String,Production_Time__c> productionTimeMap  = New Map<String,Production_Time__c>();  
        if (productionTimes.size()>0)  {                                
            for (Production_Time__c productionTime :productionTimes) {
                String productCode = productionTime.Product__r.ProductCode;
                String product2Id = productionTime.Product__c;
                productionTimeMap.put(productCode,productionTime);
            }
        }  
        return productionTimeMap;  
    }  
}