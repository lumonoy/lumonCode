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

}