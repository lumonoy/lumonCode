/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-16-2024
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
    static void getConfigurationPlanTest(){ 
        List<Configuration__c> configPlans = b2cConfigurations; 
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        Test.startTest();
        Configuration__c configurationPlan = ConfigurationPlanController.getConfigurationPlan(configPlans[0].ConfigurationNumber__c);
        System.assertNotEquals(null, configurationPlan.Id, 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlanTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlanTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getConfigurationPlanByNumberTest(){ 
        List<Configuration__c> configPlans = b2cConfigurations; 
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        Test.startTest();
        Configuration__c configurationPlan = ConfigurationPlanController.getConfigurationPlanByNumber(configIds[0]);
        System.assertNotEquals(null, configurationPlan.Id, 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlanTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlanTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getConfigurationPlansTest(){ 
        List<Configuration__c> configPlans = b2cConfigurations; 
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        Test.startTest();
        List<Configuration__c> configurationPlans = ConfigurationPlanController.getConfigurationPlans(configIds);
        System.assertNotEquals(0, configurationPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }      
}