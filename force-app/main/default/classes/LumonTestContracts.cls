/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestContracts {
    public class CustomException extends Exception {}
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    } 
    @TestVisible public static Id b2cAccountId = LumonTestAccounts.b2cAccountId;
    @TestVisible public static Id b2bAccountId = LumonTestAccounts.b2bAccountId;
    @TestVisible public static Id b2cOpportunityId = LumonTestOpportunities.b2cOpportunityId;
    @TestVisible public static Id b2bOpportunityId = LumonTestOpportunities.b2bOpportunityId;
    @TestVisible public static List<Opportunity> b2cOpportunities = LumonTestOpportunities.b2cOpportunities;
    @TestVisible public static List<String> organizations = LumonTestData.organizations;
    @TestVisible public static List<String> businessTypes = LumonTestData.businessTypes;
    @TestVisible public static List<String> countries = LumonTestData.countryCodes;
    @TestVisible public static List<String> districts = LumonTestData.districts;
    /********** Contract Data Setup ***********/
    public static void setupContractB2C(){
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
        System.debug('---- setupContractB2C - SOQL USED: ' + LIMITS.getQueries());
    } 

    public static void setupContractData() {
        if (b2cOpportunities.size()>0) {

        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        setupContractB2C();
    }
    @TestSetup
    static void prepareData() { 
        Test.startTest();
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
        System.debug('--- LumonTestContracts - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}