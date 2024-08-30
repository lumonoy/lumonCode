/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
@isTest
private class SoveliaContainerControllerTest {
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

    @isTest
    private static void testGetRVN() {
        Test.startTest();
        Assert.areEqual(
            0,
            [SELECT COUNT() FROM Configuration_Product__c WHERE Configuration__r.Opportunity__c = :b2cOpportunityId],
            'There should be no configuration products yet'
        );
        SoveliaContainerController.getRVN(b2cOpportunityId);
        List<Configuration_Product__c> configurationProducts = [
            SELECT Id
            FROM Configuration_Product__c
            WHERE Configuration__r.Opportunity__c = :b2cOpportunityId
        ];
        Assert.areEqual(1, configurationProducts.size(), 'There should be configuration products');

        SoveliaContainerController.getRVN(configurationProducts.get(0).Id);
        configurationProducts = [
            SELECT Id
            FROM Configuration_Product__c
            WHERE Configuration__r.Opportunity__c = :b2cOpportunityId
        ];
        Assert.areEqual(
            1,
            configurationProducts.size(),
            'There should be still the same amount of configuration products'
        );
        Test.stopTest();
    }
}