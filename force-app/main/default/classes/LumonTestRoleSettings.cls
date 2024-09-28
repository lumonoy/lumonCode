/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-20-2024
 * @last modified by  : Henk Reynders
**/
@istest
public with sharing class LumonTestRoleSettings {
	public static void setupRoleSettings(){  
        Id roleSettingsOwner = Role_Settings__c.getOrgDefaults().SetupOwnerId; 
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettings = new Role_Settings__c();
        roleSettings.Name = 'Default Role Setting';
        roleSettings.SetupOwnerId = orgId;
        roleSettings.isAdmin__c = false;
        roleSettings.isSales__c = false;
        roleSettings.isManager__c = false;
        roleSettings.isService__c = false;
        roleSettings.isSupport__c = false;
        roleSettings.isMarketeer__c = false;
        insert roleSettings; 
        System.debug('--- LumonTestRoleSettings - inserted roleSettings: '+roleSettings );
    }
    public static void setupRoleSettingsForProfiles(){  
        List<Profile> profiles = [SELECT Id,Name FROM Profile WHERE Name LIKE 'Lumon%' OR Name = 'System Administrator'];
        List<Role_Settings__c> roleSettingsToUpsert = new List<Role_Settings__c>();
        for (Profile prof : profiles) {
            String profileName = prof.Name;
            Role_Settings__c roleSettings = Role_Settings__c.getInstance(prof.Id); 
            Role_Settings__c roleSettingProfile = new Role_Settings__c();    
            
            if (String.isNotBlank(roleSettings.Id)) {
                System.debug('--- LumonTestRoleSettings - setupRoleSettingsForProfiles - existing Role Settings: '+roleSettings);
                roleSettingProfile.Id = roleSettings.Id;
            } else {
                roleSettingProfile.SetupOwnerId = prof.Id;
            }
            roleSettingProfile.Name = 'Admin Role Setting';
            roleSettingProfile.isAdmin__c = profileName.contains('Admin') ? true: false;
            roleSettingProfile.isSales__c = profileName.contains('B2C') ? true : profileName.contains('B2B') ?true: false;
            roleSettingProfile.isManager__c = profileName.contains('Manager') ? true : false;
            roleSettingProfile.isService__c = profileName.contains('Service') ? true :  false;
            roleSettingProfile.isSupport__c = profileName.contains('Support') ? true :  false;
            roleSettingProfile.isMarketeer__c = profileName.contains('Marke') ? true :  false;
            roleSettingsToUpsert.add(roleSettingProfile);
            System.debug('--- LumonTestRoleSettings - setupRoleSettingsForProfiles - Add RoleSetting '+roleSettingProfile);

        }
        if ( roleSettingsToUpsert?.size()>0) {
            upsert roleSettingsToUpsert;
        }
        System.debug('--- LumonTestRoleSettings - setupRoleSettingsForProfiles - Updated '+roleSettingsToUpsert?.size()+ ' Role Settings');
    }
    @Istest
    public static void setupRoleSettingsTest(){
        String testresult;
        try {
            setupRoleSettings();            
        	testresult = ('Inserted Default Role Settings');
		} catch (Exception e) {
            //Any other exceptions that occur will go here
            String errorMessage = e.getMessage(); 
            testresult = ('Error - An Exception Occured:'+errorMessage);
        }
        System.debug('--- LumonTestRoleSettings - Test Result: '+testresult );
        System.assertNotEquals('Error',testresult,' Expected Role Settings to be Inserted without Error');
    } 
}