/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-09-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestAccounts {
    @TestVisible private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    @TestVisible private static Id b2cRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = true) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible private static Id b2bRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = false) AND (SobjectType='Account')]?.Id;
        }
    }
	@TestVisible private static Id b2cAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Account b2cAccount{
        get{
            return [SELECT Id,Name,Business_Type__c, 
                            BillingCountry, ShippingCountry,
                            BillingCity, ShippingCity, 
                            BillingPostalCode, ShippingPostalCode, 
                            BillingStreet, ShippingStreet  
                    FROM Account WHERE (IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = false)]?.Id;
        }
    }
    
	@TestVisible private static Account b2bAccount{
        get{
            return [SELECT Id,Name,Business_Type__c, 
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
        setupAccountB2C('Finland','Vantaa','01200','Porttipuistontie 1','FI_South', true);
    }
    public static void setupAccountB2C(Boolean skipAutomation){
        // Create B2C Account
        setupAccountB2C('Finland','Vantaa','01200','Porttipuistontie 1','FI_South', skipAutomation);
    }
    public static void setupAccountB2C(String country, String city, String postalCode, String street, String district, Boolean skipAutomation){
        AutomationBypass__c bypass = new AutomationBypass__c();
        bypass.SkipAutomation__c = skipAutomation;
        insert bypass;
        // Create B2C Account
        Account personAccount = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='My',
                    LastName='Person Account',
                    PersonEmail='test123@lumonCustomer.com',
                    PersonMailingCountry =country,
                    PersonMailingCity=city,
                    PersonMailingPostalCode = postalCode,
                    PersonMailingStreet=street,
                    District__c = district,
                    District_Type__c = 'P4');
        insert personAccount;
        System.debug('--- setupAccountB2C - Account: '+personAccount);
        System.debug('--- setupAccountB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupAccountB2B(){
        // Create B2B Account
        setupAccountB2B('Finland','Vantaa','01200','Porttipuistontie 100','FI_South',false);
    }
    public static void setupAccountB2B(Boolean skipAutomation){
        // Create B2B Account
        setupAccountB2B('Finland','Vantaa','01200','Porttipuistontie 100','FI_South',skipAutomation);
    }
    public static void setupAccountB2B(String country, String city, String postalCode, String street, String district, Boolean skipAutomation){
        AutomationBypass__c bypass = new AutomationBypass__c();
        bypass.SkipAutomation__c = skipAutomation;
        insert bypass;
        // Create B2C Account
        Account businessAccount = new Account(RecordTypeID=b2bRecordTypeId,
                    Name='B2B Account',
                    BillingCountry =country,
                    BillingCity=city,
                    BillingPostalCode = postalCode,
                    BillingStreet = street,
                    District__c = district,
                    District_Type__c = 'P4');
        insert businessAccount;
        System.debug('--- setupAccountB2B - Account: '+businessAccount);
        System.debug('--- setupAccountB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2B - Queries used: '+LIMITS.getQueries());
    }
    @IsTest
    static void setupAccountB2CTest(){
        String testResult;
        Test.startTest();
        Try {
            setupAccountB2C();
            testResult = 'successfully inserted Person Account';
        } catch (exception e){
            testResult = 'error when inserting Person Account: '+e.getMessage();
        }
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('error'));
        System.debug('--- setupAccountB2CTest - Account with Address: '+b2cAccount);
        System.debug('--- setupAccountB2CTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2CTest - Queries used: '+LIMITS.getQueries());
    }
    @IsTest
    static void setupAccountB2CnoFlowTest(){
        String testResult;
        Test.startTest();
        Try {
            setupAccountB2C(true);
            testResult = 'successfully inserted Person Account';
        } catch (exception e){
            testResult = 'error when inserting Person Account: '+e.getMessage();
        }
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('error'));
        System.debug('--- setupAccountB2CnoFlowTest - Account with Address: '+b2cAccount);
        System.debug('--- setupAccountB2CnoFlowTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2CnoFlowTest - Queries used: '+LIMITS.getQueries());
    }
    @IsTest
    static void setupAccountB2BTest(){
        String testResult;
        Test.startTest();
        Try {
            setupAccountB2B();
            testResult = 'successfully inserted Business Account';
        } catch (exception e){
            testResult = 'error when inserting Business Account: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
        System.debug('--- setupAccountB2BTest - Account with Address: '+b2bAccount);
        System.debug('--- setupAccountB2BTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2BTest - Queries used: '+LIMITS.getQueries());
    }
}