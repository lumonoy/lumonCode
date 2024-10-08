/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class BlindInstructionPdfControllerTest {
    
    @TestSetup
    public static void setupData(){
        Test.startTest();
        LumonTestConfigurationFiles.setupConfigFiles();
        WorkOrder wrkOrderRec= new WorkOrder(Subject = 'Work Order Test',
                                             Opportunity__c = [SELECT Id FROM Opportunity LIMIT 1].Id,
                                             AccountId = [SELECT Id FROM Account WHERE (IsPersonAccount = true) LIMIT 1].Id);
        insert wrkOrderRec;
        // creating Configuration plan
        Configuration__c b2cConfigPlan1 = new Configuration__c(
            Opportunity__c = LumonTestDataFactory.b2cOpportunityId,
            Name='B2C Configuration 1',
            Plan_Apartment__c = 'C1',
            Plan_Floor__c = '6',
            Visual_Id__c = 'B2C-ABCDE1',
            Plan_Line__c = '100',
            Plan_Name__c = 'B2C Plan 1',
            Plan_Type__c = 'Blinds',
            Visual_Version__c = 1);
        insert b2cConfigPlan1;
        // creating product
        Product2 p1 = new Product2(Name='Test Product 1 Installation', IsActive=True,ProductCode='LG',Product_Group__c='LG',Product_Category__c='Product Groups',Installation__c = true,Configurator__c = 'Sovelia');
        insert P1;
        // creating Configuration Product
        Configuration_Product__c configProduct = new Configuration_Product__c(
            Name='productGroup',  
            Configuration__c = b2cConfigPlan1.Id,  
            Quantity__c = 1,
            Product__c = p1.Id,
            Features_Confirmed__c = False, 
            Measurements_Verified__c = False, 
            Visual_Product_Id__c ='ddd' , 
            Inspection_Code__c = 2, 
            Product_Length__c = 2.5,  
            RVN_Number__c = '123456'); 
        insert configProduct;
        
        // creating WorkOrderLineItem
        WorkOrderLineItem woli = new WorkOrderLineItem(Configuration_Product__c = configProduct.Id, WorkOrderId = wrkOrderRec.Id, Install_Expense__c = null, RVN_Number__c = '123456', Installed_By__c = UserInfo.getUserId());
        insert woli;
        // creating Configuration Side
        Configuration_Side__c blindsSide = new Configuration_Side__c();
        blindsSide.Configuration_Product__c = configProduct.Id;
        blindsSide.Side_Number__c =1;
        insert blindsSide;
        // creating Configuration Side pane
        Configuration_Side_Pane__c blindsSidePane = new Configuration_Side_Pane__c();
        blindsSidePane.Blind_Id__c  = 'TEST BLIND';
        blindsSidePane.Blinds_Color__c = 'Valkoinen läpinäkyvä 3501';
        blindsSidePane.Blinds_Profile_Color__c = 'RAL9010';
        blindsSidePane.Glass_Number__c = 14;
        blindsSidePane.Height__c = 4000;
        blindsSidePane.Width__c =232;
        blindsSidePane.Configuration_Side__c = blindsSide.Id;
        insert blindsSidePane;
        Test.stopTest();
    }  
    
    @IsTest
    static void constructorTest() {
        Test.startTest();
        PageReference pdfPage = Page.GenerateConfigurationProductPdf;
        Test.setCurrentPage(pdfPage);
        Id workOrderRecId = [SELECT Id FROM WorkOrder LIMIT 1].Id;
        ApexPages.currentPage().getParameters().put('workorderId',workOrderRecId);
        BlindInstructionPdfController blindDataController= new BlindInstructionPdfController();
        system.assert(BlindInstructionPdfController.blindsData.size() > 0);
        BlindInstructionPdfController.checkBlindsData(workOrderRecId);
        Test.stopTest();
    }
}