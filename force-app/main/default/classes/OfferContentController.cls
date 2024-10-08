/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class OfferContentController {
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

            // Filter out duplicate extra sales conf. products
            List<Configuration_Product__c> filteredConfigurationProducts = new List<Configuration_Product__c>();
            Boolean extraSalesAdded = false;
            for (Configuration_Product__c configurationProduct : configurationProducts) {
                Boolean isExtraSales = configurationProduct.Configuration__r.Plan_Type__c == 'Extra Sales';
                if (!isExtraSales || isExtraSales && !extraSalesAdded) {
                    filteredConfigurationProducts.add(configurationProduct);
                }
                if (isExtraSales) {
                    extraSalesAdded = true;
                }
            }
            configurationProducts = filteredConfigurationProducts;
        }
    }

    @AuraEnabled
    public static Opportunity caseOpportunityId(Id recordId) {
        Case caseRecord = [
            SELECT Type, Reclamation__c, Reclamation__r.Order_Type__c, Opportunity__c, Opportunity__r.Order_Type__c
            FROM Case
            WHERE Id = :recordId
            LIMIT 1
        ];
        if (new Set<String> { 'Warranty work request', 'Reclamation order','Customer Reclamation' }.contains(caseRecord.Type)) {
            return caseRecord.Reclamation__r;
        }
        return caseRecord.Opportunity__r;
        //  AND Order_type__c = 'Reclamation'
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
                Special__c,
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

    @AuraEnabled(cacheable=true) //<-- DML operations not allowed!
    public static ComponentData getComponentData(String recordId) {
        return new ComponentData(recordId);
    }
    @AuraEnabled
    public static void removeManuallyAddedSpecialItems(List<Id> configurationProductIds, String opportunityId) {
        // if (configurationProductIds.isEmpty()) {
        //     return;
        // }
        // List<Configuration_Product__c> configurationProductsToUpdate = new List<Configuration_Product__c>();
        // Set<Id> visualAddedSpecialProducts = SpecialProductsService.isVisualAddedSpecialProduct(configurationProductIds);
        // for (Id configurationProductId : configurationProductIds) {
        //     if (visualAddedSpecialProducts.contains(configurationProductId)) {
        //         throw new AuraHandledException('Unable to remove special special products that are added from Visual');
        //     }
        // }

        // delete [
        //         SELECT Id
        //         FROM Configuration_Option__c
        //         WHERE Configuration_Product__c IN :configurationProductIds AND
        //         Product__r.Additional_special_product__c = true
        //         LIMIT 2000
        // ];
        // Map<String, Id> productGroupToConfigurationProductId = populateProductGroupToConfigurationProductIdMap(configurationProductIds);
        // for (String productGroup : productGroupToConfigurationProductId.keySet()) {
        //     configurationProductsToUpdate.add(
        //             new Configuration_Product__c(Id = productGroupToConfigurationProductId.get(productGroup),
        //                     Special__c = false));
        // }
        // update configurationProductsToUpdate;
        // PricingController.upsertQuoteLines(opportunityId);

    }

    // private static Map<String, Id> populateProductGroupToConfigurationProductIdMap(List<Id> configurationProductIds){
    //     Map<String, Id> productGroupToConfigurationProductId = new Map<String, Id>();
    //     for (Configuration_Product__c configurationProduct : [
    //             SELECT Id, Product_Group__c
    //             FROM Configuration_Product__c
    //             WHERE Id IN :configurationProductIds
    //             LIMIT 2000
    //     ]) {
    //         productGroupToConfigurationProductId.put(configurationProduct.Product_Group__c, configurationProduct.Id);
    //     }
    //     return productGroupToConfigurationProductId;
    // }

    @AuraEnabled
    public static void addManuallySpecialItems(List<Id> configurationProductIds, String opportunityId) {
        // if (configurationProductIds.isEmpty()) {
        //     return;
        // }
        // List<Configuration_Option__c> configurationOptionsToInsert = new List<Configuration_Option__c>();
        // List<Configuration_Product__c> configurationProductsToUpdate = new List<Configuration_Product__c>();
        // Map<String, Integer> configurationProductToMaxLineNumber = getMaxLineNumberConfigurationOptions(new Set<Id>(configurationProductIds));
        // Map<String, Id> productGroupToConfigurationProductId = populateProductGroupToConfigurationProductIdMap(configurationProductIds);
        // if (!productGroupToConfigurationProductId.isEmpty()) {
        //     for (Product2 product : SpecialProductsService.getAdditionalSpecialProducts(productGroupToConfigurationProductId.keySet())) {
        //         configurationOptionsToInsert.add(SpecialProductsService.createConfigurationOption(product,
        //                 productGroupToConfigurationProductId, configurationProductToMaxLineNumber.get(product.Product_Group__c)));
        //     }
        //     for (String productGroup : productGroupToConfigurationProductId.keySet()) {
        //         configurationProductsToUpdate.add(
        //                 new Configuration_Product__c(Id = productGroupToConfigurationProductId.get(productGroup),
        //                         Special__c = true));
        //     }
        // }

        // insert configurationOptionsToInsert;
        // update configurationProductsToUpdate;
        // PricingController.upsertQuoteLines(opportunityId);
    }

    // private static Map<String, Integer> getMaxLineNumberConfigurationOptions(Set<Id> configurationProductIds) {
    //     Map<String, Integer> productGroupToMaxLineNumber = new Map<String, Integer>();
    //     List<AggregateResult> aggregateResults = [
    //             SELECT Product_Group__c, MAX(Line_Number__c)
    //             FROM Configuration_Option__c
    //             WHERE Configuration_Product__c IN :configurationProductIds
    //             GROUP BY Product_Group__c
    //     ];
    //     for (AggregateResult aggregateResult : aggregateResults) {
    //         productGroupToMaxLineNumber.put((String)aggregateResult.get('Product_Group__c'),
    //                 Integer.valueOf((Decimal) aggregateResult.get('expr0')));
    //     }
    //     return productGroupToMaxLineNumber;
    // }

    @AuraEnabled
    public static void deleteConfigurationProducts(List<Id> configurationProductIds) {
        if (configurationProductIds.isEmpty()) {
            return;
        }

        List<Configuration_Product__c> configurationProducts = [
            SELECT
                Id,
                Configuration__c,
                Configuration__r.Opportunity__r.Owner.UserRole.Id,
                Configuration__r.Opportunity__r.StageName
            FROM Configuration_Product__c
            WHERE Id IN :configurationProductIds
            LIMIT 2000
        ];

        Role_Settings__c roleSettings = RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId());
        Boolean manager = roleSettings.isManager__c;
        Boolean salesUser = roleSettings.isSales__c;
        Boolean serviceUser = roleSettings.isService__c;

        // Admin/Support is always allowed to delete (no matter what stage)
        if (!roleSettings.isAdmin__c && !roleSettings.isSupport__c) {
            for (Configuration_Product__c configurationProduct : configurationProducts) {
                if (configurationProduct.Configuration__r.Opportunity__r.StageName != 'Quoting') {
                    throw new DeleteNotAllowedException('Delete is not allowed');
                }
            }
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

            Id currentUserRoleId = UserInfo.getUserRoleId();
            Set<Id> managersUsers = new Set<Id>();
            for (Configuration_Product__c configurationProduct : configurationProducts) {
                Id opportunityOwnerRoleId = configurationProduct.Configuration__r.Opportunity__r.Owner.UserRole.Id;
                // Not the owner and the current user is below the owner in the role hierarchy
                System.debug(JSON.serializePretty(roleParentRoles));
                if (
                    opportunityOwnerRoleId != currentUserRoleId &&
                    !roleParentRoles.get(opportunityOwnerRoleId).contains(currentUserRoleId)
                ) {
                    throw new DeleteNotAllowedException('Delete is not allowed');
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
            List<QuoteLineItem> quoteLineItems = [
                SELECT Id
                FROM QuoteLineItem
                WHERE Configuration_Plan__c IN :configurationPlanIds
                LIMIT 1000
            ];
            if (roleSettings.isAdmin__c || roleSettings.isSupport__c) {
                new WithoutSharing().deleteRecords(quoteLineItems, configurationPlans);
            } else {
                delete quoteLineItems;
                delete configurationPlans;
            }
        }
    }

    private without sharing class WithoutSharing {
        private void deleteRecords(List<QuoteLineItem> quoteLineItems, List<Configuration__c> configurationPlans) {
            delete quoteLineItems;
            delete configurationPlans;
        }
    }

    public class DeleteNotAllowedException extends Exception {
    }
}