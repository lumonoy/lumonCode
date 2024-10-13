/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ContactControllerTest {
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    private static Id b2bContactId = LumonTestVariables.b2bContactId;
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupAccounts();
        LumonTestDataFactory.setupContacts();
        Test.stopTest();
    }   
    @IsTest
    static void getContactTest(){
        Test.startTest();
        Contact cont = ContactController.getContact(b2bAccountId);
        System.Debug ('----'+ cont.Name +' Contacts Returned');
        System.assertNotEquals(null,cont.name, 'Expected One or More Contacts to be returned');
        System.debug('--- getContactTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContactTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getContactsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2bAccountId};
        List<Contact> conts = ContactController.getContacts(recordIds);
        System.Debug ('----'+ conts.size() +' Contacts Returned');
        if (conts.size()>0){
            System.Debug (conts);
        }
        System.assertNotEquals(0,conts.size(), 'Expected One or More Contacts to be returned');
        System.debug('--- getContactsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContactsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getContactAddressesTest(){
        Test.startTest();
        List<Contact> conts = ContactController.getContactAddresses(b2bContactId);
        System.Debug ('----'+ conts.size() +' Contacts Returned');
        if (conts.size()>0){
            for(Integer i=0;i<conts.size();i++){
                System.Debug (conts[i]);
            }
        }
        System.assertNotEquals(0,conts.size(), 'Expected Atleast One Contact to be returned');
        System.debug('--- getContactAddressesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContactAddressesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}