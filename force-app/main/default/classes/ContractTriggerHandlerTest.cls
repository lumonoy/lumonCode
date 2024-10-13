/**
 * @description       : NOT IS USE ContractTriggerHandler commented OUT
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ContractTriggerHandlerTest {
    /*public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestVariables.b2cSyncedQuoteId;
    private static List<Id> contractIds = LumonTestVariables.contractIds;
    private static List<Contract> contracts = LumonTestVariables.contracts;
    //private static Id b2cOrderId = LumonTestVariables.b2cOrderId;
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupContractB2C();
        //LumonTestDataFactory.setupOrderB2C();
        Test.stopTest();
    }
    @IsTest
    public static void updateContractToSignedTest() {
        //Building__c  b = [select Id,Building_Address__c, Combined_load__c, Drainage_holes__c, Heatsoak__c, Name, On_Hill_or_Slope__c, Owned_By__c, Property_Type__c, Snow_Load__c, Structural_Analysis__c from Building__c limit 1];
        //System.debug('--- b val ---'+b);
        contract con = contracts[0];
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
        contract con = contracts[0];
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
    }*/
}