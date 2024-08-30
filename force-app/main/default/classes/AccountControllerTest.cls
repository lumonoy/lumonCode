/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class AccountControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupAccountRecords();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupAccountB2B();
        Test.stopTest();
    }   
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    @IsTest
    static void getAccountTest(){
        Test.startTest();
        Account acct = AccountController.getAccount(b2cAccountId);
        System.Debug ('----'+ acct.Name +' Accounts Returned');
        System.assertNotEquals(null,acct.name, 'Expected One or More Accounts to be returned');
        System.debug('--- getAccountTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAccountTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAccountsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2cAccountId};
        List<Account> accts = AccountController.getAccounts(recordIds);
        System.Debug ('----'+ accts.size() +' Accounts Returned');
        if (accts.size()>0){
            System.Debug (accts);
        }
        System.assertNotEquals(0,accts.size(), 'Expected One or More Accounts to be returned');
        System.debug('--- getAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAccountsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPersonAccountsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2cAccountId};
        List<Account> per = AccountController.getPersonAccounts(recordIds);
        System.Debug ('----'+ per.size() +' Person Accounts Returned');
        if (per.size()>0){
            System.Debug (per);
        }
        System.assertNotEquals(0,per.size(), 'Expected Only Person Account to be returned');
        System.debug('--- getPersonAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPersonAccountsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getBusinessAccountsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2bAccountId};
        List<Account> bus = AccountController.getBusinessAccounts(recordIds);
        System.Debug ('----'+ bus.size() +' Business Accounts Returned');
        if (bus.size()>0){
            System.Debug (bus);
        }
        System.assertNotEquals(0,bus.size(), 'Expected Only Business Account to be returned');
        System.debug('--- getBusinessAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getBusinessAccountsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAccountAddressesTest(){
        Test.startTest();
        List<Account> accts = AccountController.getAccountAddresses();
        System.Debug ('----'+ accts.size() +' Accounts Returned');
        if (accts.size()>0){
            for(Integer i=0;i<accts.size();i++){
                System.Debug (accts[i]);
            }
        }
        System.assertNotEquals(0,accts.size(), 'Expected Atleast One Account to be returned');
        System.debug('--- getAccountAddressesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAccountAddressesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}