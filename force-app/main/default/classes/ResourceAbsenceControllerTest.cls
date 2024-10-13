/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-29-2024
 * @last modified by  : Henk Reynders
**/
@isTest
private class ResourceAbsenceControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestResourceAbsences.setupResourceAbsences();
        Test.stopTest();
    }
    //private static List<ResourceAbsence> absences = LumonTestResourceAbsences.absences;
    //private static List<Id> absenceIds = LumonTestResourceAbsences.absenceIds;
    @IsTest
    static void getResourceAbsenceTest(){   
        ResourceAbsence absenceToGet = [SELECT Id,AbsenceNumber FROM ResourceAbsence LIMIT 1];
        Test.startTest();
        ResourceAbsence absenceRecord = ResourceAbsenceController.getResourceAbsence(absenceToGet?.Id);
        System.Debug ('--- ResourceAbsenceControllerTest - getResourceAbsenceRecordTest'+ absenceRecord.Id +' ResourceAbsence Returned');
        System.assertNotEquals(null,absenceRecord, 'Expected ResourceAbsence Record to be returned');
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsenceRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsenceRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getResourceAbsenceByTypeTest(){   
        ResourceAbsence absenceToGet = [SELECT Id,AbsenceNumber,Type FROM ResourceAbsence LIMIT 1];
        Test.startTest();
        System.Debug ('--- ResourceAbsenceControllerTest - get ResourceAbsence for Type '+ absenceToGet.Type);
        List<ResourceAbsence> absenceRecords = ResourceAbsenceController.getResourseAbsencesByType(absenceToGet.Type);
        System.Debug ('--- ResourceAbsenceControllerTest - getResourceAbsenceByTypeTest '+ absenceRecords.size() +' ResourceAbsence Returned');
        System.assertNotEquals(null,absenceRecords.size(), 'Expected ResourceAbsence Record to be returned');
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsenceByTypeTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsenceByTypeTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getResourceAbsencesByResourceTest(){
        Id absenceResourceId  = [SELECT Id,AbsenceNumber,Type, ResourceId FROM ResourceAbsence LIMIT 1]?.ResourceId;
        Test.startTest();
        List<ResourceAbsence> absences = ResourceAbsenceController.getResourseAbsencesByResource(absenceResourceId);
        System.Debug ('--- ResourceAbsenceControllerTest - '+ absences.size() +' ResourceAbsences Returned');
        System.assertNotEquals(0,absences.size(), 'Expected ResourceAbsence Record to be returned');
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsencesByResourceTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsencesByResourceTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getResourceAbsencesTest(){
        List<ResourceAbsence> absencesToGet = [SELECT Id,AbsenceNumber FROM ResourceAbsence LIMIT 5];
        List<Id> absenceIds = new List<Id>(new Map<Id, ResourceAbsence>(absencesToGet).keySet()); 
        Test.startTest();
        List<ResourceAbsence> absences = ResourceAbsenceController.getResourceAbsences(absenceIds);
        System.Debug ('--- ResourceAbsenceControllerTest - '+ absences.size() +' ResourceAbsences Returned');
        System.assertNotEquals(0,absences.size(), 'Expected ResourceAbsence Record to be returned');
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsencesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- ResourceAbsenceControllerTest - getResourceAbsencesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}