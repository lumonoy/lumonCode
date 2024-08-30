/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class PricingControllerTest {
        @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupProducts();
        LumonTestProducts.setupProducts('LG');
        //LumonTestProducts.setupProducts('LGS');
        //LumonTestProducts.setupProducts('LFIXEDWALL');
        //LumonTestProducts.setupProducts('VT3');
        //LumonTestProducts.setupProducts('VT4');    
        //LumonTestProducts.setupProducts('VISORBLINDSALES');
        //LumonTestProducts.setupSoveliaProducts();
        //LumonTestProducts.setupRetractableProducts();
        LumonTestPricebooks.setupPricebookEntries();
        LumonTestPriceParameters.setupPriceParameters();
        LumonTestInstallationTimes.setupInstallationTimes();
        LumonTestProductionTimes.setupProductionTimes();
        LumonTestConfigurations.setupConfigurationData();
        
        // B2C Setup
        /*LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();*/
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
    //private static String testPricingJSON = LumonTestConfigurations.testPricingJSON;
    @IsTest
    static void getPricingJSONTest(){
        String recordId = b2cOpportunityId;      
        Test.startTest();
        String pricingJSON = PricingController.getPricingJSON(recordId); 
        System.assertNotEquals(null, pricingJSON, 'A pricing JSON to be returned');
        System.debug('--- getPricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPricingSummaryTest(){
        String opportunityId = b2cOpportunityId;
     	Id summaryId = LumonTestPricingSummaries.setupPricingSummaryB2C(opportunityId);
        System.debug('--- getPricingSummaryTest - Summary: '+summaryId); 
        Test.startTest();
        Pricing_Summary__c summary = PricingController.getPricingSummary(opportunityId); 
        System.assertNotEquals(null, summary, 'A pricing Summary to be returned');
        System.debug('--- getPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void upsertPricingSummaryTest(){
        String opportunityId = b2cOpportunityId;
        Id summaryId = LumonTestPricingSummaries.setupPricingSummaryB2C(opportunityId);
        System.debug('--- getPricingSummaryTest - Summary: '+summaryId); 
        Test.startTest();
        Pricing_Summary__c summary = PricingController.upsertPricingSummary(opportunityId); 
        System.assertNotEquals(null, summary, 'A pricing Summary to be updated');
        System.debug('--- upsertPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- upsertPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    @IsTest
    static void getConfigurationsByIdTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        System.debug('--- getConfigurationsByIdTest - configurationIds: '+configurationIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsById(configurationIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getFactoryPricesConsumerTest(){
        Opportunity opp = [SELECT Id,AccountId, SyncedQuoteId,
                                  Organization__c,Business_Type__c ,
                           			Country_Attribute__c,District__c,
                           			OwnerId, Owner_Profit_Center__c, Owner_Office__c
                          FROM Opportunity WHERE Id =:b2cOpportunityId LIMIT 1];
        Id accountId = opp.AccountId;
        Id quoteId = opp.SyncedQuoteId;
        Id owner = opp.OwnerId;
        String org = opp.Organization__c;
        String business = opp.Business_Type__c;
        String district = opp.District__c;
        String country = district.left(2);
        String profit = opp.Owner_Profit_Center__c;
        String office = opp.Owner_Office__c;
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        
        Test.startTest();
        System.Debug('--- getFactoryPricesConsumerTest - Opportunity '+opp);
        System.Debug('--- getFactoryPricesConsumerTest - factory '+[SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Factory_Multiplier__c,
                                    IsActive__c
                            FROM Factory_Price__c]);
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = PricingParameterController.getFactoryPrices(products,org,country,business); 
        System.assertNotEquals(0, factoryPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- getFactoryPricesConsumerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getFactoryPricesConsumerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductCostsConsumerTest(){
        Opportunity opp = [SELECT Id,AccountId, SyncedQuoteId,
                                  Organization__c,Business_Type__c ,
                           			Country_Attribute__c,District__c,
                           			OwnerId, Owner_Profit_Center__c, Owner_Office__c
                          FROM Opportunity WHERE Id =:b2cOpportunityId LIMIT 1];
        Id accountId = opp.AccountId;
        Id quoteId = opp.SyncedQuoteId;
        Id owner = opp.OwnerId;
        String org = opp.Organization__c;
        String business = opp.Business_Type__c;
        String district = opp.District__c;
        String country = district.left(2);
        String profit = opp.Owner_Profit_Center__c;
        String office = opp.Owner_Office__c;
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        System.Debug('--- getProductCostsConsumerTest - Opportunity '+opp);
        System.Debug('--- getProductCostsConsumerTest - Cost '+[SELECT Id,
                                    Organization__c,
                                    Country__c,
                                    Business_Type__c,
                                    Product_Group__c,
                                    Cost_Type__c,
                                    Cost_Multiplier__c,
                                    IsActive__c
                            FROM Product_Cost__c]);
        Test.startTest();
        Map<String,Map<String,Product_Cost__c>> productCostMap = PricingParameterController.getProductCosts(products,org,country,business,district); 
        System.assertNotEquals(0, productCostMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- getProductCostsConsumerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductCostsConsumerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    //Tested in PricingParameterControllerTest
    /*@IsTest
    static void getSalesPriceConsumerTest(){
        Opportunity opp = [SELECT Id,AccountId, SyncedQuoteId,
                                  Organization__c,Business_Type__c ,
                           			Country_Attribute__c,District__c,
                           			OwnerId, Owner_Profit_Center__c, Owner_Office__c
                          FROM Opportunity WHERE Id =:b2cOpportunityId LIMIT 1];
        Id accountId = opp.AccountId;
        Id quoteId = opp.SyncedQuoteId;
        Id owner = opp.OwnerId;
        String org = opp.Organization__c;
        String business = opp.Business_Type__c;
        String district = opp.District__c;
        String country = opp.Country_Attribute__c;
        String profit = '';
        String office ='';
        String customer = '';
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        Test.startTest();
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = PricingParameterController.getSalesPrices(products,org,country,business,district,profit,customer); 
        System.assertNotEquals(0, salesPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- getSalesPriceConsumerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getSalesPriceConsumerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void insertQuoteLinesOpptyTest(){
        String recordId = b2cOpportunityId;
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        Test.startTest();
    		String upsertResult = PricingController.upsertQuoteLines(recordId); 
    		System.assertNotEquals(FALSE, String.isNotBlank(upsertResult), 'Expecting a result');
    		System.debug('--- insertQuoteLinesOpptyTest - CPU TIME: '+LIMITS.getCpuTime()); 
    		System.debug('--- insertQuoteLinesOpptyTest - SOQL USED: ' + LIMITS.getQueries());
    	Test.stopTest();
    }*/
    @IsTest
    static void updateQuoteLinesOpptyTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        String pricingJSON = LumonTestConfigurations.retractablePricing;
        String visualConfigResult = ConfigurationController.processVisualConfiguration(configPlanId,recordId,pricingJSON);
    	/*List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        List<PriceBookEntry> pricebookEntries = [SELECT Id,Product2Id FROM PricebookEntry];
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            QuoteLineItem qli = new QuoteLineItem(QuoteId=b2cSyncedQuoteId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;*/   
        List<PriceBookEntry> pricebookEntries = [SELECT Id,Product2Id FROM PricebookEntry];
        List<QuoteLineItem> quoteLineItems = [SELECT Id,Product2Id FROM QuoteLineItem];
        System.debug('--- updateQuoteLinesOpptyTest - PBE Count: '+pricebookEntries.size()); 
    	System.debug('--- updateQuoteLinesOpptyTest - QLI Count: ' + quoteLineItems.size());
        Test.startTest();
    		String upsertResult = PricingController.upsertQuoteLines(recordId); 
    		System.assertNotEquals(FALSE, String.isNotBlank(upsertResult), 'Expecting a result');
    		System.debug('--- updateQuoteLinesOpptyTest - CPU TIME: '+LIMITS.getCpuTime()); 
    		System.debug('--- updateQuoteLinesOpptyTest - SOQL USED: ' + LIMITS.getQueries());
    	Test.stopTest();
     }
    @IsTest
    static void upsertQuoteLinesQuoteTest(){
        String recordId = b2cOpportunityId;
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
		String quoteId = [SELECT Id FROM Quote WHERE IsSyncing = True AND OpportunityId =:b2cOpportunityId]?.Id;        
        Test.startTest();
            String configId = String.valueOf(configurationIds[0]);
			System.debug('----upsertQuoteLinesQuoteTest - configId: '+configId);
            String upsertResult = PricingController.upsertQuoteLines(quoteId); 
            System.assertNotEquals(FALSE, String.isNotBlank(upsertResult), 'Expecting a result');
            System.debug('----upsertQuoteLinesQuoteTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('----upsertQuoteLinesQuoteTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
     }
    
    @IsTest
    static void setOrderSpecificPricesTest() {
        List<QuoteLineItem> items = new List<QuoteLineItem> {
            new QuoteLineItem(Max_Quantity__c = 1, Sales_Code__c = 'a', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 1, Sales_Code__c = 'a', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 1, Sales_Code__c = 'b', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 1, Sales_Code__c = 'b', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 2, Sales_Code__c = 'c', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 2, Sales_Code__c = 'c', Base_Price__c = 1),
            new QuoteLineItem(Max_Quantity__c = 2, Sales_Code__c = 'c', Base_Price__c = 1),
            new QuoteLineItem(Sales_Code__c = 'd', Base_Price__c = 1)
        };

        Test.startTest();
        PricingController.setOrderSpecificPrices(items);
        Assert.areEqual(1, items.get(0).Base_Price__c, 'First a price should remain');
        Assert.areEqual(0, items.get(1).Base_Price__c, 'Second a price should be 0');
        Assert.areEqual(1, items.get(2).Base_Price__c, 'First b price should remain');
        Assert.areEqual(0, items.get(3).Base_Price__c, 'Second b price should be 0');
        Assert.areEqual(1, items.get(4).Base_Price__c, 'First c price should remain');
        Assert.areEqual(1, items.get(5).Base_Price__c, 'Second c price should remain');
        Assert.areEqual(0, items.get(6).Base_Price__c, 'Third c price should be 0');
        Assert.areEqual(1, items.get(7).Base_Price__c, 'First d price should remain');
        Test.stopTest();
    } 

    @IsTest
    static void pricingAfterContractSentTest() {
        List<QuoteLineItem> items = new List<QuoteLineItem>{
            new QuoteLineItem(
                Quantity = 1.0,
                UnitPrice = 150.0,
                List_Price__c = 200.0,
                Discount__c = 0.0,
                Sales_Multiplier__c = 1.0
            ),
            new QuoteLineItem(
                Quantity = 1.0,
                UnitPrice = 150.0,
                List_Price__c = 200.0,
                Discount__c = 0.0,
                Sales_Multiplier__c = 1.0
            )
        };
        Test.startTest();
        Pricing_Summary__c summary = new Pricing_Summary__c(Sales_Price__c = 280);
        PricingController.recalculateDiscountOrSalesprice(true, summary, items);
        Assert.areEqual(30.0, items.get(0).Discount__c);
        Assert.areEqual(30.0, items.get(1).Discount__c);
        PricingController.recalculateDiscountOrSalesprice(false, summary, items);
        Assert.areEqual(140.0, items.get(0).UnitPrice);
        Assert.areEqual(140.0, items.get(1).UnitPrice);
        Test.stopTest();
    }
    @IsTest
    public static void QuotingManagerTriggeredTest() {
        String errorMessage;
        String configId;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Configure';
        String configType = 'Configurator';        
        String visualPlanId;
        String documentId;
        String visualPricingJSON;
        String configJSON = LumonTestConfigurations.visualPricingJSON;
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, visualPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('*** QuotingManagerTriggeredTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Visual Plan');
        System.debug('*** QuotingManagerTriggeredTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('*** QuotingManagerTriggeredTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
}