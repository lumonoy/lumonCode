/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-23-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ProductSettingsControllerTest {
    @IsTest
    public static void getProductSettingsTest() {
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
            System.debug('--- getProductSettingsTest - Runas '+user.name);
            System.runAs(user){
            Product_Settings__c productSettings = ProductSettingsController.getProductSettings();
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.debug('--- getProductSettingsTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to find CPQ Settings');
        System.debug('--- getProductSettingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductSettingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }    
}