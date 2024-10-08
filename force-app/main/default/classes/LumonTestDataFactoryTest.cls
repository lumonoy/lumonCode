@IsTest(isParallel=false)
public with sharing class LumonTestDataFactoryTest {
    @IsTest
    static void setupProductsTest(){
        try{
            LumonTestDataFactory.setupProductSettings();
            LumonTestDataFactory.setupProducts();
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.products?.size()+ ' Products ');
        System.AssertNotEquals(0,LumonTestDataFactory.products?.size());
    }
    @IsTest
    static void setupPricesTest(){
        try{
            LumonTestDataFactory.setupProductSettings();
            LumonTestDataFactory.setupProducts();
            LumonTestDataFactory.setupPriceBooks();
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.pricebookEntries?.size()+ ' Pricebook Entries');
        System.AssertNotEquals(0,LumonTestDataFactory.pricebookEntries?.size());
    }
    @IsTest
    static void setupPriceMultipliersTest(){
        try{
            LumonTestDataFactory.setupProductSettings();
            LumonTestDataFactory.setupProducts();
            LumonTestDataFactory.setupPriceBooks();
            LumonTestDataFactory.setupPriceMultipliers();
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.factoryMultipliers?.size()+ ' Factory Multipliers');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.costMultipliers?.size()+ ' Cost Multipliers');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.priceMultipliers?.size()+ ' Price Multipliers');
        System.AssertNotEquals(0,LumonTestDataFactory.factoryMultipliers?.size());
        System.AssertNotEquals(0,LumonTestDataFactory.costMultipliers?.size());
        System.AssertNotEquals(0,LumonTestDataFactory.priceMultipliers?.size());
    }
    @IsTest
    static void setupOpportunityB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        Test.starttest();
        try{
            LumonTestDataFactory.setupOpportunityB2C();  
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        //System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Quote');
        System.AssertNotEquals(null,LumonTestDataFactory.b2cOpportunityId);

    }       
    @IsTest
    static void setupQuoteB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        Test.starttest();
        try{
        	LumonTestDataFactory.setupQuoteB2C();
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cQuoteId+ ' Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Synced Quote');
        System.AssertNotEquals(null,LumonTestDataFactory.b2cQuoteId);
    } 
    @IsTest
    static void setupSyncedQuoteB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        LumonTestDataFactory.setupQuoteB2C();
        Test.starttest();
        try{
        	LumonTestDataFactory.setupSyncedQuoteB2C();
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cQuoteId+ ' Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Synced Quote');
        System.AssertNotEquals(null,LumonTestDataFactory.b2cSyncedQuoteId);
    } 
    @IsTest
    static void setupPricingSummaryB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        LumonTestDataFactory.setupQuoteB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
        Test.starttest();
        try{
            LumonTestDataFactory.setupPricingSummaryB2C(); 
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cQuoteId+ ' Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Synced Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cPricingSummary+ ' Pricing Summary');
        System.AssertNotEquals(null,LumonTestDataFactory.b2cPricingSummary);
    } 
    @IsTest
    static void setupConfigurationB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        LumonTestDataFactory.setupQuoteB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
        LumonTestDataFactory.setupPricingSummaryB2C(); 
        Test.starttest();
        try{
            LumonTestDataFactory.setupConfigurationB2C(); 
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cQuoteId+ ' Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Synced Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cPricingSummary+ ' Pricing Summary');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cConfiguration+ ' Configuration Plan');
        System.AssertNotEquals(null,LumonTestDataFactory.b2cConfiguration);
    } 
    @IsTest
    static void setupConfigurationProductsB2CTest(){
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        LumonTestDataFactory.setupQuoteB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
        LumonTestDataFactory.setupPricingSummaryB2C(); 
        LumonTestDataFactory.setupConfigurationB2C(); 
        Test.starttest();
        try{
            LumonTestDataFactory.setupConfigurationProductsB2C(); 
        } catch (Exception e){
            System.debug('-- LumonTestDataFactoryTest - Error Occured: '+e.getMessage()); 
        }
		System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cAccountId+ ' Account');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cOpportunityId+ ' Opportunity');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cQuoteId+ ' Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cSyncedQuoteId+ ' Synced Quote');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cPricingSummary+ ' Pricing Summary');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cConfiguration+ ' Configuration Plan');
        System.Debug('-- LumonTestDataFactoryTest - Inserted '+ LumonTestDataFactory.b2cConfigProducts?.size()+ ' Configuration Products');
        System.AssertNotEquals(0,LumonTestDataFactory.b2cConfigProducts?.size());
    } 
    @IsTest
    static void setupSalesObjectsB2CTest(){
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBooks();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupQuoteB2C();  
        LumonTestDataFactory.setupSyncedQuoteB2C();    
        LumonTestDataFactory.setupConfigurations();
        LumonTestDataFactory.setupConfigurationProducts();
        LumonTestDataFactory.setupConfigurationOptions();
        //LumonTestDataFactory.setupConfigurationMessages();   
        LumonTestDataFactory.setupPriceMultipliers();
        LumonTestDataFactory.setupPricingSummaryB2C(); 
        //LumonTestDataFactory.setupVisualImageDocument();
        //LumonTestDataFactory.setupVisualPricingDocument();
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
    static void getAutomatedTestUser(){
        Id userProfile = userinfo.getProfileId();
		Id userId = userinfo.getUserId();
        User automatedTestUser = [SELECT Name FROM User WHERE Id =: userId LIMIT 1];
        System.Debug('--- LumonTestData - User: '+automatedTestUser);
    }
    
}