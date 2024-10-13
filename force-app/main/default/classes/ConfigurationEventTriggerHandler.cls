/**
 * @description       : NOT IN USE Handles Configuration Events for CPQ
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
public without sharing class ConfigurationEventTriggerHandler {
    /*Disabled 01.10.2024
    public static void processConfiguration(List<ConfigurationEvent__e> configChangeEvents){
        // Iterate through each notification.
        for (ConfigurationEvent__e event : configChangeEvents) {      
            System.debug('--- Event: ' + event);
            String configType = event.configType__c;
            System.debug('--- Configuration Type: ' + configType);
            String configAction = event.configAction__c;
            System.debug('--- Configuration Action: ' + configAction);
            String configId = event.configId__c;
            //System.debug('--- Configuration: ' + configId);
            String recordId = event.recordId__c;
            //System.debug('--- record: ' + recordId);
            String objectType = event.objectType__c;
            //System.debug('--- objectType: ' + objectType);
            String visualPlanId = event.visualPlanId__c;
            //System.debug('--- visualPlanId: ' + visualPlanId);
            String documentId = event.documentId__c;
            //System.debug('--- documentId: ' + documentId);
            String contentJSON = event.pricingJSON__c;
            //System.debug('--- contentJSON: ' + contentJSON);
            // Executed Quoting Process for Enhanced Pricing
            //System.debug('--- Start Processing '+contentJSON);
            QuotingManager.executeQuotingProcess( configType, configAction,
                                            configId,recordId,objectType,
                                            visualPlanId, documentId,contentJSON);
        }
    }*/
}