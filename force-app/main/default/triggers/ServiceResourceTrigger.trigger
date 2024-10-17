/**
 * @description       : FSL Related to check Absences
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
trigger ServiceResourceTrigger on ServiceResource (after update) {
    if (Trigger.isAfter) {
        if(Trigger.isUpdate) {
            ServiceResourceTriggerHandler.checkActiveForAbsences(Trigger.newMap, Trigger.oldMap);
        }
    }
}