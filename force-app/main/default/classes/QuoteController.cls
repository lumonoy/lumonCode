/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class QuoteController {
    @AuraEnabled(cacheable=true)
    public static Quote getQuoteRecord(Id recordId) {
        // Populate map from SOQL query on Quote
        List<Id> recordIds = new List<Id>{recordId};
        list<Quote> quotes = getQuotes(recordIds);
        Quote quoteRecord = quotes[0];
        System.debug('--- Quote Record: '+quoteRecord);
        return quoteRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Quote> getQuotes(List<Id> recordIds) {
        List<Quote> quotes = ([SELECT   Id, 
                                        Name, //Information
                                        QuoteNumber,
                                        Description,
                                        Status, // Status
                                        isSyncing, 
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
                                        Additional_Agreements__c, 
                                        Customer_reference__c
                                    FROM Quote 
                                    WHERE Id IN :recordIds
                                    OR AccountId IN :recordIds
                                    OR ContactId IN :recordIds
                                    OR OpportunityId IN :recordIds
                                    ]);
        System.debug('--- Quote Records : '+quotes.size());
        return quotes;
    } 
}