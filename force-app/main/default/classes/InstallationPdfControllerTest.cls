/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class InstallationPdfControllerTest {

    @TestSetup
    public static void setupData(){
        Test.startTest();
        LumonTestConfigurationFiles.setupConfigFiles();
        insert new WorkOrder(Subject = 'Work Order Test',
                Opportunity__c = [SELECT Id FROM Opportunity LIMIT 1].Id,
                AccountId = [SELECT Id FROM Account WHERE (IsPersonAccount = true) LIMIT 1].Id);
        Test.stopTest();

    }
    @IsTest
    static void getConfigurationProductsTest() {
        Test.startTest();
        List<Configuration_Product__c> configurationProducts =
                GenerateInstallerPdfController.getConfigurationProducts([SELECT Id FROM WorkOrder LIMIT 1].Id);
        System.assert(configurationProducts.size() > 0, 'Configuration products should be populated');
        Test.stopTest();
    }
}