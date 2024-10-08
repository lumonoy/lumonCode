/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationProductsController {
    public class ComponentData {
        @AuraEnabled
        public List<Configuration_Product__c> configurationProducts { get; set; }
        @AuraEnabled
        public String opportunityId { get; set; }
        @AuraEnabled
        public String orderType { get; set; }
        public ComponentData(Id recordId) {
            Opportunity opportunity = new Opportunity();
            if (recordId.getSobjectType() == Case.getSObjectType()) {
                opportunity = caseOpportunityId(recordId);
            } else if (recordId.getSobjectType() == Opportunity.getSObjectType()) {
                opportunity = queryOpportunity(recordId);
            }
            opportunityId = opportunity.Id;
            orderType = opportunity.Order_type__c;
            configurationProducts = queryConfigurationProducts(opportunityId);
        }
    }

    @AuraEnabled
    public static Opportunity caseOpportunityId(Id recordId) {
        return [
            SELECT Id, Order_type__c
            FROM Opportunity
            WHERE Case__c = :recordId AND Order_type__c = 'Reclamation'
            LIMIT 1
        ];
    }

    // Method to fetch Order type value if the source object is Opportunity
    @AuraEnabled
    public static Opportunity queryOpportunity(Id recordId) {
        return [SELECT Id, Order_type__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
    }

    private static List<Configuration_Product__c> queryConfigurationProducts(String opportunityId) {
        return [
            SELECT
                Product__r.Name,
                Product__r.Id,
                Configuration__r.Plan_Type__c,
                Configuration__r.Plan_Name__c,
                Configuration__r.Plan_Line__c,
                Configuration__r.Plan_Apartment__c,
                Configuration__r.Plan_Floor__c,
                Verification__c,
                Configuration__c,
                //Configuration__r.Opportunity__r.Delivery_Date__c,
                //Configuration__r.Opportunity__r.Confirmed_Delivery_Date__c,
                //Configuration__r.Opportunity__r.Preliminary_installation_time__c,
                //Configuration__r.Opportunity__r.Confirmed_installation_time__c,
                Configuration__r.Opportunity__r.StageName,
                Configuration__r.Quote__r.Status,
                Configuration__r.Visual_Id__c,
                RVN_Number__c,
                RVN__c,
                LastModifiedDate,
                Quantity__c,
                Features_Confirmed__c,
                Measurements_Verified__c,
                Inspection_Code__c
            FROM Configuration_Product__c
            WHERE Configuration__r.Opportunity__c = :opportunityId
            LIMIT 1000
        ];
    }

    @AuraEnabled
    public static ComponentData getComponentData(String recordId) {
        return new ComponentData(recordId);
    }

    @AuraEnabled
    public static void deleteConfigurationProducts(List<Id> configurationProductIds) {
        if (configurationProductIds.isEmpty()) {
            return;
        }

        List<Configuration_Product__c> configurationProducts = [
            SELECT Id, Configuration__c, Configuration__r.Opportunity__r.OwnerId
            FROM Configuration_Product__c
            WHERE Id IN :configurationProductIds AND Configuration__r.Opportunity__r.StageName = 'Quoting'
            LIMIT 2000
        ];

        Role_Settings__c roleSettings = RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId());
        Boolean manager = roleSettings.isManager__c;
        Boolean salesUser = roleSettings.isSales__c;
        Boolean serviceUser = roleSettings.isService__c;

        if (!roleSettings.isAdmin__c && !roleSettings.isSupport__c) {
            // TODO
            // if(!salesUser && !serviceUser) {
            //     throw new DeleteNotAllowedException('User does not have rights to delete');
            // }

            // User with roles above current user's role have also rights to delete
            Map<Id, UserRole> userRoles = new Map<Id, UserRole>([SELECT Id, ParentRoleId, Name FROM UserRole]);
            Map<Id, Set<Id>> roleParentRoles = new Map<Id, Set<Id>>();
            for (UserRole userRole : userRoles.values()) {
                if (!roleParentRoles.containsKey(userRole.Id)) {
                    roleParentRoles.put(userRole.Id, new Set<Id>());
                }
            }
            for (UserRole userRole : userRoles.values()) {
                UserRole parent = userRoles.get(userRole.ParentRoleId);
                while (parent != null) {
                    roleParentRoles.get(userRole.Id).add(parent.Id);
                    parent = userRoles.get(parent.ParentRoleId);
                }
            }

            Id currentUserId = UserInfo.getUserId();
            Set<Id> managersUsers = new Set<Id>();
            for (Configuration_Product__c configurationProduct : configurationProducts) {
                Id opportunityOwnerId = configurationProduct.Configuration__r.Opportunity__r.OwnerId;
                // Not the owner and the current user is below the owner in the role hierarchy
                if (
                    opportunityOwnerId != currentUserId &&
                    !roleParentRoles.get(currentUserId).contains(opportunityOwnerId)
                ) {
                    throw new DeleteNotAllowedException('Delete not allowed');
                }
            }
        }

        List<Configuration__c> configurationPlans = new List<Configuration__c>();
        Set<Id> configurationPlanIds = new Set<Id>();
        for (Configuration_Product__c configurationProduct : configurationProducts) {
            Id configurationPlanId = configurationProduct.Configuration__c;
            if (configurationPlanId != null && !configurationPlanIds.contains(configurationPlanId)) {
                configurationPlanIds.add(configurationPlanId);
                configurationPlans.add(new Configuration__c(Id = configurationPlanId));
            }
        }
        if (!configurationPlanIds.isEmpty()) {
            delete [
                SELECT Id
                FROM QuoteLineItem
                WHERE Configuration_Plan__c IN :configurationPlanIds
                LIMIT 1000
            ];
            delete configurationPlans;
        }
    }

    public class DeleteNotAllowedException extends Exception {
    }
}