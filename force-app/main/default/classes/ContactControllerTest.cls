@IsTest
public with sharing class ContactControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupAccountRecords();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupContactB2C();
        Test.stopTest();
    }   
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cContactId = LumonTestDataFactory.b2cContactId;
    @IsTest
    static void getContactTest(){
        Test.startTest();
        Contact cont = ContactController.getContact(b2cAccountId);
        System.Debug ('----'+ cont.Name +' Contacts Returned');
        System.assertNotEquals(null,cont.name, 'Expected One or More Contacts to be returned');
        System.debug('--- getContactTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getContactTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getContactsTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>{b2cAccountId};
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
        List<Contact> conts = ContactController.getContactAddresses(b2cContactId);
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