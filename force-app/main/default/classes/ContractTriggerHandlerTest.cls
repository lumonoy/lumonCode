/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ContractTriggerHandlerTest {
    @TestSetup
    static void PrepareData(){
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
        LumonTestDataFactory.setupSyncedQuoteB2C();
        LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();
        LumonTestDataFactory.setupContractB2C();
        Test.stopTest();
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
    public static void updateContractToSignedTest() {
        //Building__c  b = [select Id,Building_Address__c, Combined_load__c, Drainage_holes__c, Heatsoak__c, Name, On_Hill_or_Slope__c, Owned_By__c, Property_Type__c, Snow_Load__c, Structural_Analysis__c from Building__c limit 1];
        //System.debug('--- b val ---'+b);
        contract con = [SELECT Id, AccountId, Opportunity__c FROM Contract WHERE Id =: b2cContractId  LIMIT 1];
        Test.startTest();
        System.debug('--- updateContractToSignedTest - Contract Before: '+con); 
        String body = '{"response": "success"}';
        MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
        Test.setMock(HttpCalloutMock.class, mockResp);
        // Activate Contract
        con.Status = 'Signed';
        update con;
        System.debug('--- updateContractToSignedTest - Contract After: '+con); 
        System.debug('--- updateContractToSignedTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- updateContractToSignedTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();  
        ContentDocumentLink contractMessage = [SELECT Id, ContentDocument.Title, ContentDocumentId, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: con.Id];
        System.assertNotEquals(null,contractMessage.Id,'Expected Contract Message File');
        System.debug('--- updateContractToSignedTest - Contract Message File: '+contractMessage.ContentDocument.title);
    }

    @IsTest
    public static void updateContractToActivatedTest() {
        contract con = [SELECT Id, AccountId, Opportunity__c FROM Contract WHERE Id =: b2cContractId  LIMIT 1];
        System.Debug('--- Contract: '+con);
        
        String body = '{"response": "success"}';
        MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
        // Change Contract status from Draft to Signed
        con.Status = 'Activated';
        update con;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockResp);
        
        ContractTriggerHandler.submitContract(con.Id);
        System.debug('--- updateContractToActivatedTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- updateContractToActivatedTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();  

        System.assert([SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: con.Id] > 0);
    }
}