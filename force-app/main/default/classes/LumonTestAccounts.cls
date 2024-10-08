/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public without sharing class LumonTestAccounts {
    public class CustomException extends Exception {}
    @TestVisible private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    @TestVisible private static Id b2cRecordTypeId{
        get{
            return LumonTestVariables.b2cRecordTypeId;
        }
    }
    @TestVisible private static Id b2bRecordTypeId{
        get{
            return LumonTestVariables.b2bRecordTypeId;
        }
    }
	@TestVisible private static Id b2cAccountId{
        get{
            return LumonTestVariables.b2cAccountId;
        }
    }
    @TestVisible private static Account b2cAccount{
        get{
            return LumonTestVariables.b2cAccount;
        }
    }
    @TestVisible private static Id b2bAccountId{
        get{
            return LumonTestVariables.b2bAccountId;
        }
    }
    
	@TestVisible private static Account b2bAccount{
        get{
            return LumonTestVariables.b2bAccount;
        }
    }
    //@future 
    public static void setupAccountB2C(){
        // Create B2C Account
        setupPersonAccount('Finland','Helsinki','00900','Asematie 1','FI_South', false);
    }
    public static void setupAccountB2C(Boolean skipAutomation){
        // Create B2C Account
        setupPersonAccount('Finland','Vantaa','01600','Rautatie 1','FI_South', skipAutomation);
    }
    public static void setupAccountB2C(String country, String city, String postalCode, String street, String district, Boolean skipAutomation) {
        setupPersonAccount(country,city,postalCode,street,district, skipAutomation);
    }
    public static void setupPersonAccount(String country, String city, String postalCode, String street, String district, Boolean skipAutomation){
        System.debug('--- LumonTestAccounts - bypassSettings: '+AutomationBypass__c.getInstance().SkipAutomation__c );
        AutomationBypass__c bypassSettings  = AutomationBypass__c.getInstance();
        Boolean skipFlow = bypassSettings.SkipAutomation__c;
        if (skipFlow != skipAutomation) {
            System.debug('--- LumonTestAccounts - Update Automation Bypass  from '+skipflow+' to '+skipAutomation);
            AutomationBypass__c bypass = new AutomationBypass__c();
            bypass.SkipAutomation__c = skipAutomation;
            insert bypass;
        }
        // Create B2C Account
        Id b2cRecordTypeId = LumonTestVariables.b2cRecordTypeId;
        System.debug('--- LumonTestAccounts - B2C RecordType '+b2cRecordTypeId);
        Account personAccount = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='Lumon',
                    LastName='Person Account',
                    PersonEmail='person@lumonCustomer.com',
                    PersonMailingCountry =country,
                    PersonMailingCity=city,
                    PersonMailingPostalCode = postalCode,
                    PersonMailingStreet=street,
                    District__c = district,
                    District_Type__c = 'P4',
                    AccountNumber = '12345');
        System.debug('--- LumonTestAccounts - setupPersonAccount - B2C duplicates: '+datacloud.FindDuplicates.findDuplicates(new List<Account> {personAccount}));
        insert personAccount;
        System.debug('--- LumonTestAccounts - setupPersonAccount - B2C Account: '+personAccount);
        System.debug('--- LumonTestAccounts - setupPersonAccount - CPU TIME Setup B2C Account: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupPersonAccount - Queries used Setup B2C Account: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupAccountB2B(){
        // Create B2B Account
        setupBusinessAccount('Finland','Vantaa','01200','Porttipuistontie 100','FI_South',false);
    }
    public static void setupAccountB2B(Boolean skipAutomation){
        // Create B2B Account
        setupBusinessAccount('Finland','Vantaa','01200','Porttipuistontie 100','FI_South',skipAutomation);
    }
    public static void setupBusinessAccount(String country, String city, String postalCode, String street, String district, Boolean skipAutomation){
        System.debug('--- LumonTestAccounts - setupBusinessAccount - bypassSettings: '+AutomationBypass__c.getInstance().SkipAutomation__c );
        AutomationBypass__c bypassSettings  = AutomationBypass__c.getInstance();
        Boolean skipFlow = bypassSettings.SkipAutomation__c;
        if (skipFlow != skipAutomation) {
            System.debug('--- LumonTestAccounts - Update Automation Bypass  from '+skipflow+' to '+skipAutomation);
            AutomationBypass__c bypass = new AutomationBypass__c();
            bypass.SkipAutomation__c = skipAutomation;
            insert bypass;
        }
        // Create B2C Account  
        Id b2bRecordTypeId = LumonTestVariables.b2bRecordTypeId;
        System.debug('--- LumonTestAccounts - B2B RecordType '+b2bRecordTypeId);
        Account businessAccount = new Account(RecordTypeID=b2bRecordTypeId,
                    Name='B2B Account',
                    BillingCountry =country,
                    BillingCity=city,
                    BillingPostalCode = postalCode,
                    BillingStreet = street,
                    District__c = district,
                    District_Type__c = 'P4',
                    AccountNumber = '67890');
        insert businessAccount;
        System.debug('--- LumonTestAccounts - setupBusinessAccount - B2B Account: '+businessAccount);
        System.debug('--- LumonTestAccounts - setupBusinessAccount - CPU TIME Setup B2B Account: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupBusinessAccount - Queries used Setup B2B Account: '+LIMITS.getQueries());
    }
    public static void setupAccountData(){ 
        System.debug('--- LumonTestAccounts - Setup B2C Account');
        setupAccountB2C();
        System.debug('--- LumonTestAccounts - Setup B2B Account');
        setupAccountB2B();
    }  

    @IsTest
    static void setupAccountDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupAccountData();
            testResult = 'successfully inserted Accounts';
        } catch (exception e){
            testResult = 'Error when inserting Accounts: '+e.getMessage();
        }
        System.debug('--- LumonTestAccounts - setupAccountDataTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupAccountDataTest - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        Id b2cAccountId = LumonTestVariables.b2cAccountId;
        System.AssertNotEquals(null, b2cAccountId, ' Expected B2C Account to be Inserted');
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
        System.AssertNotEquals(null, b2bAccountId, ' Expected B2B Account to be Inserted');
    }
    @IsTest
    static void setupB2CAccountDefaultsTest(){
        String flowResult;
        Map<String, Object> flowInputs = new Map<String, Object>{
            'recordId' => b2cAccountId
        };
        Flow.Interview.Account_Set_Defaults accountDefaultsFlow = new Flow.Interview.Account_Set_Defaults(flowInputs);
        Test.startTest();
        try {
    		accountDefaultsFlow.start();
        	flowResult = (String)accountDefaultsFlow.getvariableValue('pricingSummaryId');
        	if (String.isEmpty(flowResult)) {
            	throw new CustomException ('Unable to set Account Defaults');
            } else {
                System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - flowResult '+flowResult);
            }
        } catch (exception e){
            System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - flowResult '+flowResult);
            flowResult = 'error when inserting B2C Opportunity: '+e.getMessage();
        }
        System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - Queries used: '+LIMITS.getQueries());
        Test.stopTest(); 
    }

}