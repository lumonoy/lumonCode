/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-23-2024
 * @last modified by  : Henk Reynders
**/
@istest
public with sharing class LumonTestBypassSettings {
    @TestVisible private static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(Alias ='admin' OR username='admin.testuser@sandbox.com') 
                     LIMIT 1];
        }
    }
    @testVisible private static AutomationBypass__c automationBypassOrg {
        get {
            return AutomationBypass__c.getOrgDefaults();
        }
    }
    @testVisible private static AutomationBypass__c automationBypassProfile {
        get {
            return AutomationBypass__c.getValues(adminUser?.ProfileId);
        }
    }
    @testVisible private static AutomationBypass__c automationBypassUser {
        get {
            return AutomationBypass__c.getValues(adminUser?.Id);
        }
    }   
    public static void enableBypassSettingsForAdmin(){  
        Boolean automation = true;
        Boolean validation = true;
        setupBypassSettingsForAdmin(automation, validation); 
    }
    public static void disableBypassSettingsForAdmin(){  
        Boolean automation = false;
        Boolean validation = false;
        setupBypassSettingsForAdmin(automation, validation); 
    }
    public static void setupBypassSettingsForAdmin(Boolean automation, Boolean validation){  
        Profile adminProfile = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<AutomationBypass__c> bypassSettingsToUpsert = new List<AutomationBypass__c>();
        List<AutomationBypass__c>  existingAdminBypass = [SELECT Id, 
                                                        Name, 
                                                        SkipAccountApproval__c, 
                                                        SkipAutomation__c, 
                                                        SkipValidation__c,
                                                        SetupOwnerId,
                                                        SetupOwner.Name,
                                                        SetupOwner.alias,
                                                        SetupOwner.ProfileId,
                                                        SetupOwner.Profile.Name
                                                    FROM AutomationBypass__c
                                                    WHERE SetupOwnerId =: adminProfile.Id];
        AutomationBypass__c bypassSettingProfile = new AutomationBypass__c();    
        
        if (existingAdminBypass.size()>0) {
            System.debug('--- LumonTestBypassSettings - setupBypassSettingsForAdmin - existing Bypass Setting');
            bypassSettingProfile.Id = existingAdminBypass[0].Id;
        } else {
            System.debug('--- LumonTestBypassSettings - setupBypassSettingsForAdmin - new Bypass Setting');
            bypassSettingProfile.SetupOwnerId = adminProfile.Id;
        }
        bypassSettingProfile.Name = 'Admin Bypass Setting';
        bypassSettingProfile.SkipAutomation__c = automation;
        bypassSettingProfile.SkipValidation__c = validation;
        bypassSettingsToUpsert.add(bypassSettingProfile);
        if ( bypassSettingsToUpsert?.size()>0) {
            System.debug('--- LumonTestBypassSettings - setupBypassSettingsForAdmin - Bypass to Insert '+bypassSettingsToUpsert);
            upsert bypassSettingsToUpsert;
        }
    }

    @TestSetup
    public static void prepareData(){
        Test.startTest();
            LumonTestAdmin.setupAdminData();
        Test.stopTest();
    } 
    @IsTest
    public static void enableBypassSettingsTest(){
        String testresult;
        try {
            System.debug('--- LumonTestBypassSettings - enableBypassSettingsTest - Org Automation Bypass: '+automationBypassOrg?.SkipAutomation__c);
            System.debug('--- LumonTestBypassSettings - enableBypassSettingsTest - Profile Automation Bypass: '+automationBypassProfile?.SkipAutomation__c);
            System.debug('--- LumonTestBypassSettings - enableBypassSettingsTest - User Automation Bypass: '+automationBypassUser?.SkipAutomation__c);
            enableBypassSettingsForAdmin();            
        	testresult = ('Inserted Bypass Settings'); 
		} catch (Exception e) {
            //Any other exceptions that occur will go here
            String errorMessage = e.getMessage(); 
            testresult = ('Error - An Exception Occured:'+errorMessage);
        }
        System.debug('--- LumonTestBypassSettings - Test Result: '+testresult );
        System.assertNotEquals('Error',testresult,' Expected Bypass Settings to be Inserted without Error');
    }
    @IsTest
    public static void disableBypassSettingsTest(){
        String testresult;
        try {
            System.debug('--- LumonTestBypassSettings - disableBypassSettingsTest - Org Automation Bypass: '+automationBypassOrg?.SkipAutomation__c);
            System.debug('--- LumonTestBypassSettings - disableBypassSettingsTest - Profile Automation Bypass: '+automationBypassProfile?.SkipAutomation__c);
            System.debug('--- LumonTestBypassSettings - disableBypassSettingsTest - User Automation Bypass: '+automationBypassUser?.SkipAutomation__c);
            disableBypassSettingsForAdmin();            
        	testresult = ('Inserted Bypass Settings'); 
		} catch (Exception e) {
            //Any other exceptions that occur will go here
            String errorMessage = e.getMessage(); 
            testresult = ('Error - An Exception Occured:'+errorMessage);
        }
        System.debug('--- LumonTestBypassSettings - Test Result: '+testresult );
        System.assertNotEquals('Error',testresult,' Expected Bypass Settings to be Inserted without Error');
    }
}