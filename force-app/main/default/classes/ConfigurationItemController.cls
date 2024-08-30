/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationItemController {
    @AuraEnabled(cacheable=true)
    public static String getObjectType(String IdOrPrefix){
        String sObjectName = '';
        try{
            //Get prefix from record ID
            String recordIdPrefix = String.valueOf(IdOrPrefix).substring(0,3);     
            System.debug('--- PricingItemController - Get ObjectAPIName for prefix ' + recordIdPrefix);           
            //Get schema information
            Map<String, Schema.SObjectType> sObjectDescribeSchema =  Schema.getGlobalDescribe(); 
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType sObjType : sObjectDescribeSchema.values()){
                //if (!sObjType.contains('__')) to exclude managed package objects
                Schema.DescribeSObjectResult sObjectDescribeResult = sObjType.getDescribe();
                String objectTypePrefix = sObjectDescribeResult.getKeyPrefix();
                 //Check if the prefix matches with requested prefix
                if(objectTypePrefix!=null && objectTypePrefix.equals(recordIdPrefix)){
                    sObjectName = sObjectDescribeResult.getName();
                    System.debug('--- PricingItemController - Set ObjectAPIName ' + sObjectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return sObjectName;
    }
    @AuraEnabled(cacheable=true)
    public static Configuration__c getConfigurationPlan(String configId){
        Configuration__c configPlan =  [ SELECT Id,
                                                Name,
                                                Account__c,
                                                Opportunity__c,
                                                Quote__c,
                                                Contract__c,
                                                Order__c,
                                                Work_Order__c,
                                                Case__c
                                        FROM Configuration__c 
                                        WHERE Id =: configId
                                        LIMIT 1];
        System.debug('--- Configuration Plan: '+configPlan);
        return configPlan;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration__c> getConfigurationPlans(String recordId){
        List<Configuration__c> configPlans = [ SELECT Id,
                                                        Name,
                                                        Account__c,
                                                        Opportunity__c,
                                                        Quote__c,
                                                        Contract__c,
                                                        Order__c,
                                                        Work_Order__c,
                                                        Case__c
                                                FROM Configuration__c 
                                                WHERE Account__c =: recordId
                                                OR Opportunity__c =: recordId
                                                OR Quote__c =: recordId
                                                OR Contract__c =: recordId
                                                OR Order__c =: recordId
                                                OR Work_Order__c =: recordId
                                                OR Case__c =: recordId];
        System.debug('--- Found '+configPlans.size()+' Configuration Plan(s)');
        return configPlans;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Configuration_Product__c> getConfigurationProducts(List<String> configIds){
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        configProducts = [  SELECT  Id,
                                    Name,
                                    Quantity__c,
                                    Sales_Code__c,
                                    Product__c,
                                    Product_Group__c,
                                    Configuration__c,
                                    RVN_Number__c
                            FROM Configuration_Product__c 
                            WHERE Configuration__c IN: configIds];
        return configProducts;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration_Option__c> getConfigurationOptions(List<String> configProductIds){
        List<Configuration_Option__c> configOptions = new List<Configuration_Option__c>();
        configOptions = [   SELECT Id,
                                    Name,
                                    Quantity__c,
                                    Sales_Code__c,
                                    Product__c,
                                    Product__r.ProductCode,
                                    Product__r.Name,
                                    Product__r.Cost_Type__c,
                                    Product__r.QuantityUnitOfMeasure,
                                    Product_Group__c,
                                    Configuration_Product__c,
                                    RVN_Number__c
                            FROM Configuration_Option__c 
                            WHERE Configuration_Product__c IN: configProductIds];
        return configOptions;
    }   
    @AuraEnabled(cacheable=true)
    public static String getConfigurationObject(String recordId) {
        System.debug('--- Get Configuration Items');
        // Get all Plans for Record
        List<Configuration__c> cfgPlans= getConfigurationPlans(recordId);
        List<Id> cfgPlanIds = new List<Id>(new Map<Id, Configuration__c>(cfgPlans).keySet());
        // Get all Products for Each Plan
        List<Configuration_Product__c> cfgProducts = getConfigurationProducts(cfgPlanIds);
        List<Id> cfgProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cfgProducts).keySet());
        // Get all Items for Each Product
        List<Configuration_Option__c> cfgItems = getConfigurationOptions(cfgProductIds);
        List<Id> cfgItemIds = new List<Id>(new Map<Id, Configuration_Option__c>(cfgItems).keySet());
        System.debug('--- '+cfgItems.size()+' Configuration Item(s)');
        String itemJSON = JSON.serialize(cfgItems, true);
        // Get Configuration Items Summary
        List<sObject> cfgItemSummary =   [SELECT    Product_Group__c,
                                                    Product__r.Cost_Type__c,
                                                    Product__r.ProductCode,
                                                    Product__r.Name,
                                                    Product__r.Sales_Code__c,
                                                    Quantity__c,
                                                    Product__r.QuantityUnitOfMeasure
                                                FROM Configuration_Option__c
                                                WHERE Id IN : cfgItemIds];
        System.debug(JSON.serializePretty(cfgItemSummary));
        // Get Configuration Summary
        List<Object> cfgTableData =   [SELECT  Configuration__c,
                                                Configuration__r.Id,
                                                Configuration__r.Plan_Floor__c,
                                                Configuration__r.Plan_Apartment__c,
                                                Configuration__r.Visual_Id__c,
                                                RVN_Number__c,
                                                Name,
                                                Product__r.ProductCode,
                                                Product__r.Name,
                                                Product__r.Cost_Type__c,
                                                Product__r.QuantityUnitOfMeasure,
                                                Product_Group__c,
                                                (SELECT Product_Group__c,
                                                        Product__r.Cost_Type__c,
                                                        Product__r.ProductCode,
                                                        Product__r.Name,
                                                        Product__r.Sales_Code__c,
                                                        Quantity__c,
                                                        Product__r.QuantityUnitOfMeasure
                                                FROM Configuration_Options__r)
                                                Quantity__c,
                                                Features_Confirmed__c,
                                                Measurements_Verified__c,
                                                Visual_Product_Id__c,
                                                Inspection_Code__c,
                                                Product_Length__c,
                                                (SELECT Message_Key__c,
                                                        Space_Side_Number__c 
                                                FROM Configuration_Messages__r)
                                        FROM Configuration_Product__c WHERE Id IN : cfgPlanIds];
        System.debug(JSON.serializePretty(cfgTableData));
        ConfigurationItems configItemsObject = new ConfigurationItems ();// Parsed Result Object 
        System.debug('--- Configuration Item Object:  '+configItemsObject);
        return JSON.serialize(cfgItemSummary);
    }
    @AuraEnabled(cacheable=true)
    public static String getItemJSON(String recordId) {
        System.debug('--- Get Line Items');
        // Get all Plans for Record
        List<Configuration__c> cfgPlans= getConfigurationPlans(recordId);
        List<Id> cfgPlanIds = new List<Id>(new Map<Id, Configuration__c>(cfgPlans).keySet());
        // Get all Products for Each Plan
        List<Configuration_Product__c> cfgProducts = getConfigurationProducts(cfgPlanIds);
        List<Id> cfgProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cfgProducts).keySet());
        // Get all Items for Each Product
        List<Configuration_Option__c> cfgItems = getConfigurationOptions(cfgProductIds);
        List<Id> cfgItemIds = new List<Id>(new Map<Id, Configuration_Option__c>(cfgItems).keySet());
        System.debug('--- '+cfgItems.size()+' Configuration Item(s)');
        
        // Get Configuration Items Summary
        List<sObject> lineItems =   [SELECT    Product_Group__c,
                                                    Product__r.Cost_Type__c,
                                                    Product__r.ProductCode,
                                                    Product__r.Name,
                                                    Product__r.Sales_Code__c,
                                                    Quantity__c,
                                                    Product__r.QuantityUnitOfMeasure
                                                FROM Configuration_Option__c
                                                WHERE Id IN : cfgItemIds];
        System.debug('--- JSON: '+JSON.serializePretty(lineItems));
        String itemJSON=JSON.serialize(lineItems);
        System.debug('--- Configuration Item Object:  '+itemJSON);
        List<QuoteLineItem> quotelines = (List<QuoteLineItem>) JSON.deserialize(itemJSON,List<QuoteLineItem>.class);
        System.debug('--- QuoteLineItems:  '+quotelines);
        return itemJSON;
    }
    public class lineItemWrapper {
        List<QuoteLineItem> lineItems;
        
    }

}