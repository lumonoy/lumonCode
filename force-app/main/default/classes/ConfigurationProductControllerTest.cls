/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ConfigurationProductControllerTest {
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
    static void getConfigurationProductTest(){
        Test.startTest();
        Configuration_Product__c configProduct = ConfigurationProductController.getConfigurationProduct(configurationPlanIds[0]);
        System.assertNotEquals(null, configProduct, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('*** getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('*** getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsTest(){
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProducts(configurationPlanIds);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('*** getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('*** getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}