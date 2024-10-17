/**
 * @description       : FSL Related to check Holidays
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
trigger OperatingHoursHolidayTrigger on OperatingHoursHoliday (after insert, before delete) {
    if (Trigger.isAfter) {
        if(Trigger.isInsert) {
            OperatingHoursHolidayTriggerHandler.insertResourceAbsences(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if(Trigger.isDelete) {
            OperatingHoursHolidayTriggerHandler.deleteResourceAbsences(Trigger.old);
        }
    }
}