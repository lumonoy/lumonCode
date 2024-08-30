/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationProcessorTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupProducts();
        LumonTestProducts.setupTestProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        LumonTestDataFactory.setupInstallationTimes();
        LumonTestDataFactory.setupProductionTimes();

        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        //LumonTestDataFactory.setupConfigurationProductsB2C();
        //LumonTestDataFactory.setupConfigurationOptionsB2C();       
        //LumonTestDataFactory.setupConfigurationMessagesB2C();

        // While custom settings data is included in sandbox copies, 
        // it is treated as data for the purposes of Apex test isolation. 
        // Apex tests must use SeeAllData=true to see existing custom settings data in the organization. 
        // As a best practice, create the required custom settings data in your test setup.
        LumonTestDataFactory.setupProductSettings();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    private static String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
    private static String soveliaPricingJSON = LumonTestConfigurations.soveliaPricingJSON;
    private static String testPricingJSON = LumonTestConfigurations.testPricingJSON;


    @IsTest
    static void processConfigurationVisualTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        Test.startTest();
        String visualConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting Visual Pricing JSON to be processed');
        System.debug('--- processConfigurationVisualTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationVisualTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationSoveliaTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        Test.startTest();
        String soveliaConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,soveliaPricingJSON);
        System.assertNotEquals(null, soveliaConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationSoveliaTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationSoveliaTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationPricingJSONTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        Test.startTest();
        String testConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,testPricingJSON);
        System.assertNotEquals(null, testConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationPricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationPricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}