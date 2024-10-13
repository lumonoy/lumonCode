/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestCases {
    public class CustomException extends Exception {}
    @TestVisible public static Id CS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CS_Case').getRecordTypeId();
    @TestVisible public static Id TS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TS_Case').getRecordTypeId();
    @TestVisible public static Id SF_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Case').getRecordTypeId();
    @TestVisible public static Id FAC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FAC_Case').getRecordTypeId();
    @TestVisible public static Id INST_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('INST_Case').getRecordTypeId();
    @TestVisible public static Id RECL_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RECL_Case').getRecordTypeId();
    @TestVisible public static Id SPEC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SPEC_Case').getRecordTypeId();
    @TestVisible public static Id PERM_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PERM_Case').getRecordTypeId();
    @TestVisible public static Id LOG_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LOG_Case').getRecordTypeId();
    @TestVisible public static Id WEB_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB_Case').getRecordTypeId();


    @TestVisible public static List<Case> cases{
        get{
            return [SELECT Id,RecordTypeId FROM Case];
        }
    }    
    @TestVisible public static List<Id> caseIds {
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
        System.debug('--- LumonTestCases - setupCases SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupCaseData(){ 
        System.debug('--- LumonTestCases - Setup Cases');
        setupCases();
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();

        Test.stopTest();
    }
    @IsTest
    static void setupCaseDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupCaseData();
            testResult = 'successfully inserted Cases';
        } catch (exception e){
            testResult = 'Error when inserting Cases: '+e.getMessage();
        }
        System.debug('--- LumonTestCases - setupCaseDataTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestCases - setupCaseDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}