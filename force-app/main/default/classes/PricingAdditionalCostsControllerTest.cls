/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class PricingAdditionalCostsControllerTest {
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;

    @TestSetup
    static void prepareData() {
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();

        LumonTestDataFactory.setupAdditionalCosts();
        LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPricingSummaryB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();

        LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();

        Test.stopTest();
    }

    @IsTest
    static void saveAdditionalCostInsertTest() {
        PricingAdditionalCostsController.ComponentData data = PricingAdditionalCostsController.getComponentData(
            LumonTestDataFactory.b2cOpportunityId
        );
        String pricebookId = data.opportunity.pricebook2Id;
        String itemCostType = data.picklistValues.get('Cost_Type__c').get(0).value;

        Product2 Product = [
            SELECT Id, Product_Category__c, Cost_Type__c, Product_Group__c, ProductCode
            FROM Product2
            WHERE Cost_Type__c = :itemCostType
            AND Product2.Product_Category__c = :PricingAdditionalCostsController.ADDITIONAL_COST_PRODUCT_CATEGORY
            LIMIT 1
        ];
        PricingAdditionalCostsController.findProduct(
            LumonTestDataFactory.b2cOpportunityId,
            product.Product_Group__c,
            product.Cost_Type__c
        );
        PricebookEntry productEntry = [
            SELECT Id, Product2Id
            FROM PricebookEntry
            WHERE Product2Id = :product.Id AND Pricebook2Id = :pricebookId
            LIMIT 1
        ];

        Configuration__c configuration = new Configuration__c(
            Opportunity__c = LumonTestDataFactory.b2cOpportunityId
        );
        insert configuration;
        Configuration_Product__c configurationProduct = new Configuration_Product__c(
            Configuration__c = configuration.Id,
            Product_Group__c = product.Product_Group__c,
            Quantity__c = 1
        );
        insert configurationProduct;

        Test.startTest();
        //PricingAdditionalCostsController.ComponentData data = PricingAdditionalCostsController.getComponentData(b2cOpportunityId);
        QuoteLineItem qli = new QuoteLineItem(
            Product_Cost__c = 1,
            PricebookEntryId = productEntry.Id,
            Product2Id = product.Id,
            Quantity = 1,
            UnitPrice = 1.0,
            Configuration_Product__c = configurationProduct.Id,
            Line_Number__c = 0,
            QuoteId = null,
            Max_Quantity__c = 1,
            Sales_Code__c = '',
            RVN_Number__c = ''
        );
        PricingAdditionalCostsController.saveAdditionalCost(data.opportunity.Id, qli, qli);
        Test.stopTest();

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM QuoteLineItem
                WHERE Configuration_Product__c = :configurationProduct.Id
            ],
            'Quote Line Item should have been created'
        );
    }

    @IsTest
    static void deleteItemTest() {
        Product2 costProduct = [SELECT Id FROM Product2 WHERE ProductCode = 'INSURANCE' LIMIT 1];
        QuoteLineItem deleteItem = [SELECT Id FROM QuoteLineItem WHERE Product2Id = :costProduct.Id LIMIT 1];
        Test.startTest();
        PricingAdditionalCostsController.deleteAdditionalCost(LumonTestDataFactory.b2cOpportunityId, deleteItem.Id);
        List<QuoteLineItem> deletedItems = new List<QuoteLineItem>(
            [SELECT Id FROM QuoteLineItem WHERE Product2Id = :costProduct.Id AND Configuration_Product__c != NULL]
        );
        System.assertEquals(0, deletedItems.size(), 'No more Items expected to be returned');
        Test.stopTest();
    }
}