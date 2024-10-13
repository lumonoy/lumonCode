/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationProcessorTest {
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
    static void processConfigurationVisualTest(){
        String recordId = b2cOpportunityId;
        String configPlanId = configurationPlanIds[0];
        Test.startTest();
        String visualConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting Visual Pricing JSON to be processed');
        System.debug('--- processConfigurationVisualTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationVisualTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationSoveliaTest(){
        String recordId = b2cOpportunityId;
        String configPlanId = configurationPlanIds[0];
        Test.startTest();
        String soveliaConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,soveliaPricingJSON);
        System.assertNotEquals(null, soveliaConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationSoveliaTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationSoveliaTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationPricingJSONTest(){
        String recordId = b2cOpportunityId;
        String configPlanId = configurationPlanIds[0];
        Test.startTest();
        String testConfigResult = ConfigurationProcessor.processConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, testConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationPricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationPricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}