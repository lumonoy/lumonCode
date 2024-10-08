/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-04-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ServiceTerritoryController {
    /**** Methods for Finding ServiceTerritory Entries ****/
    @AuraEnabled(cacheable=false)
    public static ServiceTerritory getServiceTerritory(Id serviceTerritoryId) {
        // Populate List from SOQL query on ServiceTerritory
        List<Id> serviceTerritoryIds = new List<Id>();
        serviceTerritoryIds.add(serviceTerritoryId);
        System.debug('--- ServiceTerritoryController - Get ServiceTerritory with Id '+serviceTerritoryId); 
        List<ServiceTerritory> serviceTerritories =  getServiceTerritories(serviceTerritoryIds);  
        ServiceTerritory serviceTerritory = serviceTerritories[0];
        System.debug('--- ServiceTerritoryController - ServiceTerritory: '+serviceTerritory.Name); 
        return serviceTerritory;  
    }
    @AuraEnabled(cacheable=false)
    public static ServiceTerritory getServiceTerritoryByNumber(String serviceTerritoryCode) {
        // Populate List from SOQL query on ServiceTerritory
        Id serviceTerritoryId = [SELECT Id FROM ServiceTerritory WHERE ServiceAttribute__c =: serviceTerritoryCode LIMIT 1]?.Id; 
        List<Id> serviceTerritoryIds = new List<Id>();
        serviceTerritoryIds.add(serviceTerritoryId);
        ServiceTerritory serviceTerritory = new ServiceTerritory();
        System.debug('--- ServiceTerritoryController - Get Service Territory with Id '+serviceTerritoryId); 
        List<ServiceTerritory> serviceTerritories =  getServiceTerritories(serviceTerritoryIds); 
        if  (serviceTerritories?.size()>0) {
            serviceTerritory = serviceTerritories[0];
            System.debug('--- ServiceTerritoryController - ServiceTerritory: '+serviceTerritory.Name); 
        }        
        return serviceTerritory;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritory> getServiceTerritoriesByUser(Id userId) {
        // Populate List from SOQL query on ServiceTerritory
        List<ServiceTerritory> customerServiceTerritories = new List<ServiceTerritory>();
        customerServiceTerritories = getServiceTerritories(new List<Id> {userId});
        return customerServiceTerritories;
    }
    @AuraEnabled(cacheable=false)
    public static List<ServiceTerritory> getServiceTerritories(List<Id> recordIds) {
        // Populate List from SOQL query on ServiceTerritory
        System.debug('--- ServiceTerritoryController - Get ServiceTerritories'); 
        List<ServiceTerritory> serviceTerritories = ([  SELECT Id,Name,  
                                                            OwnerId,
                                                            ParentTerritoryId, 
                                                            TopLevelTerritoryId, 
                                                            OperatingHoursId, 
                                                            Description, 
                                                            Address,
                                                            Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy,                                                            
                                                            IsActive,                                                        
                                                            TypicalInTerritoryTravelTime, 
                                                            SchedulingConstraintId, 
                                                            TravelModeId, 
                                                            //AvgTravelTime, 
                                                            FSL__Hide_Emergency_Map__c, 
                                                            FSL__Internal_SLR_Geolocation__Latitude__s, 
                                                            FSL__Internal_SLR_Geolocation__Longitude__s, 
                                                            FSL__Internal_SLR_Geolocation__c, 
                                                            FSL__NumberOfServicesToDripFeed__c, 
                                                            FSL__O2_Enabled__c, 
                                                            FSL__Service_Cluster_Min_Size__c, 
                                                            FSL__Service_Cluster_Proximity__c, 
                                                            FSL__System_Jobs__c, 
                                                            FSL__TerritoryLevel__c,                                                            
                                                            //Parent_Name__c, Appointment_Booking_Offset__c, LUM_Dispatching_Offset__c, Scheduling_Calendar__c, 
                                                            //Parents_Parent_Name__c, Related_Case_Queue_name__c, 
                                                            AppointmentBookingOffset__c, 
                                                            DispatchingOffset__c, 
                                                            ServiceTerritoryCode__c, 
                                                            SchedulingCalendar__c,
                                                            BusinessType__c, BusinessTypeAttribute__c,
                                                            CountryAttribute__c, 
                                                            CustomerSegment__c, CustomerSegmentAttribute__c,
                                                            District__c, DistrictAttribute__c,
                                                            Office__c, OfficeAttribute__c,
                                                            Organization__c,OrganizationAttribute__c,
                                                            ProfitCenter__c, ProfitCenterAttribute__c,
                                                            PropertyType__c, PropertyTypeAttribute__c,
                                                            ServiceAttribute__c
                                                            
                                                        FROM ServiceTerritory
                                                        WHERE Id IN: recordIds
                                                        OR OwnerId IN: recordIds
                                                        ]);  
        System.debug('--- ServiceTerritoryController - ServiceTerritories: '+serviceTerritories.size()); 
        return serviceTerritories;  
    }
}