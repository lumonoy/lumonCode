/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-04-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class OpportunityController {
    @AuraEnabled(cacheable=false)
    public static Opportunity getOpportunityRecord(Id opportunityId) {
        // Populate map from SOQL query on Opportunity
        List<Id> recordIds = new List<Id>{opportunityId};
        List<Opportunity> opportunities = getOpportunities(recordIds);
        Opportunity opportunityRecord = opportunities[0];
        System.debug('--- OpportunityController - Opportunity Record: '+opportunityRecord);
        return opportunityRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static Opportunity getOpportunityByNumber(String opportunityNumber) {
        // Populate List from SOQL query on Account
        Id opportunityId = [SELECT Id FROM Opportunity WHERE OpportunityNumber__c =: opportunityNumber LIMIT 1]?.Id; 
        List<Id> opportunityIds = new List<Id>();
        opportunityIds.add(opportunityId);
        Opportunity opportunity = new Opportunity();
        List<Opportunity> opportunities =  getOpportunities(opportunityIds); 
        if  (opportunities?.size()>0) {
            opportunity = opportunities[0];
            System.debug('--- OpportunityController - Opportunity: '+opportunity.Name); 
        }        
        return opportunity;
    }
    @AuraEnabled(cacheable=false)
    public static List<Opportunity> getOpportunities(List<Id> recordIds) {
        // Populate map from SOQL query on Opportunity
        List<Opportunity> opportunities = ([SELECT  Id, Name, 
                                                        AccountId,                                                           
                                                        ContractId,
                                                        OwnerId,
                                                        Type, //Information
                                                        StageName, 
                                                        CloseDate,isClosed, // Status
                                                        Amount, CurrencyIsoCode, // Totals                                                       
                                                        Pricebook2Id,
                                                        SyncedQuoteId, CurrentOfferNumber__c,
                                                        OpportunityNumber__c,
                                                        isMigrated__c,
                                                        Account.BillingAddress, 
                                                        Account.ShippingAddress, 
                                                        Account.PersonMailingAddress, 
                                                        Account.PersonOtherAddress,
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
                                                        //Office__c, OfficeAttribute__c,
                                                        Organization__c,OrganizationAttribute__c,
                                                        ProfitCenter__c, ProfitCenterAttribute__c,
                                                        PropertyType__c, PropertyTypeAttribute__c,
                                                        ServiceAttribute__c                                           
                                    FROM Opportunity 
                                    WHERE Id IN :recordIds
                                      OR accountId IN : recordIds]);
        System.debug('--- OpportunityController - Opportunity Records: '+opportunities.size());
        return opportunities;
    } 
}