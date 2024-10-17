/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ConfigurationProductsControllerTest {
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
    static void getComponentDataTest() {
        Opportunity opportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :b2cOpportunityId LIMIT 1];
        opportunity.StageName = 'Quoting';
        update opportunity;
        Configuration__c configurationPlan = new Configuration__c(Opportunity__c = b2cOpportunityId);
        insert configurationPlan;
        Configuration_Product__c configurationProduct = new Configuration_Product__c(
            Configuration__c = configurationPlan.Id,
            Quantity__c = 1
        );
        insert configurationProduct;

        Test.startTest();
        ConfigurationProductsController.ComponentData data = ConfigurationProductsController.getComponentData(
            b2cOpportunityId
        );
        Assert.isNotNull(data);
        try {
            ConfigurationProductsController.caseOpportunityId(b2cOpportunityId);
        } catch (Exception e) {
            Assert.isTrue(true, 'This should have failed as the case doesn\'t exist');
        }
        List<Id> configurationProductIds = new List<Id>{ configurationProduct.Id };
        ConfigurationProductsController.deleteConfigurationProducts(configurationProductIds);
        Assert.areEqual(
            0,
            [SELECT Id FROM Configuration_Product__c WHERE Id IN :configurationProductIds].size(),
            'All configuration products should have been deleted'
        );
        Test.stopTest();
    }
}