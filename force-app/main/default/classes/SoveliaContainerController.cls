/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 02-05-2024
 * @last modified by  : Henk Reynders
**/

public with sharing class SoveliaContainerController {
    @AuraEnabled
    public static InitWrapper getRVN(Id recordId) {  
        InitWrapper wrapper = new InitWrapper();
        wrapper.isSandbox = ([SELECT IsSandbox FROM Organization LIMIT 1]?.IsSandbox);
        wrapper.rvn = '';
        wrapper.errorMessage = '';
        wrapper.opportunityId = '';
        wrapper.configurationProductId = '';
        Savepoint savePoint = Database.setSavepoint();
        try {
            String configurationProductId = '';
            if (recordId.getSobjectType() == Opportunity.getSObjectType()) {
                Configuration__c config = new Configuration__c(
                    Opportunity__c = recordId,
                    Plan_Type__c = 'Blinds',
                    Plan_Name__c = 'After Sales Blinds',
                    Status__c = 'Draft'
                );
                insert config;
                Configuration_Product__c configProduct = new Configuration_Product__c(
                    Configuration__c = config.Id,
                    Quantity__c = 1
                );
                insert configProduct;
                configurationProductId = configProduct.Id;
            } else if (recordId.getSobjectType() == Configuration_Product__c.getSObjectType()) {
                configurationProductId = recordId;
                wrapper.configurationProductId = recordId;
            }
            System.debug('--- configurationProductId: '+configurationProductId);
            Configuration_Product__c configurationProduct = [
                SELECT RVN__c, Configuration__r.Opportunity__c
                FROM Configuration_Product__c
                WHERE Id = :configurationProductId
                LIMIT 1
            ];
            wrapper.rvn = configurationProduct.RVN__c;
            wrapper.opportunityId = configurationProduct.Configuration__r.Opportunity__c;
            
            System.debug('--- recordId: '+recordId);
            System.debug('--- configurationProduct: '+configurationProduct);
        } catch (DmlException ex) {
            Database.rollback(savePoint);
            wrapper.errorMessage = ex.getDmlMessage(0);
        } catch (Exception e) {
            Database.rollback(savePoint);
            wrapper.errorMessage = e.getMessage();
        }
        System.debug(JSON.serialize(wrapper));
        return wrapper;
    }

    public class InitWrapper {
        @AuraEnabled
        public Boolean isSandbox { public get; set; }     
        @AuraEnabled
        public String rvn { public get; set; }
        @AuraEnabled
        public String opportunityId { public get; set; }
        @AuraEnabled
        public String configurationProductId { public get; set; }
        @AuraEnabled
        public String errorMessage { public get; set; }
    }
}