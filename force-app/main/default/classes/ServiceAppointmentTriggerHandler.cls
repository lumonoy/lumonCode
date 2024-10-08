/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ServiceAppointmentTriggerHandler extends TriggerHandler {
    private Map<Id, ServiceAppointment> newMap;
    private Map<Id, ServiceAppointment> oldMap;
    private List<ServiceAppointment> newRecords;
    private List<ServiceAppointment> oldRecords;

    public ServiceAppointmentTriggerHandler() {
        this.newMap = (Map<Id, ServiceAppointment>) Trigger.newMap;
        this.oldMap = (Map<Id, ServiceAppointment>) Trigger.oldMap;
        this.newRecords = (List<ServiceAppointment>) Trigger.new;
        this.oldRecords = (List<ServiceAppointment>) Trigger.old;
    }

    public override void afterUpdate() {
        ServiceAppointmentService.createInstallationPDF(this.newRecords, this.oldMap);
    }

}