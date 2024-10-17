/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class AccountControllerTest {
    public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestAccounts.b2cAccountId;
    private static Id b2bAccountId = LumonTestAccounts.b2bAccountId;
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupAccounts();
        Test.stopTest();
    }   
    @IsTest
    static void getAccountTest(){
        Test.startTest();
        Account acct = AccountController.getAccount(b2cAccountId);
        System.Debug ('--- AccountControllerTest - '+ acct.Name +' Accounts Returned');
        System.assertNotEquals(null,acct.name, 'Expected One or More Accounts to be returned');
        System.debug('--- AccountControllerTest - getAccountTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- AccountControllerTest - getAccountTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAccountsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2cAccountId};
        List<Account> accts = AccountController.getAccounts(recordIds);
        System.Debug ('--- AccountControllerTest - '+ accts.size() +' Accounts Returned');
        if (accts.size()>0){
            System.Debug (accts);
        }
        System.assertNotEquals(0,accts.size(), 'Expected One or More Accounts to be returned');
        System.debug('--- AccountControllerTest - getAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- AccountControllerTest - getAccountsTest - SOQL USED: ' + LIMITS.getQueries());
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
        System.debug('--- AccountControllerTest - getPersonAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- AccountControllerTest - getPersonAccountsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getBusinessAccountsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2bAccountId};
        List<Account> bus = AccountController.getBusinessAccounts(recordIds);
        System.Debug ('--- AccountControllerTest - '+ bus.size() +' Business Accounts Returned');
        if (bus.size()>0){
            System.Debug (bus);
        }
        System.assertNotEquals(0,bus.size(), 'Expected Only Business Account to be returned');
        System.debug('--- AccountControllerTest - getBusinessAccountsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- AccountControllerTest - getBusinessAccountsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAccountAddressesTest(){
        Test.startTest();
        List<Account> accts = AccountController.getAccountAddresses();
        System.Debug ('--- AccountControllerTest - '+ accts.size() +' Accounts Returned');
        if (accts.size()>0){
            for(Integer i=0;i<accts.size();i++){
                System.Debug (accts[i]);
            }
        }
        System.assertNotEquals(0,accts.size(), 'Expected Atleast One Account to be returned');
        System.debug('--- AccountControllerTest - getAccountAddressesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- AccountControllerTest - getAccountAddressesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}