/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ContractController {
    @AuraEnabled(cacheable=true)
    public static Contract getContractRecord(Id recordId) {
        // Populate map from SOQL query on Contract
        List<Id> recordIds = new List<Id>{recordId};
        List<Contract> contractRecords = getContracts(recordIds);        
        Contract contractRecord = contractRecords[0];
        System.debug('--- ContractController - Contract Record: '+contractRecord);
        return contractRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static Contract getContractByNumber(String contractNumber) {
        // Populate List from SOQL query on Contract
        Id contractId = [SELECT Id FROM Contract WHERE contractNumber =: contractNumber LIMIT 1]?.Id; 
        List<Id> contractIds = new List<Id>();
        contractIds.add(contractId);
        Contract contract = new Contract();
        System.debug('--- ContractController - Get Contract with Id '+contractId); 
        List<Contract> contracts =  getContracts(contractIds); 
        if  (contracts?.size()>0) {
            contract = contracts[0];
            System.debug('--- ContractController - Contract: '+contract.Name); 
        }        
        return contract;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contract> getContracts(List<Id> recordIds) {
        List<Contract> contracts = ([SELECT  Id,
                                            Name,
                                            ContractNumber,
                                            CurrencyIsoCode,
                                            RecordTypeId,
                                            RecordType.Name,
                                            Status, 
                                            AccountId,
                                            Delivery_week__c, Delivery_Date__c, 
                                            Pricebook2Id,
                                            Pricebook2.Name,
                                            Pricebook2.CurrencyIsoCode,
                                            isMigrated__c,
                                            OfferNumber__c                            
                                    FROM Contract 
                                    WHERE Id IN :recordIds
                                    OR AccountId IN: recordIds
                                    OR Opportunity__c IN: recordIds
                                    ]);
        System.debug('--- ContractController - Contract Record Count : '+contracts.size());
        return contracts;
    } 
}