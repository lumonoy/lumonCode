/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-04-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ContactController {
    /**** Methods for Finding Contact Entries ****/
    @AuraEnabled(cacheable=false)
    public static Contact getContact(Id recordId ) {
        // Populate List from SOQL query on Contact
        System.debug('--- Get Contact with Id or accountId: '+recordId); 
        List<Id> recordIds = new List<Id>();
        recordIds.add(recordId);
        List<Contact> contacts = getContacts(recordIds);
        Contact contact = contacts[0];

        System.debug('--- Contact: '+contact.Name); 
        return contact;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Contact> getContacts(List<Id> recordIds ) {
        // Populate List from SOQL query on Contact
        System.debug('--- Get Contacts'); 
        List<Contact> contacts = ([  SELECT  Id, 
                                      MasterRecordId, 
                                      AccountId, 
                                      IsPersonAccount, 
                                      LastName, 
                                      FirstName, 
                                      Salutation, 
                                      Name, 
                                      OtherStreet, 
                                      OtherCity, 
                                      OtherState, 
                                      OtherPostalCode, 
                                      OtherCountry, 
                                      OtherStateCode, 
                                      OtherCountryCode, 
                                      OtherLatitude, 
                                      OtherLongitude, 
                                      OtherGeocodeAccuracy, 
                                      OtherAddress, 
                                      MailingStreet, 
                                      MailingCity, 
                                      MailingState, 
                                      MailingPostalCode, 
                                      MailingCountry, 
                                      MailingStateCode, 
                                      MailingCountryCode, 
                                      MailingLatitude, 
                                      MailingLongitude,
                                      MailingGeocodeAccuracy, 
                                      MailingAddress, 
                                      Phone, 
                                      Fax, 
                                      MobilePhone, 
                                      HomePhone, 
                                      OtherPhone, 
                                      AssistantPhone, 
                                      ReportsToId, 
                                      Email, 
                                      Title, 
                                      Department, 
                                      AssistantName, 
                                      LeadSource, 
                                      Birthdate, 
                                      Description, 
                                      CurrencyIsoCode,
                                      OwnerId, 
                                      HasOptedOutOfEmail, 
                                      HasOptedOutOfFax, 
                                      DoNotCall, 
                                      EmailBouncedReason, 
                                      EmailBouncedDate, 
                                      IsEmailBounced, 
                                      Email_Opt_In_Date_Time__c, 
                                      Email_Opt_In__c, 
                                      Preferred_Channel__c, 
                                      SMS_Opt_In_Date_Time__c, 
                                      SMS_Opt_In__c, 
                                      cadmus_sign2__LocaleSidKey__c                       
                                    FROM Contact 
                                    WHERE Id IN: recordIds 
                                    OR AccountId IN: recordIds
                                    ]);  
        System.debug('--- Contacts: '+contacts.size()); 
        return contacts;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Contact> getContactAddresses(Id recordId) {
        // Populate List from SOQL query on Contact
        System.debug('--- Get Business Contacts'); 
        List<Contact> Contacts = ([  SELECT  Id,
                                        Name,
                                        AccountId, 
                                        IsPersonAccount,
                                        MailingAddress, 
                                        OtherAddress                                               
                                    FROM Contact 
                                    WHERE Id =: recordId
                                    LIMIT 1]);  
        System.debug('--- Contacts: '+Contacts.Size()); 
        return Contacts;  
    }
}