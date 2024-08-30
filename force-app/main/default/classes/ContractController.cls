/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ContractController {
    @AuraEnabled(cacheable=true)
    public static Contract getContractRecord(Id recordId) {
        // Populate map from SOQL query on Contract
        List<Id> recordIds = new List<Id>{recordId};
        List<Contract> contractRecords = getContracts(recordIds);        
        Contract contractRecord = contractRecords[0];
        System.debug('--- Contract Record: '+contractRecord);
        return contractRecord;
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
                                            Account.Customer_Segment__c,
                                            Account.AccountNumber,
                                            Opportunity__c, // This assumes one Contract has one Opportunity
                                            Opportunity__r.Sales_reference__c ,
                                            Opportunity__r.Opportunity_Number__c,
                                            Opportunity__r.Project_Number__c,
                                            Opportunity__r.Project_Number__r.Project_Number__c,
                                            Opportunity__r.Project_Number__r.Project_Group__c,
                                            Opportunity__r.Project_Number__r.Chargeable__c,
                                            Opportunity__r.Project_Number__r.Parent_Project__c,
                                            Opportunity__r.Project_Number__r.Parent_Project__r.Project_Number__c,
                                            //Opportunity__r.Project__c,
                                            //Opportunity__r.Project__r.Project_Number__c,
                                            //Opportunity__r.Project__r.Project_Group__c,
                                            //Opportunity__r.Project__r.Chargeable__c,
                                            //Opportunity__r.Project__r.Parent_Project__c,
                                            //Opportunity__r.Project__r.Parent_Project__r.Project_Number__c,
                                            Opportunity__r.Organization_Attribute__c,
                                            Opportunity__r.Customer_Address__c,
                                            Opportunity__r.Delivery_Address__c,
                                            Opportunity__r.Installation_Address__c,
                                            Opportunity__r.Invoicing_Address__c,
                                            Opportunity__r.Invoice_type__c,
                                            Opportunity__r.Order_type__c, // Not using Global picklist
                                            //Opportunity__r.OrderType__c, // TO be added to fix above issue
                                            Delivery_week__c, Delivery_Date__c, 
                                            Pricebook2Id,
                                            Pricebook2.Name,
                                            Pricebook2.CurrencyIsoCode
                                            //PriceBook_Name__c
                                            //Main_Contractor__c,Business_Unit__c,Opportunity__c,Payment_Term__c,Method_of_Payment__c,
                                            //Opportunity__r.Preliminary_installation_time__c,Opportunity__r.Phone__c,Opportunity__r.Contact_Email__c                              
                                    FROM Contract 
                                    WHERE Id IN :recordIds
                                    OR AccountId IN: recordIds
                                    OR Opportunity__c IN: recordIds
                                    ]);
        System.debug('--- Contract Record Count : '+contracts.size());
        return contracts;
    } 
}