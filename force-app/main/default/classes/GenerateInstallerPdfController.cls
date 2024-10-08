/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class GenerateInstallerPdfController {
    @AuraEnabled
    public static List<Configuration_Product__c> getConfigurationProducts(String recordId){
        System.debug('*** recordId ***'+recordId);
        Id opportunityId;
        String parentObject;
        String errorMessage;
        if (String.isNotBlank(recordId)){
            parentObject = DynamicObjectUtils.getObjectType(recordId);
        } else {
            errorMessage = 'No Parent Record Available!';
            System.debug('--- ABORT '+errorMessage);
            throw new CustomException(errorMessage);
        }
        System.debug('--- parentObject: '+parentObject);
        if (parentObject=='Opportunity' && String.isNotBlank(recordId)){  
            opportunityId = recordId;
        } else if (parentObject=='WorkOrder' && String.isNotBlank(recordId)){  
            opportunityId = [SELECT Id, Opportunity__c FROM WorkOrder WHERE Id = :recordId]?.Opportunity__c;
        }    
        System.debug('--- opportunityId: '+opportunityId);
        return [SELECT Id, RVN_Number__c, Product__r.Name, Installer_Message__c
                FROM Configuration_Product__c
                WHERE Configuration__r.Opportunity__c = :opportunityId];
    }
    
    /*@AuraEnabled
    public static List<Configuration_Product__c> getConfigBlindProducts(String recordId){
        String parentObject;
        String errorMessage;
        String configurationPlanId;
        if (String.isNotBlank(recordId)){
            parentObject = DynamicObjectUtils.getObjectType(recordId);
        }
        if (parentObject == 'WorkOrder' && String.isNotBlank(recordId)){  
            WorkOrder workOrderRec= [SELECT Id, Opportunity__c, Configuration_Plan__c,
                                     (SELECT ID, Configuration_Product__c,Configuration_Product__r.Configuration__r.Plan_Type__c,Configuration_Product__r.Configuration__r.Id FROM WorkOrderLineItems 
                                      WHERE Configuration_Product__r.Configuration__r.Plan_Type__c ='Blinds')
                                     FROM WorkOrder  WHERE Id = :recordId];
            if(workOrderRec.WorkOrderLineItems.size() > 0){
                configurationPlanId = workOrderRec.WorkOrderLineItems[0].Configuration_Product__r.Configuration__r.Id;
            }  
        }    
        return [SELECT Id, RVN_Number__c, Product__r.Name, Installer_Message__c, Configuration__c,Configuration__r.Plan_Type__c 
                FROM Configuration_Product__c  WHERE  Configuration__r.Plan_Type__c = 'Blinds'
                AND Configuration__r.Id = :configurationPlanId];
    }
*/
}