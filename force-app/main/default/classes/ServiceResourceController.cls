/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-29-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ServiceResourceController {
    public static ServiceResource getServiceResource(Id resourceId) {
        // Populate List from SOQL query on ServiceResource
        List<Id> resourceIds = new List<Id>();
        resourceIds.add(resourceId);
        System.debug('--- ServiceResourceController - Get ServiceResource with Id '+resourceId); 
        List<ServiceResource> serviceResources =  getServiceResources(new List<Id>{resourceId});  
        ServiceResource serviceResource = serviceResources[0];
        System.debug('--- ServiceResourceController - ServiceResource: '+serviceResource.Name); 
        return serviceResource;  
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceResource> getResourseAbsencesByType(String resourceType) {
        // Populate List from SOQL query on ServiceResource
        Id serviceResourceId = [SELECT Id FROM ServiceResource WHERE ResourceType =: resourceType LIMIT 1]?.Id; 
        List<Id> serviceResourceIds = new List<Id>();
        serviceResourceIds.add(serviceResourceId);
        ServiceResource serviceResource = new ServiceResource();
        System.debug('--- ServiceResourceController - Get Customer with Id '+serviceResourceId); 
        List<ServiceResource> serviceResources =  getServiceResources(serviceResourceIds);    
        return serviceResources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceResource> getResourseAbsencesByRelatedRecord(Id relatedId) {
        // Populate List from SOQL query on ServiceResource
        List<ServiceResource> resources = new List<ServiceResource>();
        resources = getServiceResources(new List<Id> {relatedId});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceResource> getResourseAbsencesByCrew(Id crewId) {
        // Populate List from SOQL query on ServiceResource
        List<ServiceResource> resources = new List<ServiceResource>();
        resources = getServiceResources(new List<Id> {crewId});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceResource> getResourseAbsencesByAccount(Id accountId) {
        // Populate List from SOQL query on ServiceResource
        List<ServiceResource> resources = new List<ServiceResource>();
        resources = getServiceResources(new List<Id> {accountId});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceResource> getServiceResources(List<Id> recordIds) {
        // Populate List from SOQL query on ServiceResource
        System.debug('--- ServiceResourceController - Get Absences'); 
        List<ServiceResource> resources = ([ SELECT Id, OwnerId, Name, 
                                                    RelatedRecordId, 
                                                    ResourceType, 
                                                    Description, 
                                                    IsActive, IsCapacityBased, IsOptimizationCapable, 
                                                    LastKnownLatitude, LastKnownLongitude, 
                                                    LastKnownLocation, LastKnownLocationDate, 
                                                    LocationId, 
                                                    ServiceCrewId, 
                                                    AccountId, 
                                                    SchedulingConstraintId, 
                                                    FSL__Efficiency__c, FSL__GanttLabel__c, 
                                                    FSL__Online_Offset__c, FSL__Picture_Link__c, 
                                                    FSL__Priority__c, FSL__Travel_Speed__c 
                                                FROM ServiceResource
                                                    WHERE Id IN: recordIds
                                                    OR RelatedRecordId IN: recordIds
                                                    OR ServiceCrewId IN: recordIds
                                                    OR AccountId IN: recordIds]);  
        System.debug('--- ServiceResourceController - Absences: '+resources.size()); 
        return resources;  
    }
}