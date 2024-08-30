/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
 private class OrderGeneratorTest {
     @testSetup static void prepareData() {
         Test.startTest();
         LumonTestDataFactory.setupProducts();
         LumonTestDataFactory.setupPriceBookEntries();
         // B2C Setup
         LumonTestDataFactory.setupAccountB2C();
         LumonTestDataFactory.setupOpportunityB2C();
         LumonTestDataFactory.setupPriceParameters();
         LumonTestDataFactory.setupPricingSummaryB2C();
         LumonTestDataFactory.setupConfigurationB2C();
         LumonTestDataFactory.setupConfigurationProductsB2C();
         LumonTestDataFactory.setupConfigurationOptionsB2C();       
         LumonTestDataFactory.setupConfigurationMessagesB2C(); 
         LumonTestDataFactory.setupSyncedQuoteB2C();
         LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();
         LumonTestDataFactory.setupContractB2C();
         LumonTestDataFactory.setupOrderB2C();
         LumonTestDataFactory.setupContentFiles();
         
         String body = '{"status": "OK","statusCode":"200"}';
         MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
         Test.setMock(HttpCalloutMock.class, mockResp);
         Test.stopTest();
         System.debug('---  OrderGeneratorTest - setupOpptTestData CPU TIME: '+LIMITS.getCpuTime());      
     }  
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cContractId = LumonTestDataFactory.b2cContractId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    private static String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
    private static String soveliaPricingJSON = LumonTestConfigurations.soveliaPricingJSON;
    private static String testPricingJSON = LumonTestConfigurations.testPricingJSON;
     @IsTest
     public static void populateOrderJSONTest() {
         //opp.Terrain_Type__c = 'Terrain Class 0';
         //update opp;
         OpportunityTeamMember oppTeamMember = new OpportunityTeamMember (
         										OpportunityId = b2cOpportunityId,
         										UserId = UserInfo.getUserId(),
         										TeamMemberRole = 'Installation Manager');
         insert oppTeamMember;
         /*Configuration__c config = [SELECT Id FROM Configuration__c WHERE Name ='Test Order Config 2' OR opportunity__c =:b2cOpportunityId LIMIT 1];
         Configuration_Product__c configProduct = [SELECT Id,RVN_Number__c FROM Configuration_Product__c WHERE RVN_Number__c ='22222-2' OR Configuration__c =:config.Id limit 1];*/
         
         
         Test.startTest();
         
         String body = '{"status": "OK","statusCode":"200"}';
         MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
         Test.setMock(HttpCalloutMock.class, mockResp); 
         /*Quote q = [SELECT id, GrandTotal, LineItemCount FROM Quote WHERE OpportunityId =:b2cOpportunityId]; 
         System.debug('--- Quote '+q);*/
         Contract c = [SELECT Id,Status,StartDate, CustomerSignedDate from Contract where ID = :b2cContractId];
         System.debug('--- Contract Before Signing '+c);
         //Activate Contract
         c.CustomerSignedDate = Date.today();
         c.Status = 'Activated'; 
         c.Signing_status__c  = 'Signed';
         update c;
         System.debug('--- Contract After Signing '+c);    
         Order o = [SELECT Id,Status FROM Order WHERE OpportunityId = : b2cOpportunityId LIMIT 1];
         System.debug('--- Order Before Activation '+o);
         System.debug('--- Order Status '+o.Status);
         o.Status = 'Activated';
         update o;
         System.debug('--- Order After Activation '+o);
         OrderGenerator.populateOrderJSONFromComponent(o.Id);
         Test.stopTest();
         
         
     }
 }