/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestOpportunities {
    @TestVisible private static Id b2cOpportunityRecordTypeId{
        get{
            return LumonTestVariables.b2cOpportunityRecordTypeId;
        }
    }
    @TestVisible private static Id b2bOpportunityRecordTypeId{
        get{
            return LumonTestVariables.b2bOpportunityRecordTypeId;
        }
    }
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
	@TestVisible private static Id b2cOpportunityId{
        get{
            return LumonTestVariables.b2cOpportunityId;
        }
    }
    @TestVisible private static Opportunity b2cOpportunity{
        get{
            return LumonTestVariables.b2cOpportunity;
        }
    }
    @TestVisible private static Id b2cReclamationId{
        get{
            return LumonTestVariables.b2cReclamationId;
        }
    }
    @TestVisible private static List<Opportunity> b2cOpportunities{
        get{
            return LumonTestVariables.b2cOpportunities;

        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return LumonTestVariables.b2bOpportunityId;
        }
    }
    @TestVisible private static Opportunity b2bOpportunity{
        get{
            return LumonTestVariables.b2bOpportunity;
        }
    }
    @TestVisible private static List<Opportunity> b2bOpportunities{
        get{
            return LumonTestVariables.b2bOpportunities;

        }
    }
    public static void setupOpportunityB2C(){
        // Create B2C Opportunity           
        Id b2cAccountId = LumonTestVariables.b2cAccountId;
        List<String> organizations = LumonTestVariables.organizations;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> countries = LumonTestVariables.countries;
        List<String> districts = LumonTestVariables.districts;
        setupOpportunityB2C(b2cAccountId,organizations[0], districts[0], 'Consumer');
    }  
    public static void setupOpportunityB2C(Id accountId, String org, String district, String businessType){        
        // Create B2C Opportunity
        Id pricebookId = LumonTestVariables.pricebookId;
        Opportunity b2cOpp = new Opportunity(RecordTypeId=b2cOpportunityRecordTypeId,
                                            Name=('B2C Opportunity '+org+' '+district+' '+businessType),
                                            Description = ('B2C Opportunity '+org+' '+district+' '+businessType), 
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Normal'                                       
                                            );
        insert b2cOpp;
        System.debug('--- LumonTestOpportunities - B2C setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - B2C setup Queries used: '+LIMITS.getQueries());
    }

    public static void setupOpportunityB2B(){
        // Create B2C Opportunity   
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
        List<String> organizations = LumonTestVariables.organizations;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> countries = LumonTestVariables.countries;
        List<String> districts = LumonTestVariables.districts;
        setupOpportunityB2B(b2bAccountId,organizations[0], districts[0], 'Reseller');       
    }    
    public static void setupOpportunityB2B(Id accountId, String org, String district, String businessType){        
        // Create B2B Opportunity
        Id pricebookId = LumonTestVariables.pricebookId;
        Opportunity b2bOpp = new Opportunity(RecordTypeId=b2bOpportunityRecordTypeId,
                                            Name=('B2B Opportunity '+org+' '+district+' '+businessType),
                                            Description = ('B2B Opportunity '+org+' '+district+' '+businessType), 
                                            StageName='Prepare',
                                            CloseDate=system.Today()+30,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Normal'
                                            );
        insert b2bOpp;
        System.debug('--- LumonTestOpportunities - B2B setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - B2B setup Queries used: '+LIMITS.getQueries());
    }
    public static void setupOpportunityData(){ 
        setupOpportunityB2C();
        setupOpportunityB2B();
    }  
    @TestSetup
    static void prepareData() { 
        List<Account> accounts = LumonTestVariables.accounts;
        Test.startTest();
        if (accounts?.size()>0){
            system.debug('--- LumonTestOpportunities - Using existing Test Accounts');
        } else {
            LumonTestAccounts.setupAccountData();
        }
        Id b2cAccountId = LumonTestVariables.b2cAccountId;
        if (String.isBlank(b2cAccountId)){
            LumonTestAccounts.setupAccountB2C();
        }
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
        if (String.isBlank(b2bAccountId)){
            LumonTestAccounts.setupAccountB2B();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupOpportunityDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupOpportunityData();
            testResult = 'successfully inserted Opportunities';
            Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
            Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;
            System.debug('--- LumonTestOpportunities - B2C Opportunity: '+b2cOpportunityId);
            System.debug('--- LumonTestOpportunities - B2B Opportunity: '+b2bOpportunityId);
        } catch (exception e){
            testResult = 'Error when inserting Opportunities: '+e.getMessage();
        }
        System.debug('--- LumonTestOpportunities - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));

    }
    @IsTest
    static void setupOpportunityB2CTest(){
        String testResult;
        Test.startTest();
        try {
            setupOpportunityB2C();
            Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
            testResult = 'successfully inserted B2C Opportunity';
            System.debug('--- LumonTestOpportunities - B2C Opportunity: '+b2cOpportunityId);
        } catch (exception e){
            testResult = 'error when inserting B2C Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- LumonTestOpportunities - B2C result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
    @IsTest
    static void setupOpportunityB2BTest(){
        String testResult;
        Test.startTest();
        try {
            setupOpportunityB2B();
            Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;
            testResult = 'successfully inserted B2B Opportunity';
            System.debug('--- LumonTestOpportunities - B2B Opportunity: '+b2bOpportunityId);
        } catch (exception e){
            testResult = 'error when inserting B2B Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- LumonTestOpportunities - B2B result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
}