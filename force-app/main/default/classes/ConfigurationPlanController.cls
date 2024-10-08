/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-16-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationPlanController {
	private static String sObjectName = 'Configuration__c';
	private static String allowedFieldSet = 'Table_Fields';
	private static String visibleFieldSet = 'Table_View';
	private static String editableFieldSet = 'Table_Edit';
	@AuraEnabled(cacheable=true)
    public static Configuration__c getConfigurationPlan(Id recordId) { 
        // Find Configuration Plan based on recordId
        List<Id> recordIds = new List<Id>{recordId};
        List<Configuration__c> configPlans = getConfigurationPlans(recordIds);
        Configuration__c configPlan = configPlans[0];
        return configPlan;
    }   
    @AuraEnabled(cacheable=false)
    public static Configuration__c getConfigurationPlanByNumber(String planIdentifier) {
        // Populate List from SOQL query on Plan
        Id configPlanId = [SELECT Id, ConfigurationNumber__c FROM Configuration__c WHERE ConfigurationNumber__c =: planIdentifier LIMIT 1]?.Id; 
        List<Id> configPlanIds = new List<Id>();
        configPlanIds.add(configPlanId);
        Configuration__c configPlan = new Configuration__c();
        System.debug('--- ConfigurationPlanController - Get Configuration Plan with Id '+configPlanId); 
        List<Configuration__c> configPlans =  getConfigurationPlans(configPlanIds); 
        if  (configPlans?.size()>0) {
            configPlan = configPlans[0];
            System.debug('--- ConfigurationPlanController - Configuration Plan: '+configPlan.Name); 
        }        
        return configPlan;
    }
	
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationPlans(List<Id> recordIds){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on ConfigurationIs
		if (recordIds.size()>0 && recordIds != null) {
			configPlans =  [ SELECT Id,
									Name,
									Account__c,
									Building__c,
									Apartment__c,	
									BuildingProject__c,
									DeliveryProject__c,
									DeliveryBatch__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									WorkOrder__c,
									Case__c,	
									ConfigurationNumber__c,						
									Status__c,
									Floor__c,
									Line__c,
									ApartmentUnit__c,
									Plan_Name__c,
									DeliveryBatchNumber__c,
									ConfigurationIdentifier__c,
									OfferNumber__c,
									OriginalConfigurationPlan__c,
									hasInstallationTime__c,
									hasProductionTime__c,
									CountConfigurationProducts__c,
									EstimatedInstallationHours__c,
									PlannedInstallationHours__c,
									SalesToriConfigKey__c,
									isMigrated__c
							FROM Configuration__c 
							WHERE Id IN: recordIds
								OR Account__c IN: recordIds
								OR Building__c IN: recordIds
								OR Apartment__c IN: recordIds
								//OR Project__c IN: recordIds
								OR Opportunity__c IN: recordIds
								OR Quote__c IN: recordIds
								OR Contract__c IN: recordIds
								OR Order__c IN: recordIds
								OR WorkOrder__c IN: recordIds
								OR Case__c IN: recordIds];
		}
		return configPlans;
	}
}