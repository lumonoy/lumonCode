/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonSystemTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupAccountB2C();
        //LumonTestDataFactory.setupAccountB2B();
        Test.stopTest();
    }   
    //private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    //private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    @IsTest
    static void LumonDebugTest(){
        Test.startTest();
        LumonSystem.debug('---- Logging something');
        LumonSystem.debug('--- LumonDebugTest - CPU TIME: '+LIMITS.getCpuTime()); 
        LumonSystem.debug('--- LumonDebugTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}