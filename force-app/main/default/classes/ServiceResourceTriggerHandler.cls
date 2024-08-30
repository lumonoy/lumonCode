/*
    Created by Reijo Mattila on 22.10.2023
*/
public class ServiceResourceTriggerHandler {
    
    public static void checkActiveForAbsences(Map<Id, ServiceResource> newScope, Map<Id, ServiceResource> oldScope){
        try{
            Set<Id> deleteScope = new Set<Id>();
            Set<Id> insertScope = new Set<Id>();
            for(ServiceResource sr : newScope.values()){
                if(sr.isActive == false && oldScope.get(sr.Id).isActive == true){
                    deleteScope.add(sr.Id);
                }
                else if(sr.isActive == true && oldScope.get(sr.Id).isActive == false){
                    insertScope.add(sr.Id);
                }
            }
            if(!deleteScope.isEmpty()){
                delete [SELECT Id FROM ResourceAbsence WHERE ResourceId in: deleteScope];
            }
            if(!insertScope.isEmpty()){
                List<ServiceTerritoryMember> allMembers = new List<ServiceTerritoryMember>();
                allMembers = [SELECT Id, ServiceTerritory.OperatingHoursId, ServiceResourceId FROM ServiceTerritoryMember WHERE ServiceResourceId in: insertScope];
                Set<String> resourceToOHSet = new Set<String>();
                Set<Id> insertMemberIds = new Set<Id>();
                for(ServiceTerritoryMember stm : allMembers){
                    if(!resourceToOHSet.contains(String.valueOf(stm.ServiceResourceId)+String.valueOf(stm.serviceTerritory.OperatingHoursId))){
                        insertMemberIds.add(stm.Id);
                        resourceToOHSet.add(String.valueOf(stm.ServiceResourceId)+String.valueOf(stm.serviceTerritory.OperatingHoursId));
                    }
                }
                if(!insertMemberIds.isEmpty()){
                    for(Id id : insertMemberIds){
                        ServiceTerritoryMemberTriggerHandler.insertMemberAbsences(id);
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Error when checking Resource Active in Resource Trigger with Error: '+e);
        }
    }
}