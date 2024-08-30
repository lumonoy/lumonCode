@IsTest
public with sharing class ConfigurationProductControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupConfigurationRecords();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
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
    static void getConfigurationProductTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        Test.startTest();
        Configuration_Product__c configProduct = ConfigurationProductController.getConfigurationProduct(configurationIds[0]);
        System.assertNotEquals(null, configProduct, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('*** getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('*** getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProducts(configurationIds);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('*** getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('*** getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}