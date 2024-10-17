/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class AccountController {
    /**** Methods for Finding Account Entries ****/
    @AuraEnabled(cacheable=false)
    public static Account getAccount(Id accountId) {
        // Populate List from SOQL query on Account
        List<Id> accountIds = new List<Id>();
        accountIds.add(accountId);
        System.debug('--- AccountController - Get Account with Id '+accountId); 
        List<Account> accounts =  getAccounts(accountIds);  
        Account account = accounts[0];
        System.debug('--- AccountController - Account: '+account.Name); 
        return account;  
    }
    @AuraEnabled(cacheable=false)
    public static Account getAccountByNumber(String accountNumber) {
        // Populate List from SOQL query on Account
        Id accountId = [SELECT Id FROM Account WHERE AccountNumber =: accountNumber LIMIT 1]?.Id; 
        List<Id> accountIds = new List<Id>();
        accountIds.add(accountId);
        Account account = new Account();
        System.debug('--- AccountController - Get Customer with Id '+accountId); 
        List<Account> accounts =  getAccounts(accountIds); 
        if  (accounts?.size()>0) {
            account = accounts[0];
            System.debug('--- AccountController - Account: '+account.Name); 
        }        
        return account;
    }
    @AuraEnabled(cacheable=false)
    public static List<Account> getAccounts(List<Id> AccountIds) {
        // Populate List from SOQL query on Account
        System.debug('--- AccountController - Get Accounts'); 
        List<Account> accounts = ([  SELECT  Id,
                                             Name,
                                             Type, 
                                             RecordTypeId, 
                                             ParentId, 
                                             OwnerId,
                                             //VAT__c,
                                             AccountSource,
                                             CustomerSegment__c, 
                                             BusinessType__c, 
                                             BusinessTypeAttribute__c, 
                                             //Account_Office__c, 
                                             //Financing_Customer_Number__c, 
                                             District__c, 
                                             County__c, 
                                             Region__c, 
                                             Municipality__c, 
                                             State__c, 
                                             //District_Type__c, 
                                             //Customer_Location__c, 
                                             //Delivery_Method__c, 
                                             //Delivery_Terms__c,
                                             BillingStreet, 
                                             BillingCity, 
                                             BillingState, 
                                             BillingPostalCode, 
                                             BillingCountry, 
                                             BillingStateCode, 
                                             BillingCountryCode, 
                                             BillingLatitude, 
                                             BillingLongitude, 
                                             BillingGeocodeAccuracy,  
                                             BillingToShipping__c,
                                             ShippingStreet, 
                                             ShippingCity, 
                                             ShippingState, 
                                             ShippingPostalCode, 
                                             ShippingCountry, 
                                             ShippingStateCode, 
                                             ShippingCountryCode, 
                                             ShippingLatitude, 
                                             ShippingLongitude, 
                                             ShippingGeocodeAccuracy, 
                                             Phone, 
                                             Fax, 
                                             AccountNumber, 
                                             Website, 
                                             Industry, 
                                             AnnualRevenue, 
                                             NumberOfEmployees, 
                                             Ownership, 
                                             Description, 
                                             Rating, 
                                             Site, 
                                             CurrencyIsoCode, 
                                             PersonContactId,
                                             IsPersonAccount,
                                             PersonMailingStreet, 
                                             PersonMailingCity, 
                                             PersonMailingState, 
                                             PersonMailingPostalCode, 
                                             PersonMailingCountry, 
                                             PersonMailingStateCode, 
                                             PersonMailingCountryCode, 
                                             PersonMailingLatitude, 
                                             PersonMailingLongitude, 
                                             PersonMailingGeocodeAccuracy, 
                                             MailingToBilling__c, 
                                             PersonOtherStreet, 
                                             PersonOtherCity, 
                                             PersonOtherState, 
                                             PersonOtherPostalCode, 
                                             PersonOtherCountry, 
                                             PersonOtherStateCode, 
                                             PersonOtherCountryCode, 
                                             PersonOtherLatitude, 
                                             PersonOtherLongitude, 
                                             PersonOtherGeocodeAccuracy, 
                                             PersonMobilePhone, 
                                             PersonHomePhone, 
                                             PersonOtherPhone, 
                                             PersonAssistantPhone, 
                                             PersonEmail, 
                                             PersonTitle, 
                                             PersonDepartment, 
                                             PersonAssistantName, 
                                             PersonLeadSource, 
                                             PersonBirthdate, 
                                             PersonHasOptedOutOfEmail, 
                                             PersonHasOptedOutOfFax, 
                                             PersonDoNotCall, 
                                             PersonLastCURequestDate, 
                                             PersonLastCUUpdateDate, 
                                             PersonEmailBouncedReason, 
                                             PersonEmailBouncedDate                      
                                    FROM Account 
                                    WHERE Id IN: accountIds]);  
        System.debug('--- AccountController - Accounts: '+accounts.size()); 
        return accounts;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Account> getPersonAccounts(List<Id> AccountIds) {
        // Populate List from SOQL query on Account
        System.debug('--- Get AccountController - Person Accounts'); 
        List<Account> personAccounts = ([  SELECT  Id,
                                             Name,
                                             Type, 
                                             RecordTypeId, 
                                             ParentId, 
                                             BillingStreet, 
                                             BillingCity, 
                                             BillingState, 
                                             BillingPostalCode, 
                                             BillingCountry, 
                                             BillingStateCode, 
                                             BillingCountryCode, 
                                             BillingLatitude, 
                                             BillingLongitude, 
                                             BillingGeocodeAccuracy,  
                                             ShippingStreet, 
                                             ShippingCity, 
                                             ShippingState, 
                                             ShippingPostalCode, 
                                             ShippingCountry, 
                                             ShippingStateCode, 
                                             ShippingCountryCode, 
                                             ShippingLatitude, 
                                             ShippingLongitude, 
                                             ShippingGeocodeAccuracy, 
                                             Phone, 
                                             Fax, 
                                             AccountNumber, 
                                             Website, 
                                             Industry, 
                                             AnnualRevenue, 
                                             NumberOfEmployees, 
                                             Ownership, 
                                             Description, 
                                             Rating, 
                                             Site, 
                                             CurrencyIsoCode, 
                                             PersonContactId,
                                             IsPersonAccount,
                                             PersonMailingStreet, 
                                             PersonMailingCity, 
                                             PersonMailingState, 
                                             PersonMailingPostalCode, 
                                             PersonMailingCountry, 
                                             PersonMailingStateCode, 
                                             PersonMailingCountryCode, 
                                             PersonMailingLatitude, 
                                             PersonMailingLongitude, 
                                             PersonMailingGeocodeAccuracy, 
                                             PersonOtherStreet, 
                                             PersonOtherCity, 
                                             PersonOtherState, 
                                             PersonOtherPostalCode, 
                                             PersonOtherCountry, 
                                             PersonOtherStateCode, 
                                             PersonOtherCountryCode, 
                                             PersonOtherLatitude, 
                                             PersonOtherLongitude, 
                                             PersonOtherGeocodeAccuracy, 
                                             PersonMobilePhone, 
                                             PersonHomePhone, 
                                             PersonOtherPhone, 
                                             PersonAssistantPhone, 
                                             PersonEmail, 
                                             PersonTitle, 
                                             PersonDepartment, 
                                             PersonAssistantName, 
                                             PersonLeadSource, 
                                             PersonBirthdate, 
                                             PersonHasOptedOutOfEmail, 
                                             PersonHasOptedOutOfFax, 
                                             PersonDoNotCall, 
                                             PersonLastCURequestDate, 
                                             PersonLastCUUpdateDate, 
                                             PersonEmailBouncedReason, 
                                             PersonEmailBouncedDate, 
                                             AccountSource                             
                                    FROM Account 
                                    WHERE IsPersonAccount = true
                                    AND Id IN: accountIds]);  
        System.debug('--- AccountController - Person Accounts: '+personAccounts.size()); 
        return personAccounts;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Account> getBusinessAccounts(List<Id> accountIds) {
        // Populate List from SOQL query on Account
        System.debug('--- AccountController - Get Business Accounts'); 
        List<Account> businessAccounts = ([  SELECT  Id,
                                             Name,
                                             Type, 
                                             RecordTypeId, 
                                             ParentId, 
                                             BillingStreet, 
                                             BillingCity, 
                                             BillingState, 
                                             BillingPostalCode, 
                                             BillingCountry, 
                                             BillingStateCode, 
                                             BillingCountryCode, 
                                             BillingLatitude, 
                                             BillingLongitude, 
                                             BillingGeocodeAccuracy,  
                                             ShippingStreet, 
                                             ShippingCity, 
                                             ShippingState, 
                                             ShippingPostalCode, 
                                             ShippingCountry, 
                                             ShippingStateCode, 
                                             ShippingCountryCode, 
                                             ShippingLatitude, 
                                             ShippingLongitude, 
                                             ShippingGeocodeAccuracy, 
                                             Phone, 
                                             Fax, 
                                             AccountNumber, 
                                             Website, 
                                             Industry, 
                                             AnnualRevenue, 
                                             NumberOfEmployees, 
                                             Ownership, 
                                             Description, 
                                             Rating, 
                                             Site, 
                                             CurrencyIsoCode,   
                                             AccountSource                          
                                    FROM Account 
                                    WHERE IsPersonAccount = false
                                    AND Id IN: accountIds]);  
        System.debug('--- AccountController - Business Accounts: '+businessAccounts.size()); 
        return businessAccounts;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Account> getAccountAddresses() {
        // Populate List from SOQL query on Account
        System.debug('--- AccountController - Get Business Accounts'); 
        List<Account> Accounts = ([  SELECT  Id,
                                             Name, 
                                             AccountNumber,
                                             BillingStreet, 
                                             BillingCity, 
                                             BillingState, 
                                             BillingPostalCode, 
                                             BillingCountry, 
                                             BillingStateCode, 
                                             BillingCountryCode, 
                                             BillingLatitude, 
                                             BillingLongitude, 
                                             BillingGeocodeAccuracy,  
                                             ShippingStreet, 
                                             ShippingCity, 
                                             ShippingState, 
                                             ShippingPostalCode, 
                                             ShippingCountry, 
                                             ShippingStateCode, 
                                             ShippingCountryCode, 
                                             ShippingLatitude, 
                                             ShippingLongitude, 
                                             ShippingGeocodeAccuracy, 
                                             IsPersonAccount,
                                             PersonMailingStreet, 
                                             PersonMailingCity, 
                                             PersonMailingState, 
                                             PersonMailingPostalCode, 
                                             PersonMailingCountry, 
                                             PersonMailingStateCode, 
                                             PersonMailingCountryCode, 
                                             PersonMailingLatitude, 
                                             PersonMailingLongitude, 
                                             PersonMailingGeocodeAccuracy, 
                                             PersonOtherStreet, 
                                             PersonOtherCity, 
                                             PersonOtherState, 
                                             PersonOtherPostalCode, 
                                             PersonOtherCountry, 
                                             PersonOtherStateCode, 
                                             PersonOtherCountryCode, 
                                             PersonOtherLatitude, 
                                             PersonOtherLongitude, 
                                             PersonOtherGeocodeAccuracy                                             
                                    FROM Account 
                                    ORDER BY BillingCountry, BillingPostalCode]);  
        System.debug('--- AccountController - Accounts: '+Accounts.size()); 
        return Accounts;  
    }
}