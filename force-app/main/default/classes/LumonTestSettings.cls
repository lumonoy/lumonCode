/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-20-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestSettings {
    @TestSetup
    static void prepareData(){
        LumonTestUsers.setupAdminUser();
    }
    @TestVisible private static User adminUser{
        get{
            return  [SELECT Id,ProfileId,UserRoleId,Isactive,username FROM User WHERE(Profile.Name = 'System Administrator' AND username='admin.testuser@email123.com')];
        }
    }
    @TestVisible private static List<Profile> profiles{ 
        get {
            return [SELECT Id,Name FROM Profile];
        }
    }
    @TestVisible private static List<User> users{ 
        get {
            return [SELECT Id,ProfileId,UserRoleId,Isactive,username FROM User];
        }
    }
    @TestVisible private static List<CPQ_Settings__c> customSettingsCPQ { 
        get {
            return [SELECT Id,Configure_Stages__c, maxDiscount__c, debug__c FROM CPQ_Settings__c];
        }
    }
    @IsTest
    public static void setupCustomSettingsCPQ() {
        String errorMessage;
        Test.startTest();     
        try {
            System.runAs(adminUser){       
                System.debug('--- setupCustomSettingsCPQ - CPQ Settings before: '+customSettingsCPQ); 
                if (customSettingsCPQ?.size()>0) {
                    delete customSettingsCPQ;
                    System.debug('--- setupCustomSettingsCPQ - CPQ Settings deleted: '+customSettingsCPQ);
                }      
                CPQ_Settings__c settingDefault = new CPQ_Settings__c();
                settingDefault.Name = 'Default Setting';
                settingDefault.SetupOwnerId = userinfo.getOrganizationId();
                settingDefault.Configure_Stages__c = 'Quoting';
                settingDefault.maxDiscount__c = 10;
                insert settingDefault;
                System.debug('--- setupCustomSettingsCPQ - CPQ Settings with default: '+customSettingsCPQ);
                CPQ_Settings__c settingProfile = new CPQ_Settings__c();
                settingProfile.Name = 'Profile Setting';
                settingProfile.SetupOwnerId = userinfo.getProfileId();
                settingProfile.maxDiscount__c = 50;
                insert settingProfile;
                System.debug('--- setupCustomSettingsCPQ - CPQ Settings with Profile: '+customSettingsCPQ);
                CPQ_Settings__c settingUser = new CPQ_Settings__c();
                settingUser.Name = 'Admin User Setting';
                settingUser.SetupOwnerId = userinfo.getUserId();
                settingUser.debug__c = true;
                settingUser.maxDiscount__c = 100;
                insert settingUser;
                System.debug('--- setupCustomSettingsCPQ - CPQ Settings with User: '+customSettingsCPQ);
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.debug('--- setupCustomSettingsCPQ - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to find CPQ Settings');
        System.debug('--- setupCustomSettingsCPQ - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- setupCustomSettingsCPQ - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }  
}