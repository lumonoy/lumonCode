/*
    Created by Reijo Mattila on 22.10.2023
*/
trigger ServiceResourceTrigger on ServiceResource (after update) {
    if (Trigger.isAfter) {
        if(Trigger.isUpdate) {
            ServiceResourceTriggerHandler.checkActiveForAbsences(Trigger.newMap, Trigger.oldMap);
        }
    }
}