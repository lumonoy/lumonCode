@IsTest
private class PricingPaymentInstallmentsControllerTest {
    @TestSetup
    static void prepareData() {
        Test.startTest();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();
        Test.stopTest();
    }

    @IsTest
    static void saveAdditionalCostInsertTest() {
        Test.startTest();
        Assert.areNotEqual(
            null,
            PricingPaymentInstallmentsController.getComponentData(LumonTestDataFactory.b2cOpportunityId),
            'Data should have been returned'
        );
        Test.stopTest();
    }
}