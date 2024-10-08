/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-16-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestContracts {
    /********** Contract Data Setup ***********/
    public static void setupContractB2C(){
        List<Opportunity> b2cOpportunities = LumonTestVariables.b2cOpportunities;
        Opportunity b2cOpp = b2cOpportunities[0];
        Id pricebookId = b2cOpp.pricebook2Id;
        Id accountId = b2cOpp.AccountId;
        Id opportunityId = b2cOpp.Id;
        Id quoteId = b2cOpp.SyncedQuoteId;
        // Create B2C Contract
        Contract b2cContract1 = new Contract( Name='B2C Normal Contract',
                                            Status='Draft',
                                            AccountId = accountId,
                                            Pricebook2Id=pricebookId,
                                            Opportunity__c=opportunityId,
                                            Quote__c=quoteId
                                            //Type='Normal'
                                            );
        insert b2cContract1;
        System.debug('---- setupContractB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupContractB2C - Queries used: '+LIMITS.getQueries());
    } 

    public static void setupContractData() {
        setupContractB2C();
    }
    @TestSetup
    static void prepareData() { 
        List<Account> accounts = LumonTestVariables.accounts;
        Test.startTest();
        Id b2cAccountId = LumonTestVariables.b2cAccountId;
        if (String.isBlank(b2cAccountId)){
            LumonTestAccounts.setupAccountB2C();
        }
        Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
        if (String.isBlank(b2cOpportunityId)){
            LumonTestOpportunities.setupOpportunityB2C();
        }
        Test.stopTest();
    } 
    @IsTest
    static void setupContractDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupContractData();
            testResult = 'successfully inserted Contracts';
        } catch (exception e){
            testResult = 'Error when inserting Contracts: '+e.getMessage();
        }
        System.debug('--- LumonTestContracts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestContracts - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Contract> contracts = LumonTestVariables.contracts;
        System.AssertNotEquals(0, contracts?.size(), ' Expected B2C Contract to be Inserted');
    }
    @IsTest
    static void setupContractTest(){
        String testResult;
        Test.startTest();
        try {
            setupContractB2C();
            testResult = 'successfully inserted Contracts';
        } catch (exception e){
            testResult = 'Error when inserting Contracts: '+e.getMessage();
        }
        System.debug('--- LumonTestContracts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestContracts - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Contract> contracts = LumonTestVariables.contracts;
        System.AssertNotEquals(0, contracts?.size(), ' Expected B2C Contract to be Inserted');
    }
}