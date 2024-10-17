/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationPlanControllerTest {
    public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static Id b2bOpportunityId = LumonTestVariables.b2cOpportunityId;
    
	private static List<Id> configurationPlanIds = LumonTestVariables.configurationPlanIds;
    private static List<Id> configurationProductIds = LumonTestVariables.configurationProductIds;
    private static List<Id> configurationOptionIds = LumonTestVariables.configurationOptionIds;

    private static List<Configuration__c> configurationPlans = LumonTestVariables.configurationPlans;
    private static List<Configuration_Product__c> configurationProducts = LumonTestVariables.configurationProducts;
    private static List<Configuration_Option__c> configurationOptions = LumonTestVariables.configurationOptions;
    private static List<Configuration_Message__c> configurationMessages = LumonTestVariables.configurationMessages;
    private static String visualPricingJSON = LumonTestData.visualPricing;
    private static String soveliaPricingJSON = LumonTestData.soveliaPricing;
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        LumonTestDataFactory.setupConfigurations();
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByIdTest(){
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
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationPlansByIds(configurationPlanIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByIdsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }     
            
    @IsTest
    static void getConfigurationsByRelatedIdTest(){
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
        Test.startTest();
        Map<String,Configuration__c> visualToPlanMap = ConfigurationPlanController.getVisualIdsToPlanMap(configurationPlans);
        System.assertNotEquals(null, visualToPlanMap, 'Expecting atleast 1 entry to be returned');
        System.debug('--- getVisualIdsToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualIdsToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getOpportunitiesToPlanMapTest(){  
        Test.startTest();
        Map<Id,Configuration__c> oppToPlanMap = ConfigurationPlanController.getOpportunitiesToPlanMap(configurationPlans);
        System.assertNotEquals(null, oppToPlanMap, 'Expecting atleast 1 entry to be returned');
        System.debug('--- getOpportunitiesToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunitiesToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }     
    @IsTest
    static void getConfigurationsByPlanIdTest(){
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