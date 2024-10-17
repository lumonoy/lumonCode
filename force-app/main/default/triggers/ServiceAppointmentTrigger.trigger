/**
 * @description       : FSL Related to check ?
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
trigger ServiceAppointmentTrigger on ServiceAppointment (after update) {
    new ServiceAppointmentTriggerHandler().run();
}