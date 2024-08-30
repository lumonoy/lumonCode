@IsTest(isParallel=false)
public with sharing class LumonTestDataFactoryTest {
    @IsTest
    static void setupSalesObjectsB2CTest(){
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupQuoteB2C();  
        LumonTestDataFactory.setupSyncedQuoteB2C();    
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();
        LumonTestDataFactory.setupConfigurationMessagesB2C();   
        LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPricingSummaryB2C(); 
        LumonTestDataFactory.setupVisualImageDocument();
        LumonTestDataFactory.setupVisualPricingDocument();
        Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
        Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
        Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
        Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
        Id b2cConfigurationPlanId = LumonTestDataFactory.b2cConfigurationPlanId;
        List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
        List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
        List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
        List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    }
    @IsTest
    static void setupAccountB2CTest(){
        LumonTestDataFactory.setupAccountB2C();
    }
    @IsTest
    static void setupOpportunityB2CTest(){
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
    }
    @IsTest
    static void setupSyncedQuoteB2CTest(){
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
    }
}