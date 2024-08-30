/*
    Created by Reijo Mattila on 22.10.2023
*/
public class ServiceTerritoryMemberTriggerHandler {

    public static Boolean dontRunInsertTriggerForTest = false;
    
    public static void insertResourceAbsences(List<ServiceTerritoryMember> scope){
        for(ServiceTerritoryMember stm : scope){
            insertMemberAbsences(stm.Id);
        }
    }

    @future
    public static void insertMemberAbsences(String stmId){
        if(dontRunInsertTriggerForTest != true){
            try{
                ServiceTerritoryMember stm = [SELECT Id, ServiceTerritoryId, ServiceResourceId FROM ServiceTerritoryMember WHERE Id =: stmId];
                ServiceTerritory st = [SELECT Id, OperatingHoursId FROM ServiceTerritory WHERE Id =: stm.ServiceTerritoryId][0];
                List<OperatingHoursHoliday> ohhs = new List<OperatingHoursHoliday>();
                ohhs = [SELECT Id, OperatingHoursId, Holiday.ActivityDate, HolidayId, Holiday.Name FROM OperatingHoursHoliday WHERE OperatingHoursId =: st.OperatingHoursId];
                Set<Id> holidayIds = new Set<Id>();
                for(OperatingHoursHoliday ooh : ohhs){
                    holidayIds.add(ooh.Id);
                }
                List<ResourceAbsence> oldAbsences = new List<ResourceAbsence>();
                oldAbsences = [SELECT Id, ResourceId, Operating_Hours_Holiday__c FROM ResourceAbsence WHERE ResourceId =: stm.ServiceResourceId AND Operating_Hours_Holiday__c in: holidayIds];
                Set<String> oldHolidaysSet = new Set<String>();
                for(ResourceAbsence ra : oldAbsences){
                    oldHolidaysSet.add(ra.Operating_Hours_Holiday__c);
                }
                Id raRtId = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByName().get('Non Availability').getRecordTypeId();
                List<ResourceAbsence> raAdditions = new List<ResourceAbsence>();

                for(OperatingHoursHoliday ohh : ohhs){
                    if(!oldHolidaysSet.contains(ohh.Id)){
                        DateTime start = DateTime.newInstance(ohh.Holiday.ActivityDate.year(), ohh.Holiday.ActivityDate.month(), ohh.Holiday.ActivityDate.day(), 00, 00, 01);
                        DateTime end2 = DateTime.newInstance(ohh.Holiday.ActivityDate.year(), ohh.Holiday.ActivityDate.month(), ohh.Holiday.ActivityDate.day(), 23, 59, 59);
                        raAdditions.add(new ResourceAbsence(ResourceId = stm.ServiceResourceId, Start = start, End = end2, HolidayId__c = ohh.HolidayId, Operating_Hours_Holiday__c = ohh.Id, Service_Territory__c = stm.ServiceTerritoryId, FSL__Approved__c = true, Approval_handled_by__c = 'System', FSL__GanttLabel__c = ohh.Holiday.Name, Description = ohh.Holiday.Name, RecordTypeId = raRtId, Type = 'Public Holiday'));
                    }
                }
                if(!raAdditions.isEmpty()){
                    insert raAdditions;
                }
            }
            catch(Exception e){
                System.debug('Error when adding Resource Absence from Member Trigger with Error: '+e);
            }
        }    
    }

    public static void deleteResourceAbsences(List<ServiceTerritoryMember> scope){
        try{
            Set<Id> resourceIds = new Set<Id>();
            Set<Id> memberIds = new Set<Id>();
            for(ServiceTerritoryMember stm : scope){
                resourceIds.add(stm.ServiceResourceId);
                memberIds.add(stm.Id);
            }
            List<ServiceTerritoryMember> allMemberships = [SELECT Id, ServiceResourceId, ServiceTerritory.OperatingHours.Name FROM ServiceTerritoryMember WHERE ServiceResourceId in: resourceIds];
            List<ServiceTerritoryMember> scopeMemberships = [SELECT Id, ServiceResourceId, ServiceTerritory.OperatingHours.Name FROM ServiceTerritoryMember WHERE Id in: memberIds];
            Map<String, Integer> resourceToMembershipMap = new Map<String, Integer>();
            for(ServiceTerritoryMember stm : allMemberships){
                if(resourceToMembershipMap.get(stm.ServiceResourceId+'/'+stm.ServiceTerritory.OperatingHours.Name) == null){
                    resourceToMembershipMap.put(stm.ServiceResourceId+'/'+stm.ServiceTerritory.OperatingHours.Name, 1);
                }
                else{
                    resourceToMembershipMap.put(stm.ServiceResourceId+'/'+stm.ServiceTerritory.OperatingHours.Name, resourceToMembershipMap.get(stm.ServiceResourceId+'/'+stm.ServiceTerritory.OperatingHours.Name) + 1);
                }
            }
            Set<Id> filteredResourceIds = new Set<Id>();
            for(ServiceTerritoryMember stm : scopeMemberships){
                if(resourceToMembershipMap.get(stm.ServiceResourceId+'/'+stm.ServiceTerritory.OperatingHours.Name) == 1){
                    filteredResourceIds.add(stm.ServiceResourceId);
                }
            }
            if(!filteredResourceIds.isEmpty()){
                delete [SELECT id FROM ResourceAbsence WHERE ResourceId in: filteredResourceIds];
            }
        }
        catch(Exception e){
            System.debug('Error when deleting Resource Absence from Member Trigger with Error: '+e);
        }    
    }
}