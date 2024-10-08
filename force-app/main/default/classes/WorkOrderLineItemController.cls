/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-13-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class WorkOrderLineItemController {
    @AuraEnabled(cacheable=true)
    public static WorkOrderLineItem getWorkOrderLineItem(Id recordId) {  
        System.debug('--- WorkOrderLineItemController - Get Work Order Line Item with Id: '+recordId);
        List<Id> recordIds = new List<Id>{recordId};
        List<WorkOrderLineItem> workOrderLineItems = getWorkOrderLineItems(recordIds);
        WorkOrderLineItem workOrderLineItemRecord = workOrderLineItems[0];
        System.debug('--- WorkOrderLineItemController - Work Order Line Item Record: '+workOrderLineItemRecord);
        return workOrderLineItemRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<WorkOrderLineItem> getWorkOrderLineItems(List<Id> recordIds) {
        // Populate map from SOQL query on QuotelineItem
        List<WorkOrderLineItem> workOrderLineItems = ([ SELECT  Id,
                                                            LineItemNumber, 
                                                            CurrencyIsoCode, 
                                                            WorkOrderId, 
                                                            ParentWorkOrderLineItemId, 
                                                            Product2Id, 
                                                            AssetId, 
                                                            OrderId, 
                                                            RootWorkOrderLineItemId, 
                                                            Description, 
                                                            StartDate, 
                                                            EndDate, 
                                                            Status, 
                                                            PricebookEntryId, 
                                                            Quantity, 
                                                            UnitPrice, 
                                                            Discount, 
                                                            ListPrice, 
                                                            Subtotal, 
                                                            TotalPrice, 
                                                            Duration, DurationType, DurationInMinutes, 
                                                            WorkTypeId, 
                                                            Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                                            ServiceTerritoryId, 
                                                            Subject, 
                                                            StatusCategory, IsClosed, Priority, 
                                                            ServiceAppointmentCount, LocationId, 
                                                            MinimumCrewSize, RecommendedCrewSize, ServiceReportTemplateId, 
                                                            ReturnOrderLineItemId, ReturnOrderId, 
                                                            SuggestedMaintenanceDate, MaintenancePlanId, IsGeneratedFromMaintenancePlan, MaintenanceWorkRuleId, 
                                                            AssetWarrantyId, 
                                                            ProductServiceCampaignId, ProductServiceCampaignItemId, 
                                                            FSL__IsFillInCandidate__c, FSL__VisitingHours__c, 
                                                            Work_duration_in_minutes__c, 
                                                            Configuration_Product__c, Installed_By2__c, Installed_By__c, Is_installable__c, Opportunity_Product__c, RVN_Number__c, 
                                                            Installable_Product__c, 
                                                            Product_name__c, Product__c, Is_Reclamation__c, Combination_name__c, 
                                                            Install_Expense__c, Config_Product_name__c, 
                                                            Floor__c, Line__c, Apartment_number__c, 
                                                            Original_WOLI_Id__c, Combined_info__c,
                                                            RemoteFile__c, RemoteFolder__c
                                            FROM WorkOrderLineItem
                                            WHERE Id IN :recordIds
                                                OR WorkOrderId IN :recordIds
                                                OR OrderId IN :recordIds
                                                OR AssetId IN :recordIds
                                            ORDER BY WorkOrderId,LineItemNumber]);
        System.debug('--- WorkOrderLineItemController - Work Order Line Items: '+workOrderLineItems);                                         
        return workOrderLineItems;
    }                                         
}