/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class RoleSettingsController{
    public static Map<String,Role_Settings__c> getRoleSettingsMap(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = UserInfo.getUserId();
        Map<String,Role_Settings__c> roleSettingsMap = new Map<String,Role_Settings__c>(); 
        Role_Settings__c roleSettingsOrg = Role_Settings__c.getInstance(userOrgId);
        if (roleSettingsOrg != null) {
            roleSettingsMap.put(userOrgId,roleSettingsOrg);
        }       
        Role_Settings__c roleSettingsProfile = Role_Settings__c.getInstance(userProfileId);
        if (roleSettingsProfile != null) {
            roleSettingsMap.put(userProfileId,roleSettingsProfile);
        }  
        Role_Settings__c roleSettingsUser = Role_Settings__c.getInstance(userId);
        if (roleSettingsUser != null) {
            roleSettingsMap.put(userId,roleSettingsUser);
        }
        System.debug('--- Role Settings Map: '+roleSettingsMap);
        List<Role_Settings__c> roleSettingsList = [SELECT Id, Name, SetupOwnerId,isAdmin__c,isManager__c, isSupport__c, isSales__c, isService__c FROM Role_Settings__c ];
        return roleSettingsMap;
    }
    public static Role_Settings__c getRoleSettings(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = userInfo.getUserId();
        Role_Settings__c roleSettings;
        Map<String,Role_Settings__c> roleSettingsMap = getRoleSettingsMap();
        if (roleSettingsMap.containsKey(userId)){
            roleSettings = roleSettingsMap.get(userId);
        } else if (roleSettingsMap.containsKey(userProfileId)){
            roleSettings = roleSettingsMap.get(userProfileId);
        } else if (roleSettingsMap.containsKey(userOrgId)){
            roleSettings = roleSettingsMap.get(userOrgId);
        }
        System.debug('--- Role Settings: '+roleSettings);
        return roleSettings;
    }
}