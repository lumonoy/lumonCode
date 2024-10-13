/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class CaseControllerTest {
    public class CustomException extends Exception {}
    private static List<Case> cases = LumonTestVariables.cases;
    private static List<Id> caseIds = LumonTestVariables.caseIds;
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupCases();
        Test.stopTest();
    }
    @IsTest
    static void getCaseRecordTest(){   
        Case caseToGet = [SELECT Id,CaseGroup__c FROM Case LIMIT 1];
        Test.startTest();
        Case caseRecord = CaseController.getCaseRecord(cases[0]?.Id);
        System.Debug ('--- CaseControllerTest - getCaseRecordTest'+ caseRecord.Id +' Case Returned');
        System.assertNotEquals(null,caseRecord, 'Expected Case Record to be returned');
        System.debug('--- CaseControllerTest - getCaseRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- CaseControllerTest - getCaseRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCaseByNumberTest(){   
        Case caseToGet = [SELECT Id,CaseNumber FROM Case LIMIT 1];
        Test.startTest();
        System.Debug ('--- CaseControllerTest - getCaseByNumberTest get Case for Number '+ caseToGet.CaseNumber);
        Case caseRecord = CaseController.getCaseByNumber(caseToGet.CaseNumber);
        System.Debug ('--- CaseControllerTest - getCaseByNumberTest '+ caseRecord.Id +' Case Returned');
        System.assertNotEquals(null,caseRecord, 'Expected Case Record to be returned');
        System.debug('--- CaseControllerTest - getCaseByNumberTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- CaseControllerTest - getCaseByNumberTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCasesByGroupTest(){
        String caseGroup  = [SELECT Id,CaseGroup__c FROM Case LIMIT 1]?.CaseGroup__c;
        Test.startTest();
        List<Case> cases = CaseController.getCasesByGroup(caseGroup);
        System.Debug ('--- CaseControllerTest - '+ cases.size() +' Cases Returned');
        System.assertNotEquals(0,cases.size(), 'Expected Case Record to be returned');
        System.debug('--- CaseControllerTest - getCasesByGroupTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- CaseControllerTest - getCasesByGroupTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCasesTest(){
        Test.startTest();
        List<Case> cases = CaseController.getCases(caseIds);
        System.Debug ('--- CaseControllerTest - '+ cases.size() +' Cases Returned');
        System.assertNotEquals(0,cases.size(), 'Expected Case Record to be returned');
        System.debug('--- CaseControllerTest - getCasesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- CaseControllerTest - getCasesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}