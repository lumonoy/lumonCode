/*
    Created by Reijo Mattila on 22.10.2023
*/
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