/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-04-2023
 * @last modified by  : Henk Reynders
**/

trigger WorkOrderLineItemTrigger on WorkOrderLineItem (before insert, before update, after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            //WorkOrderLineItemTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap);
            WorkOrderLineItemTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap, false); //Added resubmitOrder as part of LUM-1282
        }
    }
}