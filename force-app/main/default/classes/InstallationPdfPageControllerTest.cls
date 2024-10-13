/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class InstallationPdfPageControllerTest {

    @TestSetup
    public static void setupData(){
        Test.startTest();
        //ConfigurationTestDataFactory.setupConfigurationRecords1();
        LumonTestConfigurationFiles.setupConfigFiles();
        insert new WorkOrder(Subject = 'Work Order Test',
                Opportunity__c = [SELECT Id FROM Opportunity LIMIT 1].Id,
                AccountId = [SELECT Id FROM Account WHERE (IsPersonAccount = true) LIMIT 1].Id);
        Test.stopTest();
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
        PageReference pdfPage = Page.InstallerPDF;
        Test.setCurrentPage(pdfPage);
        ApexPages.currentPage().getParameters().put('workorder-id',[SELECT Id FROM WorkOrder LIMIT 1].Id);
        System.assert(new InstallerPDFController().contents.size() > 0, 'Contents list should be populated');
        Test.stopTest();
    }
}