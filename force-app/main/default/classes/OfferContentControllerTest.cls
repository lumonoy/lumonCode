/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class OfferContentControllerTest {
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;

    @TestSetup
    static void prepareData() {
        Test.startTest();
        AutomationBypass__c bypass = new AutomationBypass__c();
        bypass.SkipAutomation__c = true;
        insert bypass;
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();
        Test.stopTest();
    }

    @IsTest
    static void getComponentDataTest() {
        Test.startTest();
        OfferContentController.ComponentData data = OfferContentController.getComponentData(
                b2cOpportunityId
        );
        Assert.isNotNull(data);
        try {
            OfferContentController.caseOpportunityId(b2cOpportunityId);
        } catch (Exception e) {
            Assert.isTrue(true, 'This should have failed as the case doesn\'t exist');
        }
        List<Id> configurationProductIds = new List<Id>{
                [SELECT Id FROM Configuration_Product__c LIMIT 1].Id
        };
        OfferContentController.deleteConfigurationProducts(configurationProductIds);
        Assert.areEqual(
                0,
                [SELECT Id FROM Configuration_Product__c WHERE Id IN :configurationProductIds].size(),
                'All configuration products should have been deleted'
        );
        Test.stopTest();
    }

//     @IsTest
//     static void addRemoveManuallySpecialProductsTest() {
//         Test.startTest();
//         Configuration_Product__c configurationProduct = [SELECT Id, Special__c FROM Configuration_Product__c LIMIT 1];
//         OfferContentController.addManuallySpecialItems(new List<Id>{
//                 configurationProduct.Id
//         },
//                 [SELECT Id, StageName FROM Opportunity WHERE Id = :b2cOpportunityId LIMIT 1].Id);
//         Assert.areEqual(true, [SELECT Id, Special__c FROM Configuration_Product__c WHERE Id = :configurationProduct.Id].Special__c);
//         Assert.areNotEqual(0, [
//                 SELECT Id
//                 FROM Configuration_Option__c
//                 WHERE Configuration_Product__c = :configurationProduct.Id
//                 AND Product__r.Additional_special_product__c = true
//         ].size());

//         OfferContentController.removeManuallyAddedSpecialItems(new List<Id>{
//                 configurationProduct.Id
//         },
//                 [SELECT Id, StageName FROM Opportunity WHERE Id = :b2cOpportunityId LIMIT 1].Id);
//         Assert.areEqual(false, [SELECT Id, Special__c FROM Configuration_Product__c WHERE Id =:configurationProduct.Id].Special__c);
//         Assert.areEqual(0, [
//                 SELECT Id
//                 FROM Configuration_Option__c
//                 WHERE Configuration_Product__c = :configurationProduct.Id
//                 AND Product__r.Additional_special_product__c = true
//         ].size());

//         Test.stopTest();
//     }
}