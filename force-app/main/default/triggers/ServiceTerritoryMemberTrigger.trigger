/*
    Created by Reijo Mattila on 22.10.2023
*/
trigger ServiceTerritoryMemberTrigger on ServiceTerritoryMember (after insert, before delete) {
    if (Trigger.isAfter) {
        if(Trigger.isInsert) {
            ServiceTerritoryMemberTriggerHandler.insertResourceAbsences(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if(Trigger.isDelete) {
            ServiceTerritoryMemberTriggerHandler.deleteResourceAbsences(Trigger.old);
        }
    }
}