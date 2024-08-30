/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-18-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static Case getCaseRecord(Id recordId) {
        // Populate map from SOQL query on Case
        List<Id> recordIds = new List<Id>{recordId};
        List<Case> caseRecords = getCases(recordIds);        
        Case caseRecord = caseRecords[0];
        System.debug('--- CaseController - Case Record: '+caseRecord);
        return caseRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static Case getCaseByNumber(String caseNumber) {
        Case caseRecord;
        if (String.IsNotBlank(caseNumber)){
            Id caseId = ([SELECT Id,CaseNumber FROM Case WHERE CaseNumber = :caseNumber LIMIT 1]?.Id);
            caseRecord = getCaseRecord(caseId);
        }
        return caseRecord;
    }
    @AuraEnabled(cacheable=true)
    public static List<Case> getCasesByGroup(String caseGroup) {
        List<Case> casesByGroup = ([SELECT Id,CaseGroup__c FROM Case WHERE CaseGroup__c = :caseGroup]);
        List<Id> caseIds = new List<Id>(new Map<Id, Case>(casesByGroup).keySet()); 
        List<Case> cases = getCases(caseIds);
        return cases;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(List<Id> recordIds) {
        List<Case> cases = ([SELECT Id,
                                    MasterRecordId, 
                                    CaseNumber, 
                                    ContactId, 
                                    AccountId, 
                                    AssetId, 
                                    ProductId, 
                                    EntitlementId, 
                                    FeedItemId,
                                    SourceId, 
                                    BusinessHoursId, 
                                    ParentId, 
                                    AssetWarrantyId, 
                                    ServiceContractId,
                                    SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, 
                                    Type, RecordTypeId, 
                                    Status, Reason, 
                                    Origin, Language, 
                                    Subject, Priority, Description, 
                                    IsClosed, ClosedDate, 
                                    IsEscalated, CurrencyIsoCode, 
                                    OwnerId, IsClosedOnCreate, 
                                    SlaStartDate, SlaExitDate, IsStopped, StopStartDate, 
                                    CreatedDate, CreatedById, 
                                    LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, 
                                    ContactPhone, ContactMobile, ContactEmail, ContactFax, 
                                    Comments, 
                                    LastViewedDate, LastReferencedDate, 
                                    MilestoneStatus, 
                                    // Case Information
                                    CaseResolution__c, 
                                    CaseDetailedDescription__c, 
                                    CaseProcessStage__c, 
                                    hasPictures__c,
                                    // Additional Relations
                                    Opportunity__c, 
                                    Order__c, 
                                    Reclamation__c,
                                    WorkOrderLineItem__c, 
                                    WorkOrder__c, 
                                    // Categorization
                                    CaseCategory__c, 
                                    CaseType__c, 
                                    CaseSubType__c,
                                    // Assignment
                                    CaseInQueue__c,
                                    CaseGroup__c, 
                                    //Milestones
                                    SlaDeadline__c, 
                                    CaseResolvedOnTime__c, 
                                    SlaCount__c, 
                                    SourceEmail__c, 
                                    SourcePhone__c, 
                                    Requester__c,                                    
                                    //Permit Applications
                                    PermitApplicationDetails__c, 
                                    PermitAuthority__c, 
                                    PermitDetails__c, 
                                    PermitPrincipalDesigner__c, 
                                    PermitSiteManager__c, 
                                    PermitStatus__c, 
                                    PermitStructuralEngineer__c,
                                    // Reclamations
                                    ReclamationCauseDescription__c, 
                                    ReclamationCause__c, 
                                    UnderWarranty__c,
                                    //Quality
                                    QualityProcessClass__c, 
                                    QualityCauseCode__c, 
                                    QualityTargetCode__c                           
                                    FROM Case 
                                    WHERE Id IN :recordIds
                                    //OR OwnedBy__c IN: recordIds
                                    //OR StructuralAnalysis__c IN: recordIds
                                    ]);
        System.debug('--- CaseController - Case Record Count : '+cases.size());
        return cases;
    } 
}