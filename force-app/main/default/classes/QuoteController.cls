/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-04-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class QuoteController {
    @AuraEnabled(cacheable=true)
    public static Quote getQuote(Id recordId) {
        // Populate map from SOQL query on Quote
        List<Id> recordIds = new List<Id>{recordId};
        list<Quote> quotes = getQuotes(recordIds);
        Quote quoteRecord = quotes[0];
        System.debug('--- QuoteController - Quote Record: '+quoteRecord);
        return quoteRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static Quote getQuoteByNumber(String quoteNumber) {
        // Populate List from SOQL query on Quote
        Id quoteId = [SELECT Id FROM Quote WHERE QuoteNumber =: quoteNumber OR OfferNumber__c =: quoteNumber LIMIT 1]?.Id; 
        List<Id> quoteIds = new List<Id>();
        quoteIds.add(quoteId);
        Quote quote = new Quote();
        System.debug('--- QuoteController - Get Quote with Id '+quoteId); 
        List<Quote> quotes =  getQuotes(quoteIds); 
        if  (quotes?.size()>0) {
            quote = quotes[0];
            System.debug('--- QuoteController - Quote: '+quote.Name); 
        }        
        return quote;
    }
    @AuraEnabled(cacheable=true)
    public static List<Quote> getQuotes(List<Id> recordIds) {
        List<Quote> quotes = ([SELECT   Id, 
                                        Name, //Information
                                        QuoteNumber,
                                        Description,
                                        Status, // Status
                                        isSyncing, 
                                        QuoteAccountId,
                                        OfferNumber__c,
                                        isMigrated__c,                                        
                                        Pricebook2Id,CurrencyIsoCode, // Pricebook
                                        GrandTotal, Subtotal,TotalPrice,// Totals
                                        Discount,Tax, //deductions and additions
                                        OpportunityId, //Opportunity
                                        AccountId,
                                        ContactId,
                                        ContractId,
                                        OwnerId, 
                                        ExpirationDate,
                                        ShippingHandling,  
                                        LineItemCount,
                                        Account.BillingAddress, 
                                        Account.ShippingAddress, 
                                        Account.PersonMailingAddress, 
                                        Account.PersonOtherAddress,
                                        //Billing 
                                        BillingName,
                                        BillingAddress,
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
                                        //Shipping
                                        ShippingName,
                                        ShippingAddress,
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
                                        // Send Offer to
                                        QuoteToName,
                                        QuoteToAddress,
                                        QuoteToStreet, 
                                        QuoteToCity, 
                                        QuoteToState, 
                                        QuoteToPostalCode, 
                                        QuoteToCountry, 
                                        QuoteToStateCode, 
                                        QuoteToCountryCode, 
                                        QuoteToLatitude, 
                                        QuoteToLongitude, 
                                        QuoteToGeocodeAccuracy, 
                                        // Copy Quote To 
                                        AdditionalName,
                                        AdditionalAddress,
                                        AdditionalStreet, 
                                        AdditionalCity, 
                                        AdditionalState, 
                                        AdditionalPostalCode, 
                                        AdditionalCountry, 
                                        AdditionalStateCode, 
                                        AdditionalCountryCode, 
                                        AdditionalLatitude, 
                                        AdditionalLongitude, 
                                        AdditionalGeocodeAccuracy,
                                        // Contact Details
                                        Email, 
                                        Phone, 
                                        Fax,  
                                        CanCreateQuoteLineItems,
                                        CustomerAddress__c, 
                                        //CustomerAddress__Country__s,
                                        CustomerAddress__CountryCode__s,
                                        CustomerAddress__PostalCode__s,
                                        CustomerAddress__Street__s,
                                        CustomerAddress__City__s,
                                        //CustomerAddress__State__s,
                                        CustomerAddress__StateCode__s,
                                        CustomerAddress__Latitude__s,
                                        CustomerAddress__Longitude__s,
                                        CustomerAddress__GeocodeAccuracy__s,
                                        InvoicingAddress__c, 
                                        //InvoicingAddress__Country__s,
                                        InvoicingAddress__CountryCode__s,
                                        InvoicingAddress__PostalCode__s,
                                        InvoicingAddress__Street__s,
                                        InvoicingAddress__City__s,
                                        //InvoicingAddress__State__s,
                                        InvoicingAddress__StateCode__s,
                                        InvoicingAddress__Latitude__s,
                                        InvoicingAddress__Longitude__s,
                                        InvoicingAddress__GeocodeAccuracy__s,
                                        DeliveryAddress__c,
                                        //DeliveryAddress__Country__s,
                                        DeliveryAddress__CountryCode__s,
                                        DeliveryAddress__PostalCode__s,
                                        DeliveryAddress__Street__s,
                                        DeliveryAddress__City__s,
                                        //DeliveryAddress__State__s,
                                        DeliveryAddress__StateCode__s,
                                        DeliveryAddress__Latitude__s,
                                        DeliveryAddress__Longitude__s,
                                        DeliveryAddress__GeocodeAccuracy__s, 
                                        InstallationAddress__c,
                                        //InstallationAddress__Country__s,
                                        InstallationAddress__CountryCode__s,
                                        InstallationAddress__PostalCode__s,
                                        InstallationAddress__Street__s,
                                        InstallationAddress__City__s,
                                        //InstallationAddress__State__s,
                                        InstallationAddress__StateCode__s,
                                        InstallationAddress__Latitude__s,
                                        InstallationAddress__Longitude__s,
                                        InstallationAddress__GeocodeAccuracy__s,
                                        // Attributes
                                        BusinessType__c, BusinessTypeAttribute__c,
                                        CountryAttribute__c, 
                                        CustomerSegment__c, CustomerSegmentAttribute__c,
                                        District__c, DistrictAttribute__c,
                                        Office__c, OfficeAttribute__c,
                                        Organization__c,OrganizationAttribute__c,
                                        ProfitCenter__c, ProfitCenterAttribute__c,
                                        PropertyType__c, PropertyTypeAttribute__c,
                                        ServiceAttribute__c           
                                    FROM Quote 
                                    WHERE Id IN :recordIds
                                    OR AccountId IN :recordIds
                                    OR ContactId IN :recordIds
                                    OR OpportunityId IN :recordIds
                                    ]);
        System.debug('--- QuoteController - Quote Records : '+quotes.size());
        return quotes;
    } 
}