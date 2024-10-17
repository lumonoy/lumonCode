/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestContacts {
    public class CustomException extends Exception {}
    @TestVisible private static Map<String,List<String>> addressMap{
        get{
            return LumonTestData.addressMap;
        }
    }
    @TestVisible public static List<Contact> contacts{
        get{
            return [SELECT Id, AccountId, IsPersonAccount, LastName, FirstName, Salutation, Name, 
                    OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherAddress, 
                    MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingAddress, 
                    Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department FROM Contact ];
        }
    }
    @TestVisible private static Id b2cAccountId = LumonTestAccounts.b2cAccount.Id;
    @TestVisible private static Id b2bAccountId = LumonTestAccounts.b2bAccount.Id;
    @TestVisible private static List<Account> accounts = LumonTestAccounts.accounts;
    public static void setupContactB2B(){
        List<String> accountAddress = addressMap.get('contact'); //'Finland','Vantaa','12345','Street 100','FI_South'
        Contact contact1 = new Contact(FirstName = 'My',
                                    LastName = 'Contact',
                                    AccountId = b2bAccountId,
                                    Email='b2b.contact@external.com',
									MobilePhone = '+34800100001', 
                                    MailingCountry = accountAddress[0], 
                                    MailingCity = accountAddress[1],
                                    MailingPostalCode = accountAddress[2],
                                    MailingStreet = accountAddress[3]);
        insert contact1;
        System.debug('--- LumonTestContacts - setupContactB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestContacts - setupContactB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupContactData(){
        setupContactB2B();
    }
    @TestSetup
    static void prepareData() { 
        Test.startTest();
        if (String.isBlank(b2bAccountId)){
            LumonTestAccounts.setupAccountB2B();
        }
        Test.stopTest();
    } 
    @IsTest
    static void setupContactDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupContactData();
            testResult = 'successfully inserted Contacts';
        } catch (exception e){
            testResult = 'Error when inserting Contacts: '+e.getMessage();
        }
        System.debug('--- LumonTestContacts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestContacts - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }  
}