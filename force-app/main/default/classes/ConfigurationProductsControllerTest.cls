@IsTest
private class ConfigurationProductsControllerTest {
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;

    @TestSetup
    static void prepareData() {
        Test.startTest();
        AutomationBypass__c bypass = new AutomationBypass__c();
        bypass.SkipAutomation__c = true;
        insert bypass;
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
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