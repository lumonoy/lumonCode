/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingSummaryController {
    @AuraEnabled(cacheable=true)
    public static Pricing_Summary__c getPricingSummary(Id recordId) {
        Pricing_Summary__c summary = New Pricing_Summary__c();    
        List<Pricing_Summary__c> summaries = New List<Pricing_Summary__c>(); 
        List<Id> recordIds = new List<Id>();
        recordIds.add(recordId);
        summaries = getPricingSummaries(recordIds);
        if (summaries?.size()>0){
            summary = summaries[0];
        }
        return summary;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Pricing_Summary__c> getPricingSummaries(List<Id> recordIds) {
        // Populate map from SOQL query on Product2
        List<Pricing_Summary__c> summaries = ([SELECT  Id, 
                                                        Account__c,
                                                        Contract__c,
                                                        Opportunity__c,
                                                        Quote__c,
                                                        Organization__c,
                                                        Country_Code__c,
                                                        District__c,
                                                        Profit_Center__c,
                                                        Office__c,
                                                        Sales_Margin__c,
                                                        Sales_Price__c 
                                                FROM Pricing_Summary__c 
                                                WHERE Id IN:recordIds
                                                OR Opportunity__c IN: recordIds
                                                ]);
        System.debug('--- PricingSummaryController - Summary Record Count : '+summaries.size());
        return summaries;
    } 

    @AuraEnabled(cacheable=false)
    public static Id createPricingSummary(Id recordId) {
        Id summaryId;
        String flowSummaryId;
        Map<String, Object> params = new Map<String, Object>{
            'recordId' => recordId
        };
        // Create Pricing Summary if none exists using a Flow
        Flow.Interview.Assign_Summary_SubFlow summaryFlow = new Flow.Interview.Assign_Summary_SubFlow(params);
        summaryFlow.start();
        flowSummaryId = (String)summaryFlow.getvariableValue('pricingSummaryId');
        if (String.isEmpty(flowSummaryId)) {
            throw new PricingSummaryService.PricingDataException('Unable to create Pricing Summary');
        } else {
            summaryId = (Id)flowSummaryId;
            System.debug('--- PricingSummaryController - created summary: '+summaryId);
        }
        return summaryId;
    }
    @AuraEnabled(cacheable=false)
        public static Id upsertPricingSummary(Id opportunityId) {
        Opportunity opportunityRecord = new Opportunity();
        Pricing_Summary__c pricingSummaryExisting = new Pricing_Summary__c();
        Pricing_Summary__c pricingSummaryToUpsert = new Pricing_Summary__c();
        Id summaryId;
        // Check for Existing Summary
        if (String.isNotBlank(opportunityId)){
            opportunityRecord = OpportunityController.getOpportunityRecord(opportunityId);
            pricingSummaryExisting = getPricingSummary(opportunityId);
        }
        // Prepare Summary to Update
        if (String.isNotBlank(pricingSummaryExisting?.Id)){
            pricingSummaryToUpsert.Id = pricingSummaryExisting?.Id;
            pricingSummaryToUpsert.Sales_Price__c = pricingSummaryExisting?.Sales_Price__c;
        } else {
            pricingSummaryToUpsert.Opportunity__c = opportunityRecord?.Id; // Related Record
        }
            pricingSummaryToUpsert.Organization__c = opportunityRecord?.Organization_Attribute__c; // Related Record
            pricingSummaryToUpsert.Country_Code__c = opportunityRecord?.Country_Attribute__c; // Related Record
            pricingSummaryToUpsert.Business_Type__c = opportunityRecord?.Business_Type_Attribute__c;
            pricingSummaryToUpsert.District__c = opportunityRecord?.District_Attribute__c; // Related Record
            pricingSummaryToUpsert.Profit_Center__c = opportunityRecord?.Owner_Profit_Center__c; // Related Record
            //pricingSummaryToUpsert.Office__c = opportunityRecord.Office__c; // Related Record
            pricingSummaryToUpsert.User__c = opportunityRecord?.OwnerId;// Related Record
            pricingSummaryToUpsert.Account__c = opportunityRecord?.AccountId; // Related Record
            pricingSummaryToUpsert.Quote__c = opportunityRecord?.SyncedQuoteId; // Related Record
            pricingSummaryToUpsert.Order__c = opportunityRecord?.Order__c; // Related Record
            pricingSummaryToUpsert.Contract__c = opportunityRecord?.contractId; // Related Record
            pricingSummaryToUpsert.currencyIsoCode = opportunityRecord?.CurrencyIsoCode;
            pricingSummaryToUpsert.pricebookId__c = opportunityRecord?.Pricebook2Id;
        try {
            upsert (pricingSummaryToUpsert);
            summaryId = pricingSummaryToUpsert.Id;
            System.debug('--- Pricing Summary '+pricingSummaryToUpsert.Id+' Created or Updated');
        } catch(DmlException e) {
            System.debug('Exception on Pricing Summary Upsert: ' + e.getMessage());
        }
        return summaryId;
    }
}