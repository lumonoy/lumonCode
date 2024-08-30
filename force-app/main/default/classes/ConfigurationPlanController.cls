/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationPlanController {
	private static String sObjectName = 'Configuration__c';
	private static String allowedFieldSet = 'Table_Fields';
	private static String visibleFieldSet = 'Table_View';
	private static String editableFieldSet = 'Table_Edit';
	@AuraEnabled(cacheable=true)
    public static List<Configuration__c> getConfigurationPlans(Id configId, Id relatedRecordId, String visualPlanId){
        System.debug('--- Get Configuration Plan for Processing');
        Configuration__c configPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
        // Find Configuration based on configId, recordId or VisualPlanId
        if(String.isNotBlank(configId)){
            System.debug('--- Getting Configuration Plan Id for Config Id '+configId); 
            configPlans = getConfigurationPlansById(configId);
            System.debug('--- Found '+configPlans.size()+' Configuration Plan(s) with Id: '+ configId);
        } else if (String.isNotBlank(relatedRecordId)) {
            System.debug('--- Getting Configuration Plans from Record');       
            configPlans = getConfigurationsByRelatedId(relatedRecordId);
            System.debug('--- Found '+configPlans.size()+' related Configuration Plan(s) for Id: '+ relatedRecordId);
        }  else if (String.isNotBlank(visualPlanId)){ 
            System.debug('--- Getting Configuration Plan Id for Visual Plan Id '+visualPlanId);  
            configPlans = getConfigurationsByVisualId(visualPlanId);
            System.debug('--- Found '+configPlans.size()+' Configuration Plan(s) for Visual Id: '+ visualPlanId);
        }
        return configPlans;
    }
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationPlansByBatchId(Id batchId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Delivery BatchId
        if (String.isNotEmpty(batchId)){
            configPlans =  [ SELECT Id,
                        Name,
                        Account__c,
                        Opportunity__c,
                        Quote__c,
                        Delivery_Batch__c,
						Delivery_Batch_Number__c,
						Plan_Type__c,
						Plan_Name__c,
						Plan_Floor__c,
						Plan_Line__c,
						Plan_Apartment__c
                FROM Configuration__c 
                WHERE Delivery_Batch__c =: batchId];
		}
		return configPlans;
	}
    @AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationPlansById(Id configurationId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on ConfigurationId
        if (String.isNotEmpty(configurationId)){
            configPlans =  [ SELECT Id,
                        Name,
                        Account__c,
                        Opportunity__c,
                        Quote__c,
                        Contract__c,
                        Order__c,
                        Work_Order__c,
                        Case__c,
                        Plan_Type__c,
						Plan_Name__c,
						Plan_Floor__c,
						Plan_Line__c,
						Plan_Apartment__c
                FROM Configuration__c 
                WHERE Id =: configurationId];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationPlansByIds(List<Id> configurationIds){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on ConfigurationIs
		if (configurationIds.size()>0 && configurationIds != null) {
			configPlans =  [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE Id IN: configurationIds];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByRelatedId(Id relatedRecordId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Opportunity or Quote recordId
		if (String.isNotBlank(relatedRecordId)) {
			configPlans = getConfigurationsByRelatedIds(new List<Id>{relatedRecordId});
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByRelatedIds(List<Id> relatedRecordIds){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Opportunity or Quote recordId
		if (relatedRecordIds.size()>0) {
			configPlans = [ SELECT Id,
									Name,
									//OwnerId, Not available for Child Records
									IsDeleted, 
									Account__c,
									Building__c,
									//Apartment__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,									
									Status__c,
									Configuration_Name__c,
									Configuration_Status__c, 
									Opportunity_Number__c, 
									Opportunity_Project__c,  
									Lock_RVN__c,
									LockPlan__c,
									Plan_Type__c, 
									Plan_Apartment__c, 
									Plan_Floor__c, 
									Plan_Line__c, 
									Plan_Name__c,
									Visual_Id__c, 
									Config_JSON__c, 
									Pricing_JSON__c,
									Visual_Pricing_JSON__c, 
									Visual_Products_JSON__c,
									Visual_Version__c, 
									Count_Products__c,
									Sovelia_Id__c, 
									Sovelia_Pricing_JSON__c, 
									Sovelia_Products_JSON__c, 
									//Sovelia_Statistics__c, 
									Sovelia_Version__c, 
									hasInstallationTime__c,
									Installation_Duration__c,
									Installation_Time__c, 
									Installation_Hours__c, 
									fxInstallationMins__c,  
									hasProductionTime__c, 
									Production_Time__c, 
									Production_Time_Max__c
							FROM Configuration__c 
							WHERE Account__c IN : relatedRecordIds
							OR Building__c IN: relatedRecordIds
							OR Opportunity__c IN: relatedRecordIds
							OR Quote__c IN: relatedRecordIds
							OR Contract__c IN: relatedRecordIds
							OR Order__c IN: relatedRecordIds
							OR Work_Order__c IN: relatedRecordIds
							OR Case__c IN: relatedRecordIds];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByVisualId(String visualPlanId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Visual Confguration Id
		if (String.isNotBlank(visualPlanId)) {
			configPlans = [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE Visual_Id__c =: visualPlanId];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<String,Configuration__c> getVisualIdsToPlanMap(List<Configuration__c> configurations){
		Map<String,Configuration__c> visualToPlanMap = new Map<String,Configuration__c>();
		if (configurations.size()>0 && configurations != null) {
			for (Configuration__c configPlan : configurations){
				String visualId = configPlan.Visual_Id__c;
				if(!visualToPlanMap.containsKey(visualId)){
					visualToPlanMap.put(visualId,configPlan);
				}
			}
		}
		return visualToPlanMap;
	}
    @AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<Id,Configuration__c> getOpportunitiesToPlanMap(List<Configuration__c> configurations){
		Map<Id,Configuration__c> opportunitiesToPlanMap = new Map<Id,Configuration__c>();
		if (configurations.size()>0 && configurations != null) {
			for (Configuration__c configPlan : configurations){
				Id opportunityId = configPlan.Opportunity__c;
				if(!opportunitiesToPlanMap.containsKey(opportunityId)){
					opportunitiesToPlanMap.put(opportunityId,configPlan);
				}
			}
		}
		return opportunitiesToPlanMap;
	}
}