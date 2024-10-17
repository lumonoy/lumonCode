/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class BuildingController {
    @AuraEnabled(cacheable=true)
    public static Building__c getBuildingRecord(Id recordId) {
        // Populate map from SOQL query on Building
        List<Id> recordIds = new List<Id>{recordId};
        List<Building__c> buildingRecords = getBuildings(recordIds);        
        Building__c buildingRecord = buildingRecords[0];
        System.debug('--- BuildingController - Building Record: '+buildingRecord);
        return buildingRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Building__c> getBuildings(List<Id> recordIds) {
        List<Building__c> buildings = ([SELECT Id,
                                                Name, 
                                                Building_Address__Street__s, 
                                                Building_Address__City__s, 
                                                Building_Address__PostalCode__s, 
                                                Building_Address__StateCode__s, 
                                                Building_Address__CountryCode__s, 
                                                Building_Address__Latitude__s, 
                                                Building_Address__Longitude__s, 
                                                Building_Address__GeocodeAccuracy__s, 
                                                Building_Address__c, 
                                                Building_Height__c,
                                                Building_Location__c, 
                                                Number_of_Floors__c, 
                                                On_Hill_or_Slope__c, 
                                                Owned_By__c, 
                                                Property_Type__c, 
                                                Structural_Analysis__c                              
                                    FROM Building__c 
                                    WHERE Id IN :recordIds
                                    OR Owned_By__c IN: recordIds
                                    OR Structural_Analysis__c IN: recordIds
                                    ]);
        System.debug('--- BuildingController - '+buildings.size()+' Buildings Created.');
        return buildings;
    } 
}