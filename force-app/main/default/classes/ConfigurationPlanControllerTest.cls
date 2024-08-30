/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationPlanControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    @IsTest
    static void getConfigurationsByIdTest(){
        List<Configuration__c> configurationPlans = b2cConfigurations;
        Id configId = configurationPlans[0].Id;
        Id relatedRecordId = b2cOpportunityId;
        String planId = configurationPlans[0].Visual_Id__c;
        System.debug('--- getConfigurationsByIdTest - configId: '+configId);
        System.debug('--- getConfigurationsByIdTest - relatedRecordId: '+relatedRecordId); 
        System.debug('--- getConfigurationsByIdTest - planId: '+planId);  
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationPlans(configId,relatedRecordId,planId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    
    @IsTest
    static void getConfigurationPlansByIdsTest(){ 
        List<Configuration__c> configPlans = b2cConfigurations; 
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        Test.startTest();
        List<Configuration__c> configurationPlans = ConfigurationPlanController.getConfigurationPlansByIds(configIds);
        System.assertNotEquals(0, configurationPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByIdsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }     
            
    @IsTest
    static void getConfigurationsByRelatedIdTest(){
        List<Configuration__c> configurationPlans = b2cConfigurations;
        Id configId;
        Id relatedRecordId = b2cOpportunityId;
        String planId;
        System.debug('--- getConfigurationsByRelatedIdTest - configId: '+configId);
        System.debug('--- getConfigurationsByRelatedIdTest - relatedRecordId: '+relatedRecordId); 
        System.debug('--- getConfigurationsByRelatedIdTest - planId: '+planId);     
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationPlans(configId,relatedRecordId,planId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByRelatedIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByRelatedIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    
    @IsTest
    static void getVisualIdsToPlanMapTest(){
        List<Configuration__c> configurationPlans = b2cConfigurations;     
        Test.startTest();
        Map<String,Configuration__c> visualToPlanMap = ConfigurationPlanController.getVisualIdsToPlanMap(configurationPlans);
        System.assertNotEquals(null, visualToPlanMap, 'Expecting atleast 1 entry to be returned');
        System.debug('--- getVisualIdsToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualIdsToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getOpportunitiesToPlanMapTest(){
        List<Configuration__c> configurationPlans = b2cConfigurations;     
        Test.startTest();
        Map<Id,Configuration__c> oppToPlanMap = ConfigurationPlanController.getOpportunitiesToPlanMap(configurationPlans);
        System.assertNotEquals(null, oppToPlanMap, 'Expecting atleast 1 entry to be returned');
        System.debug('--- getOpportunitiesToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunitiesToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }     
    @IsTest
    static void getConfigurationsByPlanIdTest(){
        List<Configuration__c> configurationPlans = b2cConfigurations;
        Id configId;
        Id relatedRecordId;
        String planId = configurationPlans[0].Visual_Id__c;
        System.debug('--- getConfigurationsByRelatedIdTest - configId: '+configId);
        System.debug('--- getConfigurationsByRelatedIdTest - relatedRecordId: '+relatedRecordId); 
        System.debug('--- getConfigurationsByRelatedIdTest - planId: '+planId);     
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationPlans(configId,relatedRecordId,planId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByRelatedIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByRelatedIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
}