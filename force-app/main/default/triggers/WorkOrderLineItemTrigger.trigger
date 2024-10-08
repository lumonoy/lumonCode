/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-18-2024
 * @last modified by  : Henk Reynders
**/

trigger WorkOrderLineItemTrigger on WorkOrderLineItem (before insert, before update, after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            WorkOrderLineItemTriggerHandler.getRemoteInstallationDocuments(Trigger.new); // 18.08.2024 Added to  fetch remote files
        }
        if (Trigger.isUpdate) {
            //WorkOrderLineItemTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap);
            //WorkOrderLineItemTriggerHandler.getRemoteInstallationDocuments(Trigger.new); // 18.08.2024 Added to  fetch remote files
            WorkOrderLineItemTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap, false); //Added resubmitOrder as part of LUM-1282
        }
    }
}