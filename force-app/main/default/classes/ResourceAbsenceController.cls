/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-29-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ResourceAbsenceController {
    public static ResourceAbsence getResourceAbsence(Id absenceId) {
        // Populate List from SOQL query on ResourceAbsence
        List<Id> absenceIds = new List<Id>();
        absenceIds.add(absenceId);
        System.debug('--- ResourceAbsenseController - Get ResourceAbsence with Id '+absenceId); 
        List<ResourceAbsence> resourceAbsences =  getResourceAbsences(new List<Id>{absenceId});  
        ResourceAbsence resourceAbsence = resourceAbsences[0];
        System.debug('--- ResourceAbsenseController - ResourceAbsence: '+resourceAbsence.AbsenceNumber); 
        return resourceAbsence;  
    }
    @AuraEnabled(cacheable=false)
    public static List<ResourceAbsence> getResourseAbsencesByType(String absenceType) {
        // Populate List from SOQL query on ResourceAbsence
        Id resourceAbsenceId = [SELECT Id FROM ResourceAbsence WHERE Type =: absenceType LIMIT 1]?.Id; 
        List<Id> resourceAbsenceIds = new List<Id>();
        resourceAbsenceIds.add(resourceAbsenceId);
        ResourceAbsence resourceAbsence = new ResourceAbsence();
        System.debug('--- ResourceAbsenseController - Get Customer with Id '+resourceAbsenceId); 
        List<ResourceAbsence> resourceAbsences =  getResourceAbsences(resourceAbsenceIds);    
        return resourceAbsences;
    }
    @AuraEnabled(cacheable=false)
    public static List<ResourceAbsence> getResourseAbsencesByResource(Id resourceId) {
        // Populate List from SOQL query on ResourceAbsence
        List<ResourceAbsence> absences = new List<ResourceAbsence>();
        absences = getResourceAbsences(new List<Id> {resourceId});
        return absences;
    }
    @AuraEnabled(cacheable=false)
    public static List<ResourceAbsence> getResourceAbsences(List<Id> recordIds) {
        // Populate List from SOQL query on ResourceAbsence
        System.debug('--- ResourceAbsenseController - Get Absences'); 
        List<ResourceAbsence> absences = ([ SELECT Id, 
                                                    AbsenceNumber, 
                                                    RecordTypeId, RecordType.DeveloperName , 
                                                    ResourceId, 
                                                    Type, Description, 
                                                    Start, End, Street, 
                                                    Address, 
                                                    FSL__Approved__c, FSL__Duration_In_Minutes__c, 
                                                    FSL__EstTravelTimeFrom__c, FSL__EstTravelTime__c, 
                                                    FSL__EstimatedTravelDistanceFrom__c, FSL__EstimatedTravelDistanceTo__c, 
                                                    FSL__Estimated_Travel_Time_From_Source__c, FSL__Estimated_Travel_Time_To_Source__c, 
                                                    FSL__GanttLabel__c, FSL__Gantt_Color__c, 
                                                    FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s, 
                                                    FSL__InternalSLRGeolocation__c, 
                                                    FSL__Last_Updated_Epoch__c, 
                                                    FSL__Scheduling_Policy_Used__c
                                                    //Approval_handled_by__c 
                                                FROM ResourceAbsence
                                                    WHERE Id IN: recordIds
                                                    OR ResourceId IN: recordIds
                                                    OR RecordTypeId IN: recordIds]);  
        System.debug('--- ResourceAbsenseController - Absences: '+absences.size()); 
        return absences;  
    }
}