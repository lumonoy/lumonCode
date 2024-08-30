/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
trigger OrderTrigger on Order (before insert, before update, after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //OrderTriggerHandler.createOrderLineItems(trigger.new,true);
            OrderTriggerHandler.upsertOrderLineItems(trigger.new,trigger.oldMap,true);
        }
        else if (Trigger.isUpdate) {
            if(!OrderTriggerHandler.checkRecursion){
                OrderTriggerHandler.checkRecursion = TRUE;
                //OrderTriggerHandler.upsertOrderLineItems(trigger.new,trigger.oldMap,true);
            }
            OrderGenerator.populateOrderJSONForActivatedOrders(Trigger.new, Trigger.oldMap);
        }
    }
}