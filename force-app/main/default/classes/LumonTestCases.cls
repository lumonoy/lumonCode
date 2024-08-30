/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-22-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestCases {
    @TestVisible private static Id CS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CS_Case').getRecordTypeId();
    @TestVisible private static Id TS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TS_Case').getRecordTypeId();
    @TestVisible private static Id SF_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Case').getRecordTypeId();
    @TestVisible private static Id FAC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FAC_Case').getRecordTypeId();
    @TestVisible private static Id INST_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('INST_Case').getRecordTypeId();
    @TestVisible private static Id RECL_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RECL_Case').getRecordTypeId();
    @TestVisible private static Id SPEC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SPEC_Case').getRecordTypeId();
    @TestVisible private static Id PERM_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PERM_Case').getRecordTypeId();
    @TestVisible private static Id LOG_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LOG_Case').getRecordTypeId();
    @TestVisible private static Id WEB_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB_Case').getRecordTypeId();


    @TestVisible private static List<Case> cases{
        get{
            return [SELECT Id,RecordTypeId FROM Case];
        }
    }    
    @TestVisible private static List<Id> caseIds {
        get{
            return new List<Id>(new Map<Id, Case>(cases).keySet()); 
        }
    } 
    /********** Case Data Setup ***********/
    public static void setupCases(){
        List<RecordType> caseRecordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND IsActive= true];
        List<Case> newCases = new List<Case>();
        for (RecordType caseRecordType : caseRecordTypes) {
            Case newCase = new Case( Subject='New '+caseRecordType.Name,
                                            Status='New',
                                            //ContactId=contactId,
                                            //AccountId=accountId,
											//BusinessHoursId	01m7Q0000016zyZQAQ
											//Type='Reclamation order',
											RecordTypeId=caseRecordType.Id,	
											Priority='Medium'
                                            );
            newCases.add(newCase);
        }
        if (newCases.size()>0) {
            insert newCases;
        }
        System.debug('--- LumonTestCases - setupCases CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestCases - setupCases Queries used: '+LIMITS.getQueries());
    }
}