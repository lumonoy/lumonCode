/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestReclamations {
    @TestVisible private static Id b2cReclamationId{
        get{
            return LumonTestVariables.b2cReclamationId;
        }
    }
    @TestVisible private static Opportunity b2cReclamation{
        get{
            return LumonTestVariables.b2cReclamation;
        }
    } 
    public static void setupReclamationB2C(){
        Id b2cAccountId = LumonTestVariables.b2cAccountId;
        if (String.isBlank(b2cAccountId)){
            LumonTestAccounts.setupAccountB2C();
        }
        b2cAccountId = LumonTestVariables.b2cAccountId;
        // Create B2C Reclamation Reclamation Opportunity   
        List<String> organizations = LumonTestVariables.organizations;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> countries = LumonTestVariables.countries;
        List<String> districts = LumonTestVariables.districts;
        setupReclamationB2C(b2cAccountId,organizations[0], districts[0], businessTypes[0]);       
    }    
    public static void setupReclamationB2C(Id accountId, String org, String district, String businessType){        
        // Create B2C Reclamation Opportunity
        Id pricebookId = LumonTestVariables.pricebookId;
        Opportunity b2cOpp = new Opportunity(Name=('B2C Reclamation '+org+' '+district+' '+businessType),
                                             Description = ('B2C Reclamation '+org+' '+district+' '+businessType), 
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Reclamation'
                                            );
        insert b2cOpp;
        System.debug('--- setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupReclamationB2C - Queries used: '+LIMITS.getQueries());
    }
    

    public static void setupReclamationB2B(){
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
        if (String.isBlank(b2bAccountId)){
            LumonTestAccounts.setupAccountB2B();
        }
        b2bAccountId = LumonTestVariables.b2bAccountId;
        List<String> organizations = LumonTestVariables.organizations;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> countries = LumonTestVariables.countries;
        List<String> districts = LumonTestVariables.districts;
        setupReclamationB2B(b2bAccountId,organizations[0], districts[0], businessTypes[1]);       
    }    
    public static void setupReclamationB2B(Id accountId, String org, String district, String businessType){        
        // Create B2B Reclamation Opportunity
        Id pricebookId = LumonTestVariables.pricebookId;
        Opportunity b2bOpp = new Opportunity(Name=('B2B Reclamation Opportunity '+org+' '+district+' '+businessType),
                                             Description = ('B2B Reclamation Opportunity '+org+' '+district+' '+businessType), 
                                            StageName='Prepare',
                                            CloseDate=system.Today()+30,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            //Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Reclamation'
                                            );
        insert b2bOpp;
        System.debug('--- LumonTestReclamations - B2B setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestReclamations - B2B setup Queries used: '+LIMITS.getQueries());
    }
    public static void setupReclamationData(){ 
        setupReclamationB2C();
        setupReclamationB2B();
    }  
    @TestSetup
    static void prepareData() {
        List<Account> accounts = LumonTestVariables.accounts;
        Test.startTest();
        if (accounts?.size()>0){
            system.debug('--- LumonTestReclamations - Using existing Test Accounts');
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
    static void setupReclamationDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupReclamationData();
            testResult = 'successfully inserted Reclamations';
            Id b2cReclamationId = LumonTestVariables.b2cReclamationId;
            Id b2bReclamationId = LumonTestVariables.b2bReclamationId;
            System.debug('--- LumonTestReclamations - B2C Reclamation Opportunity: '+b2cReclamationId);
            System.debug('--- LumonTestReclamations - B2B Reclamation Opportunity: '+b2bReclamationId);
        } catch (exception e){
            testResult = 'Error when inserting Reclamations: '+e.getMessage();
        }
        System.debug('--- LumonTestReclamations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestReclamations - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));

    }
    @IsTest
    static void setupReclamationB2CTest(){
        String testResult;
        Test.startTest();
        try {
            setupReclamationB2C();
            Id b2cReclamationId = LumonTestVariables.b2cReclamationId;
            testResult = 'successfully inserted B2C Reclamation Opportunity';
            System.debug('--- LumonTestReclamations - B2C Reclamation Opportunity: '+b2cReclamationId);
        } catch (exception e){
            testResult = 'error when inserting B2C Reclamation Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- LumonTestReclamations - B2C result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
    @IsTest
    static void setupReclamationB2BTest(){
        String testResult;
        Test.startTest();
        try {
            setupReclamationB2B();
            Id b2bReclamationId = LumonTestVariables.b2bReclamationId;
            testResult = 'successfully inserted B2B Reclamation Opportunity';
            System.debug('--- LumonTestReclamations - B2B Reclamation Opportunity: '+b2bReclamationId);
        } catch (exception e){
            testResult = 'error when inserting B2B Reclamation Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- LumonTestReclamations - B2B result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
}