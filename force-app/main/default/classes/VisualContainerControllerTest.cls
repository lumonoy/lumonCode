/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
 @IsTest
 private class VisualContainerControllerTest {
	@TestSetup
	static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
	private static Id b2cConfigurationPlanId =LumonTestDataFactory.b2cConfigurationPlanId;

     @IsTest
     static void getStartupParamsTest() {
         Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =: b2cOpportunityId LIMIT 1];
         opp.CloseDate = Date.today().addDays(1);
         opp.Delivery_Date__c = Date.today();
         opp.Terrain_Type__c = 'Terrain Class 0';
         update opp;
         String response;
         Test.startTest();
         response = VisualContainerController.getStartupParams(opp.Id);
         Test.stopTest();
         System.assert(response != null, 'Response should be returned');
     }

     @IsTest
     static void getStartupParamsFromConfigurationTest() {
         Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =: b2cOpportunityId LIMIT 1];
         opp.CloseDate = Date.today().addDays(1);
         opp.Delivery_Date__c = Date.today();
         opp.Terrain_Type__c = 'Terrain Class 0';
         update opp;
         String response;
         Test.startTest();
         response = VisualContainerController.getStartupParamsFromConfiguration(b2cConfigurationPlanId);
         Test.stopTest();
         System.assert(response != null, 'Response should be returned');
     }
 }