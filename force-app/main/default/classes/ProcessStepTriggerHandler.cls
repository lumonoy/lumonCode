/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ProcessStepTriggerHandler {
    public static void initiateProcessStep(List<ProcessStepEvent__e> processSteps) {
        for (ProcessStepEvent__e step : processSteps) {      
            System.debug('--- ProcessController - executeProcessStep: ' + step);
            String processStage = step.ProcessStage__c;
            String processActivity = step.ProcessActivity__c;
            String recordId = step.recordId__c;
            String objectType = step.ObjectType__c;
            String jsonString = step.JsonString__c;
            String documentId = step.documentId__c;
            /*ProcessController.executeProcessStep( configType, configAction,
                                               recordId,objectType,
                                               jsonString, JsonData);*/
        }
    }
}