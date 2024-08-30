/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationOptionController {
    @AuraEnabled(cacheable=true)
    public static Configuration_Option__c getConfigurationOption(Id recordId){
    List<Id> recordIds = new List<Id>{recordId};
	List<Configuration_Option__c> configOptions = getConfigurationOptions(recordIds);
    Configuration_Option__c configOption =configOptions[0];
		return configOption;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration_Option__c> getConfigurationOptions(List<Id> recordIds){
        List<Configuration_Option__c> configOptions = new List<Configuration_Option__c>();
        configOptions = [   SELECT Id,
                                    Name,
                                    Product_Group__c,
                                    Product_Model__c,
                                    Product_Code__c,
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
                                    Configuration_Product__c,
                                    Configuration_Product__r.RVN__c,
                         			Configuration_Product__r.Configuration__c,
                                    Configuration_Product__r.Configuration__r.Opportunity__c                                          
                            FROM Configuration_Option__c 
                            WHERE Id IN: recordIds
                            OR Configuration_Product__c IN: recordIds
                            OR Configuration_Product__r.Configuration__c IN: recordIds
                            OR Configuration_Product__r.Configuration__r.Opportunity__c IN: recordIds];
        return configOptions;
    }  
}