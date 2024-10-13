/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestAdmin {
    public class CustomException extends Exception {}
    @TestVisible public static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
        }
    }
    @TestVisible public static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            UserName, UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User WHERE(username='admin.testuser@sandbox.com')];
        }
    }
    public static void setupAdmin(){
        List<Profile> profiles = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        for (Profile profile : profiles) {
            String alias = 'admin';
            User testAdmin = new User(alias = alias
                                    ,email=alias+'.testuser@mail.me'
                                    ,emailencodingkey='UTF-8'
                                    ,firstname=alias
                                    ,lastname='TestUser'
                                    ,languagelocalekey='en_US'
                                    ,localesidkey='en_GB'
                                    ,profileId = profile.Id
                                    ,timezonesidkey='Europe/Helsinki'
                                    ,username=alias+'.testuser@sandbox.com'
            );
            System.debug('--- LumonTestAdmin - setupAdmin - admin to Insert: '+testAdmin);
            insert testAdmin;
            System.debug('--- LumonTestAdmin - setupAdmin - testAdmin: '+testAdmin);
        }
        
        System.debug('--- LumonTestAdmin - setupAdmin - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAdmin - setupAdmin - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupAdminData(){
        setupAdmin();
    }
    /********** User Data Tests***********/
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   
    @isTest
    public static void setupAdminDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupAdminData();
            testResult = 'successfully inserted Admin';
        } catch (exception e){
            testResult = 'Error when inserting Admin: '+e.getMessage();
        }
        System.debug('--- LumonTestAdmin - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAdmin - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}