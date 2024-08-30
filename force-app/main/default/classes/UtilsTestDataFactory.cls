@isTest
public with sharing class UtilsTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today();
     
    public static void setupAccountRecords(){
        // Create B2C Account
        if(isPersonAccountEnabled) {
            String B2CRecordTypeId = [SELECT Id FROM RecordType WHERE (IsPersonType = true) and (SobjectType='Account') LIMIT 1].Id;
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='B2C',
                LastName='Account',
                PersonEmail='test@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '1111',
                PersonMailingStreet='Katu 1');
            insert p;   
            system.debug ('*** accountRecordsSetup Person Account: '+p.id);
        }
        // Create B2BAccount
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (IsPersonType = false) and (SobjectType='Account')LIMIT 1].Id;
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='B2B Account',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '22222',
                BillingStreet = 'Katu 2');
            insert a;     
        system.debug ('*** accountRecordsSetup Account: '+a.id);
    }       
}