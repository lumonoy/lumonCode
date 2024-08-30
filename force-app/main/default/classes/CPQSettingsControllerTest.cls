/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class CPQSettingsControllerTest {
    @IsTest
    public static void getCPQSettingsTest() {
		List<User> adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
			AND UserRoleId != null
			AND IsActive = TRUE
			LIMIT 1
		];
        Id adminProfileId = [SELECT Id FROM Profile WHERE Profile.Name = 'System Administrator' LIMIT 1]?.Id;
        User user = new User();
        user.firstName = 'test';
        user.lastName = 'admin';
        user.profileId = adminProfileId;
        user.username = 'admin.test@lumon.com';
        user.email = 'admin@test.com';
        user.Alias = 'admin'; 
        user.TimeZoneSidKey = 'Europe/Helsinki';
        user.LocaleSidKey = 'fi_FI_EURO'; 
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        // Profile Setting
        CPQ_Settings__c setting1 = new CPQ_Settings__c();
        setting1.Name = 'Admin Profile Setting';
        setting1.SetupOwnerId = userinfo.getProfileId();
        setting1.debug__c = true;
        insert setting1;
        CPQ_Settings__c setting2 = new CPQ_Settings__c();
        setting2.Name = 'Admin User Setting';
        setting2.SetupOwnerId = userinfo.getUserId();
        setting2.maxDiscount__c = 0.10;
        insert setting2;
        CPQ_Settings__c setting3 = new CPQ_Settings__c();
        setting3.Name = 'Organization Setting';
        setting3.SetupOwnerId = userinfo.getOrganizationId();
        setting3.debug__c = true;
        insert setting3;
        String errorMessage;
        Test.startTest();     
        try {
            System.debug('--- getCPQSettingsTest - Runas '+user.name);
            System.runAs(user){
            CPQ_Settings__c cpqSettings = CPQSettingsController.getCPQSettings();
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.debug('--- getCPQSettingsTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to find CPQ Settings');
        System.debug('--- getCPQSettingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getCPQSettingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }    
}