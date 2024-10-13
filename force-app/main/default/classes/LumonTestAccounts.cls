/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public without sharing class LumonTestAccounts {
    public class CustomException extends Exception {}
    @TestVisible private static Map<String,List<String>> addressMap{
        get{
            return LumonTestData.addressMap;
        }
    }
    @TestVisible public static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    @TestVisible public static Id b2cRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = true) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible public static Id b2bRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = false) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible public static List<Account> accounts{
        get{
            return [SELECT Id, IsPersonAccount, PersonMailingAddress, PersonOtherAddress,BillingAddress, ShippingAddress FROM Account ];
        }
    }
    @TestVisible public static Id b2cAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible public static Account b2cAccount{
        get{
            return [SELECT Id,Name, 
                            BillingCountry, ShippingCountry,
                            BillingCity, ShippingCity, 
                            BillingPostalCode, ShippingPostalCode, 
                            BillingStreet, ShippingStreet  
                    FROM Account WHERE (IsPersonAccount = true)];
        }
    }
    @TestVisible public static Id b2bAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = false)]?.Id;
        }
    }
    @TestVisible public static Account b2bAccount{
        get{
            return [SELECT Id,Name,
                            BillingCountry, ShippingCountry,
                            BillingCity, ShippingCity, 
                            BillingPostalCode, ShippingPostalCode, 
                            BillingStreet, ShippingStreet  
                    FROM Account WHERE (IsPersonAccount = false)];
        }
    }
    //@future 
    public static void setupAccountB2C(){
        // Create B2C Account
        List<String> accountAddress = addressMap.get('b2cAccount'); //'Finland','Vantaa','12345','Street 100','FI_South'
        setupPersonAccount(accountAddress[0],accountAddress[1],accountAddress[2],accountAddress[3],accountAddress[4], false);
    }
    public static void setupAccountB2C(Boolean skipAutomation){
        // Create B2C Account
        List<String> accountAddress = addressMap.get('b2cAccount'); //'Finland','Vantaa','12345','Street 100','FI_South'
        setupPersonAccount(accountAddress[0],accountAddress[1],accountAddress[2],accountAddress[3],accountAddress[4], skipAutomation);
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
        System.debug('--- LumonTestAccounts - B2C RecordType '+b2cRecordTypeId);
        Account personAccount = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='B2C',
                    LastName='Test Account',
                    PersonEmail='b2c.account@external.com',
                    PersonMailingCountry =country,
                    PersonMailingCity=city,
                    PersonMailingPostalCode = postalCode,
                    PersonMailingStreet=street,
                    District__c = district,
                    District_Type__c = 'P4',
                    AccountNumber = '10001');
        System.debug('--- LumonTestAccounts - setupPersonAccount - B2C duplicates: '+datacloud.FindDuplicates.findDuplicates(new List<Account> {personAccount}));
        insert personAccount;
        System.debug('--- LumonTestAccounts - setupPersonAccount - B2C Account: '+personAccount);
        System.debug('--- LumonTestAccounts - setupPersonAccount - CPU TIME Setup B2C Account: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupPersonAccount - Queries used Setup B2C Account: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupAccountB2B(){
        // Create B2B Account
        List<String> accountAddress = addressMap.get('b2bAccount'); //'Finland','Vantaa','12345','Street 100','FI_South'
        setupBusinessAccount(accountAddress[0],accountAddress[1],accountAddress[2],accountAddress[3],accountAddress[4], false);
    }
    public static void setupAccountB2B(Boolean skipAutomation){
        // Create B2B Account
        List<String> accountAddress = addressMap.get('b2bAccount'); //'Finland','Vantaa','12345','Street 100','FI_South'
        setupBusinessAccount(accountAddress[0],accountAddress[1],accountAddress[2],accountAddress[3],accountAddress[4], skipAutomation);
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
        // Create B2B Account  
        System.debug('--- LumonTestAccounts - B2B RecordType '+b2bRecordTypeId);
        Account businessAccount = new Account(RecordTypeID=b2bRecordTypeId,
                    Name='B2B Test Account',
                    BillingCountry =country,
                    BillingCity=city,
                    BillingPostalCode = postalCode,
                    BillingStreet = street,
                    //District__c = district,
                    //DistrictType__c = 'P4',
                    AccountNumber = '20001');
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
    @TestSetup
    static void prepareData() {
        Test.startTest();

        Test.stopTest();
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
        System.debug('--- LumonTestAccounts - setupAccountDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        System.AssertNotEquals(null, b2cAccountId, ' Expected B2C Account to be Inserted');
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
            flowResult = 'error when inserting B2C Account: '+e.getMessage();
        }
        System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupB2CAccountDefaultsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    static void setupB2BAccountDefaultsTest(){
        String flowResult;
        Map<String, Object> flowInputs = new Map<String, Object>{
            'recordId' => b2bAccountId
        };
        Flow.Interview.Account_Set_Defaults accountDefaultsFlow = new Flow.Interview.Account_Set_Defaults(flowInputs);
        Test.startTest();
        try {
    		accountDefaultsFlow.start();
        	flowResult = (String)accountDefaultsFlow.getvariableValue('pricingSummaryId');
        	if (String.isEmpty(flowResult)) {
            	throw new CustomException ('Unable to set Account Defaults');
            } else {
                System.debug('--- LumonTestAccounts - setupB2BAccountDefaultsTest - flowResult '+flowResult);
            }
        } catch (exception e){
            System.debug('--- LumonTestAccounts - setupB2BAccountDefaultsTest - flowResult '+flowResult);
            flowResult = 'error when inserting B2B Account: '+e.getMessage();
        }
        System.debug('--- LumonTestAccounts - setupB2BAccountDefaultsTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAccounts - setupB2BAccountDefaultsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }

}