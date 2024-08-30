/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class ConfigurationOptionControllerTest {
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
    private static Id b2cConfigurationPlanId = LumonTestDataFactory.b2cConfigurationPlanId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    @IsTest
    static void getConfigurationOptionTest(){
        Test.startTest();
        Configuration_Option__c configOption = ConfigurationOptionController.getConfigurationOption(b2cConfigurationPlanId);
        System.assertNotEquals(null, configOption, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getConfigurationOptionTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        List<Configuration_Product__c> configurationProducts =  b2cConfigProducts;
        List<Id> configurationProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configurationProducts).keySet()); 
        Test.startTest();
        List<Configuration_Option__c> configOptions = ConfigurationOptionController.getConfigurationOptions(configurationProductIds);
        System.assertNotEquals(0, configOptions.size(), 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getConfigurationOptionsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsByParentIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}