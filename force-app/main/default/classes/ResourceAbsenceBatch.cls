/*
    Created by Reijo Mattila on 22.10.2023
*/
global class ResourceAbsenceBatch implements Database.Batchable<sObject>, Database.Stateful{
    private String triggerType;
    private String queryString;
    private String holidayId;
    private String operatingHoursId;

    public ResourceAbsenceBatch(String triggerType2, String holidayRecordId, String operatingHoursId2){         
        holidayId = holidayRecordId;
        operatingHoursId = operatingHoursId2;
        triggerType = triggerType2;
        if(triggerType == 'Insert'){
            queryString = 'SELECT Id, ServiceResourceId, ServiceTerritoryId FROM ServiceTerritoryMember WHERE ServiceTerritory.OperatingHoursId =: operatingHoursId AND ServiceResource.isActive = true ORDER BY ServiceResourceId ASC';
        }
        else if(triggerType == 'Delete'){
            queryString = 'Select Id FROM ResourceAbsence WHERE Operating_Hours_Holiday__c =: holidayId';
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) { 
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try{
            if(triggerType == 'Insert'){
                Id raRtId = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByName().get('Non Availability').getRecordTypeId();
                List<ServiceTerritoryMember> stmScope = scope;
                List<ServiceTerritoryMember> noDuplicatesScope = new List<ServiceTerritoryMember>();
                OperatingHoursHoliday hol = [SELECT Id, Holiday.ActivityDate, Holiday.Name, HolidayId FROM OperatingHoursHoliday WHERE Id =: holidayId];
                Set<Id> resourceIds = new Set<Id>();
                for(ServiceTerritoryMember stm : stmScope){
                    if(!resourceIds.contains(stm.ServiceResourceId)){
                        noDuplicatesScope.add(stm);
                    }
                    resourceIds.add(stm.ServiceResourceId);
                }
                List<ResourceAbsence> oldAbsences = new List<ResourceAbsence>();
                oldAbsences = [SELECT Id, ResourceId FROM ResourceAbsence WHERE ResourceId in: resourceIds AND Operating_Hours_Holiday__c =: holidayId];
                Set<String> oldAbsencesResourceIds = new Set<String>();
                for(ResourceAbsence ra : oldAbsences){
                    oldAbsencesResourceIds.add(ra.ResourceId);
                }
                DateTime start = DateTime.newInstance(hol.Holiday.ActivityDate.year(), hol.Holiday.ActivityDate.month(), hol.Holiday.ActivityDate.day(), 00, 00, 01);
                DateTime end2 = DateTime.newInstance(hol.Holiday.ActivityDate.year(), hol.Holiday.ActivityDate.month(), hol.Holiday.ActivityDate.day(), 23, 59, 59);
                List<ResourceAbsence> raAdditions = new List<ResourceAbsence>();
                for(ServiceTerritoryMember stm : noDuplicatesScope){
                    if(!oldAbsencesResourceIds.contains(stm.ServiceResourceId)){
                        raAdditions.add(new ResourceAbsence(ResourceId = stm.ServiceResourceId, Start = start, End = end2, HolidayId__c = hol.HolidayId, Operating_Hours_Holiday__c = holidayId, Service_Territory__c = stm.ServiceTerritoryId, FSL__Approved__c = true, Approval_handled_by__c = 'System', FSL__GanttLabel__c = hol.Holiday.Name, Description = hol.Holiday.Name, RecordTypeId = raRtId, Type = 'Public Holiday'));
                    }
                }
                insert raAdditions;
            }
            else if(triggerType == 'Delete'){
                delete scope;
            }
        }
        catch(Exception e){
            System.debug('Error when running ResourceAbsenceBatch with Trigger type '+triggerType+', Error: '+e);
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}