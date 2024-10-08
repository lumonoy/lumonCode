/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestContacts {
    public static void setupContactB2B(){
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
        Contact contact1 = new Contact(FirstName = 'My',
                                    LastName = 'Contact',
                                    AccountId = b2bAccountId,
									MobilePhone = '+34800500100',                                
                                    MailingPostalCode = '01740', MailingCountry = 'Finland', 
                                    MailingCity = 'Vantaa',MailingStreet = 'Vanha Kalliosolantie 1');
        insert contact1;
        System.debug('--- LumonTestContacts - setupContactB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestContacts - setupContactB2B - Queries used: '+LIMITS.getQueries());
    }
    public static void setupContactData(){
        setupContactB2B();
    }
    @TestSetup
    static void prepareData() { 
        List<Account> accounts = LumonTestVariables.accounts;
        Test.startTest();
        Id b2bAccountId = LumonTestVariables.b2bAccountId;
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
        System.debug('--- LumonTestContacts - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Contact> b2bContacts = LumonTestVariables.b2bContacts;
        System.AssertNotEquals(0, b2bContacts?.size(), ' Expected B2B Contact to be Inserted');
    }  
}