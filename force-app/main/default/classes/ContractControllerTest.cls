/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class ContractControllerTest {
    public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestVariables.b2cSyncedQuoteId;
    private static List<Id> contractIds = LumonTestVariables.contractIds;
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
    static void getContractRecordTest(){
        Test.startTest();
        Contract contractRecord = ContractController.getContractRecord(contractIds[0]);
        System.Debug ('--- '+ contractRecord.Id +' Contract Returned');
        System.assertNotEquals(null,contractRecord, 'Expected Contract Record to be returned');
        System.debug('--- getContractRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContractRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getContractsTest(){
        Test.startTest();
        List<Contract> contracts = ContractController.getContracts(contractIds);
        System.Debug ('--- '+ contracts.size() +' Orders Returned');
        System.assertNotEquals(0,contracts.size(), 'Expected Contract Record to be returned');
        System.debug('--- getContractsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContractsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}