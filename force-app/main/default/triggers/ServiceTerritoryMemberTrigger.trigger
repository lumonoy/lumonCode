/**
 * @description       : FSL Related to check ?
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
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