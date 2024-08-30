/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private with sharing class PricingExtraSalesControllerTest {
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;

    @TestSetup
    static void prepareData() {
        Test.startTest();
        LumonTestProducts.setupExtraSales();
        LumonTestPricebooks.setupPrices();
        LumonTestPriceParameters.setupPriceParameters();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
        LumonTestDataFactory.setupConfigurationB2C();
        //LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPricingSummaryB2C();
        Test.stopTest();
    }

    @IsTest
    static void getComponentDataTest() {
        Product2 product = [
            SELECT Id, Cost_Type__c, Product_Group__c, Product_Category__c, ProductCode
            FROM Product2
            WHERE Product_Group__c = 'LISAHIN'
            	AND Product_Category__c = 'Product Groups'
            LIMIT 1
        ];

        Test.startTest();
        PricingExtraSalesController.ComponentData data = PricingExtraSalesController.getComponentData(b2cOpportunityId);

        Assert.isNotNull(PricingExtraSalesController.findProduct(product.Id), 'There should be a product');
        PricingExtraSalesController.findPrices(data.opportunity.Id, product.Id, 1.0);

        Test.stopTest();
    }

    @IsTest
    static void saveExtraSalesTest() {
        Product2 product = [
            SELECT Id, Cost_Type__c, Product_Group__c, Product_Category__c, ProductCode
            FROM Product2
            WHERE Product_Group__c = 'LISAHIN'
            AND Product_Category__c = 'Product Groups'
            LIMIT 1
        ];
        
        Opportunity opportunity = OpportunityProductController.getOpportunityRecord(b2cOpportunityId);
        Id quoteId = opportunity.SyncedQuoteId;
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE Product2Id = :product.Id AND Pricebook2Id = :opportunity.PriceBook2Id LIMIT 1]?.Id;
        opportunity.StageName = 'Quoting';
        update opportunity;

        Test.startTest();
        PricingExtraSalesController.ComponentData data = PricingExtraSalesController.getComponentData(b2cOpportunityId);
        QuoteLineItem qli = new QuoteLineItem(
            Product_Cost__c = 1,
            Product2 = product,
            PriceBookEntryId = pbeId,
            QuoteId = quoteId,
            Quantity = 1.0,
            UnitPrice = 1.0
        );

        QuoteLineItem newQuoteLineItem = PricingExtraSalesController.saveItem(data.opportunity.Id, qli);
        Assert.areNotEqual(null, newQuoteLineItem.Id, 'Quote Line Item should have been created');
        PricingExtraSalesController.deleteItem(data.opportunity.Id, newQuoteLineItem.Id);
        Assert.areEqual(0, [SELECT Id FROM QuoteLineItem WHERE Id = :newQuoteLineItem.Id].size(),
            'Quote Line Item should have been deleted');
        Test.stopTest();
    }
}