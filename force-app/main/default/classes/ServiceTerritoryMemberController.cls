/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-29-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ServiceTerritoryMemberController {
    public static ServiceTerritoryMember getServiceTerritoryMember(Id resourceId) {
        // Populate List from SOQL query on ServiceTerritoryMember
        List<Id> resourceIds = new List<Id>();
        resourceIds.add(resourceId);
        System.debug('--- ServiceTerritoryMemberController - Get ServiceTerritoryMember with Id '+resourceId); 
        List<ServiceTerritoryMember> serviceTerritoryMembers =  getServiceTerritoryMembers(new List<Id>{resourceId});  
        ServiceTerritoryMember serviceTerritoryMember = serviceTerritoryMembers[0];
        System.debug('--- ServiceTerritoryMemberController - ServiceTerritoryMember: '+serviceTerritoryMember.MemberNumber); 
        return serviceTerritoryMember;  
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritoryMember> getServiceTerritoryMemberByType(String TerritoryType) {
        // Populate List from SOQL query on ServiceTerritoryMember
        Id serviceTerritoryMemberId = [SELECT Id FROM ServiceTerritoryMember WHERE TerritoryType=: TerritoryType LIMIT 1]?.Id; 
        List<Id> serviceTerritoryMemberIds = new List<Id>();
        serviceTerritoryMemberIds.add(serviceTerritoryMemberId);
        ServiceTerritoryMember serviceTerritoryMember = new ServiceTerritoryMember();
        List<ServiceTerritoryMember> serviceTerritoryMembers =  getServiceTerritoryMembers(serviceTerritoryMemberIds);    
        return serviceTerritoryMembers;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritoryMember> getResourseAbsencesByRelatedRecord(Id relatedId) {
        // Populate List from SOQL query on ServiceTerritoryMember
        List<ServiceTerritoryMember> resources = new List<ServiceTerritoryMember>();
        resources = getServiceTerritoryMembers(new List<Id> {relatedId});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritoryMember> getResourseAbsencesByCrew(Id crewId) {
        // Populate List from SOQL query on ServiceTerritoryMember
        List<ServiceTerritoryMember> resources = new List<ServiceTerritoryMember>();
        resources = getServiceTerritoryMembers(new List<Id> {crewId});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritoryMember> getServiceTerritoryMembersByNumber(String memberNumber) {
        // Populate List from SOQL query on ServiceTerritoryMember
        
        List<ServiceTerritoryMember> resources = new List<ServiceTerritoryMember>();
        resources = getServiceTerritoryMembers(new List<Id> {memberNumber});
        return resources;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritoryMember> getServiceTerritoryMembers(List<Id> recordIds) {
        // Populate List from SOQL query on ServiceTerritoryMember
        System.debug('--- ServiceTerritoryMemberController - Get Absences'); 
        List<ServiceTerritoryMember> resources = ([ SELECT Id, 
                                                    MemberNumber, 
                                                    ServiceTerritoryId, 
                                                    ServiceResourceId, 
                                                    TerritoryType, 
                                                    EffectiveStartDate, 
                                                    EffectiveEndDate,  
                                                    Address, 
                                                    OperatingHoursId, TravelModeId, 
                                                    FSL__Internal_SLR_HomeAddress_Geolocation__Latitude__s, 
                                                    FSL__Internal_SLR_HomeAddress_Geolocation__Longitude__s,
                                                    FSL__Internal_SLR_HomeAddress_Geolocation__c
                                                FROM ServiceTerritoryMember
                                                    WHERE Id IN: recordIds
                                                    OR ServiceTerritoryId IN: recordIds
                                                    OR ServiceResourceId IN: recordIds]);  
        System.debug('--- ServiceTerritoryMemberController - Absences: '+resources.size()); 
        return resources;  
    }
}