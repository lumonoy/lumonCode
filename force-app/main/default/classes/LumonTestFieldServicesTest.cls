/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestFieldServicesTest {
    @isTest
    public static void SetupFieldServicesTest() {
        LumonTestFieldServices.setupFieldServices();

    }
}