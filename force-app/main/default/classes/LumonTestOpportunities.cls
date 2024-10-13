/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
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
    @TestVisible private static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2cOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Id =: b2cOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static List<Opportunity> b2cOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Account> accounts{
        get{
            return [SELECT Id, IsPersonAccount, Business_Type__c, PersonMailingAddress, PersonOtherAddress,BillingAddress, ShippingAddress FROM Account ];
        }
    }
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    } 
    @TestVisible public static Id b2cAccountId = LumonTestAccounts.b2cAccountId;
    @TestVisible public static Id b2bAccountId = LumonTestAccounts.b2bAccountId;
    @TestVisible public static List<String> organizations = LumonTestData.organizations;
    @TestVisible public static List<String> businessTypes = LumonTestData.businessTypes;
    @TestVisible public static List<String> countries = LumonTestData.countryCodes;
    @TestVisible public static List<String> districts = LumonTestData.districts;
    
    public static void setupOpportunityB2C(){
        // Create B2C Opportunity           

        setupOpportunityB2C(b2cAccountId,organizations[0], districts[0], '1');
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
                                            AccountId = accountId
                                            //Organization__c = org,
                                            //Country_Attribute__c,
                                            //Business_Type__c =businessType,
                                            //District__c = district,
                                            //Order_Type__c = 'Normal'                                       
                                            );
        insert b2cOpp;
        System.debug('--- LumonTestOpportunities - B2C setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - B2C setup SOQL USED: ' + LIMITS.getQueries());
    }

    public static void setupOpportunityB2B(){
        // Create B2C Opportunity   
        setupOpportunityB2B(b2bAccountId,organizations[0], districts[0], '4');       
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
                                            AccountId = accountId
                                            //Organization__c = org,
                                            //Country_Attribute__c,
                                            //Business_Type__c =businessType,
                                            //District__c = district,
                                            //Order_Type__c = 'Normal'
                                            );
        insert b2bOpp;
        System.debug('--- LumonTestOpportunities - B2B setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - B2B setup SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupOpportunityData(){ 
        setupOpportunityB2C();
        setupOpportunityB2B();
    }  
    @TestSetup
    static void prepareData() { 
        Test.startTest();
        if (accounts?.size()>0){
            system.debug('--- LumonTestOpportunities - Using existing Test Accounts');
        } else {
            LumonTestAccounts.setupAccountData();
        }
        if (String.isBlank(b2cAccountId)){
            LumonTestAccounts.setupAccountB2C();
        }
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
            System.debug('--- LumonTestOpportunities - B2C Opportunity: '+b2cOpportunityId);
            System.debug('--- LumonTestOpportunities - B2B Opportunity: '+b2bOpportunityId);
        } catch (exception e){
            testResult = 'Error when inserting Opportunities: '+e.getMessage();
        }
        System.debug('--- LumonTestOpportunities - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunities - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));

    }
    @IsTest
    static void setupOpportunityB2CTest(){
        String testResult;
        Test.startTest();
        try {
            setupOpportunityB2C();
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