trigger ServiceAppointmentTrigger on ServiceAppointment (after update) {
    new ServiceAppointmentTriggerHandler().run();
}