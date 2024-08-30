/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/

public class ReSubmitWorkOrderLIController {
    @AuraEnabled
    public static void reSubmitWOLI(String woliId){
        if(String.isNotBlank(woliId)){
            WorkOrderLineItem woliObj = new WorkOrderLineItem();
            woliObj = [Select id,RVN_Number__c,Status,LastModifiedById,StartDate,
                       EndDate,Install_Expense__c,Duration from WorkOrderLineItem where Id =: woliId];
            WorkOrderLineItemTriggerHandler.populateJSON(new List<WorkOrderLineItem>{woliObj},
                                                         new Map<Id,WorkOrderLineItem>(),true);
        }
    }
}