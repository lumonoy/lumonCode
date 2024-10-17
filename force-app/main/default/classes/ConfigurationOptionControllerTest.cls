/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class ConfigurationOptionControllerTest {
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
    static void getConfigurationOptionTest(){
        Test.startTest();
        Configuration_Option__c configOption = ConfigurationOptionController.getConfigurationOption(configurationPlanIds[0]);
        System.assertNotEquals(null, configOption, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getConfigurationOptionTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsTest(){
        Test.startTest();
        List<Configuration_Option__c> configOptions = ConfigurationOptionController.getConfigurationOptions(configurationProductIds);
        System.assertNotEquals(0, configOptions.size(), 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getConfigurationOptionsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsByParentIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}