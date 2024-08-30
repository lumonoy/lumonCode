/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class FSL_ScheduleAppointmentFlow {
    @InvocableMethod
    public static void reserveAppointment(List<List<String>> workOrderIdLists) {
        try{
            Set<String> woIds = new Set<String>();
            for(List<String> slist : workOrderIdLists){
                for(String wo : slist){
                    woIds.add(wo);
                }
            }    
            List<ServiceAppointment> sas = [SELECT Id FROM ServiceAppointment WHERE ParentRecordId in: woIds];
            if(!sas.isEmpty()){
                String pId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Custom Component Reservation' LIMIT 1].Id;
                for(ServiceAppointment sa : sas){
                    //Call FSL Booking(Reserve) method
                    callSchedule(pId, sa.Id);
                }
            }
        }
        catch(Exception e){
            system.debug('Error when reserving slot: '+e);
        }   
    }
    @future
    public static void callSchedule(String pId, String saId){
        //Call FSL Booking(Reserve) method
        FSL.ScheduleService.ScheduleExtended(pId, saId);
    }
}