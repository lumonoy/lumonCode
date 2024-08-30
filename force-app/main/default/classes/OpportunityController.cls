/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class OpportunityController {
    public static final List<String> ALLOWED_OPPORTUNITY_STAGES = new List<String>{
        //'Preparation & Analysis',
        'Quoting'
    };
    @AuraEnabled(cacheable=false)
    public static Opportunity getOpportunityRecord(Id opportunityId) {
        // Populate map from SOQL query on Opportunity
        System.debug('--- Get Data for Opportunity: '+opportunityId);
        List<Id> recordIds = new List<Id>{opportunityId};
        List<Opportunity> opportunities = getOpportunities(recordIds);
        Opportunity opportunityRecord = opportunities[0];
        System.debug('--- Opportunity Record: '+opportunityRecord);
        return opportunityRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static List<Opportunity> getOpportunities(List<Id> recordIds) {
        // Populate map from SOQL query on Opportunity
        List<Opportunity> opportunities = ([SELECT    Id, Name, Order_type__c, Type, //Information
                                                            StageName, isClosed, // Status
                                                            Amount, CurrencyIsoCode, // Totals
                                            				Chargeable__c,
                                                            Pricebook2Id,SyncedQuoteId, //Pricing Records
                                                            Opportunity_Number__c, //RVN Number
                                                            Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                                                            District_Attribute__c,Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                                                            Owner_Profit_Center__c, Customer_Attribute__c, //Tier 3 Sales Prices   
                                                            Method_of_Payment__c, Terms_of_Payment__c,
                                                            Invoice_type__c,   
                                                            Delivery_Term__c, Delivery_Method__c,
                                                            closeDate,
                                                            AccountId,
                                                            Order__c,
                                                            ContractId,
                                                            OwnerId,
                                                            Account.BillingAddress, 
                                                            Account.ShippingAddress, 
                                                            Account.PersonMailingAddress, 
                                                            Account.PersonOtherAddress,
                                                            Customer_Address__c, 
                                                            //Customer_Address__Country__s,
                                                            Customer_Address__CountryCode__s,
                                                            Customer_Address__PostalCode__s,
                                                            Customer_Address__Street__s,
                                                            Customer_Address__City__s,
                                                            //Customer_Address__State__s,
                                                            Customer_Address__StateCode__s,
                                                            Customer_Address__Latitude__s,
                                                            Customer_Address__Longitude__s,
                                                            Customer_Address__GeocodeAccuracy__s,
                                                            Invoicing_Address__c, 
                                                            //Invoicing_Address__Country__s,
                                                            Invoicing_Address__CountryCode__s,
                                                            Invoicing_Address__PostalCode__s,
                                                            Invoicing_Address__Street__s,
                                                            Invoicing_Address__City__s,
                                                            //Invoicing_Address__State__s,
                                                            Invoicing_Address__StateCode__s,
                                                            Invoicing_Address__Latitude__s,
                                                            Invoicing_Address__Longitude__s,
                                                            Invoicing_Address__GeocodeAccuracy__s,
                                                            Delivery_Address__c,
                                                            //Delivery_Address__Country__s,
                                                            Delivery_Address__CountryCode__s,
                                                            Delivery_Address__PostalCode__s,
                                                            Delivery_Address__Street__s,
                                                            Delivery_Address__City__s,
                                                            //Delivery_Address__State__s,
                                                            Delivery_Address__StateCode__s,
                                                            Delivery_Address__Latitude__s,
                                                            Delivery_Address__Longitude__s,
                                                            Delivery_Address__GeocodeAccuracy__s, 
                                                            Installation_Address__c,
                                                            //Installation_Address__Country__s,
                                                            Installation_Address__CountryCode__s,
                                                            Installation_Address__PostalCode__s,
                                                            Installation_Address__Street__s,
                                                            Installation_Address__City__s,
                                                            //Installation_Address__State__s,
                                                            Installation_Address__StateCode__s,
                                                            Installation_Address__Latitude__s,
                                                            Installation_Address__Longitude__s,
                                                            Installation_Address__GeocodeAccuracy__s,
                                                            Delivery_Date__c, Delivery_Week__c,
                                                            Promised_Date__c,Promised_Week__c,  
                                                            Project__c,Project_Number__c,Parent_Project__c,
                                            				Case__c
                                            
                                    FROM Opportunity 
                                    WHERE Id IN :recordIds
                                      OR accountId IN : recordIds]);
        System.debug('--- Opportunity Records: '+opportunities.size());
        return opportunities;
    } 
}