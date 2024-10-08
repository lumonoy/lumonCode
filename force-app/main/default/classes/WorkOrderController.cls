/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-13-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class WorkOrderController {
    @AuraEnabled(cacheable=true)
    public static WorkOrder getWorkOrder(Id recordId) {
      
        System.debug('--- Get Data for WorkOrder with Id: '+recordId);
        List<Id> recordIds = new List<Id>{recordId};
        List<WorkOrder> workOrders = getWorkOrders(recordIds);
        WorkOrder workOrderRecord = workOrders[0];
        System.debug('--- WorkOrderController - WorkOrder Record: '+workOrderRecord);
        return workOrderRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static WorkOrder getWorkOrderByNumber(String workOrderNumber) {
        // Populate List from SOQL query on WorkOrder
        Id workOrderId = [SELECT Id FROM WorkOrder WHERE workOrderNumber =: workOrderNumber LIMIT 1]?.Id; 
        List<Id> workOrderIds = new List<Id>();
        workOrderIds.add(workOrderId);
        WorkOrder workOrder = new WorkOrder();
        System.debug('--- WorkOrderController - Get WorkOrder with Id '+workOrderId); 
        List<WorkOrder> workOrders =  getWorkOrders(workOrderIds); 
        if  (workOrders?.size()>0) {
            workOrder = workOrders[0];
            System.debug('--- WorkOrderController - WorkOrder: '+workOrder.Subject); 
        }        
        return workOrder;
    }
    @AuraEnabled(cacheable=true)
    public static List<WorkOrder> getWorkOrders(List<Id> recordIds) {
        // Populate map from SOQL query on WorkOrder
        System.debug('--- WorkOrderController - Get WorkOrders for recordIds: '+recordIds);
        List<WorkOrder> workOrders = ([SELECT   Id, 
                                                WorkOrderNumber, 
                                                CurrencyIsoCode, 
                                                AccountId, 
                                                ContactId,
                                                CaseId, 
                                                EntitlementId, 
                                                ServiceContractId, 
                                                AssetId, 
                                                Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                                Description, 
                                                StartDate, EndDate, 
                                                Subject, RootWorkOrderId, 
                                                Status, Priority, Tax, Subtotal, TotalPrice, LineItemCount, Pricebook2Id,
                                                Discount, GrandTotal, ParentWorkOrderId, IsClosed, IsStopped, 
                                                StopStartDate, SlaStartDate, SlaExitDate, BusinessHoursId, MilestoneStatus, 
                                                Duration, DurationType, DurationInMinutes, ServiceAppointmentCount, 
                                                WorkTypeId, ServiceTerritoryId, StatusCategory, LocationId, 
                                                MaintenancePlanId, SuggestedMaintenanceDate, MinimumCrewSize, 
                                                RecommendedCrewSize, ServiceReportTemplateId, 
                                                ReturnOrderLineItemId, ReturnOrderId, IsGeneratedFromMaintenancePlan, 
                                                ServiceReportLanguage, MaintenanceWorkRuleId, AssetWarrantyId, 
                                                ProductServiceCampaignId, ProductServiceCampaignItemId
                                                                                  
                                    FROM WorkOrder 
                                    WHERE Id IN:recordIds
                                    OR AccountId IN: recordIds
                                    OR ContactId IN: recordIds
                                    OR CaseId IN: recordIds
                                    ]);
        System.debug('--- WorkOrderController - WorkOrder Record Count : '+workOrders.size());
        return workOrders;
    } 
}