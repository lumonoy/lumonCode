/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestCasesTest {
    @isTest
    public static void setupReclamationRecordsTest() {
        LumonTestCases.setupReclamationRecords();

    }
}