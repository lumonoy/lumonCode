/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-08-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public class ContractControllerTest {
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
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cContractId = LumonTestDataFactory.b2cContractId;
    //private static Id b2cOrderId = LumonTestDataFactory.b2cOrderId;
    @IsTest
    static void getContractRecordTest(){
        Test.startTest();
        Contract contractRecord = ContractController.getContractRecord(b2cContractId);
        System.Debug ('--- '+ contractRecord.Id +' Contract Returned');
        System.assertNotEquals(null,contractRecord, 'Expected Contract Record to be returned');
        System.debug('--- getContractRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContractRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getContractsTest(){
        Test.startTest();
        List<Id> contractIds = new List<Id> {b2cContractId};
        List<Contract> contracts = ContractController.GetContracts(contractIds);
        System.Debug ('--- '+ contracts.size() +' Orders Returned');
        System.assertNotEquals(0,contracts.size(), 'Expected Contract Record to be returned');
        System.debug('--- getContractsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContractsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}