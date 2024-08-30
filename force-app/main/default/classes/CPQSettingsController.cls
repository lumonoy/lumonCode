/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class CPQSettingsController {
    public static Map<String,CPQ_Settings__c> getCPQSettingsMap(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = UserInfo.getUserId();
        Map<String,CPQ_Settings__c> cpqSettingsMap = new Map<String,CPQ_Settings__c>(); 
        CPQ_Settings__c cpqSettingsOrg = CPQ_Settings__c.getInstance(userOrgId);
        if (cpqSettingsOrg != null) {
            cpqSettingsMap.put(userOrgId,cpqSettingsOrg);
        }       
        CPQ_Settings__c cpqSettingsProfile = CPQ_Settings__c.getInstance(userProfileId);
        if (cpqSettingsProfile != null) {
            cpqSettingsMap.put(userProfileId,cpqSettingsProfile);
        }  
        CPQ_Settings__c cpqSettingsUser = CPQ_Settings__c.getInstance(userId);
        if (cpqSettingsUser != null) {
            cpqSettingsMap.put(userId,cpqSettingsUser);
        }
        System.debug('--- CPQ Settings Map: '+cpqSettingsMap);
        List<CPQ_Settings__c> cpqSettingsList = [SELECT Id, Name, SetupOwnerId, Use_Pricelist__c, Group_Items__c, Enhanced_Pricing__c, maxDiscount__c FROM CPQ_Settings__c ];
        return cpqSettingsMap;
    }
    public static CPQ_Settings__c getCPQSettings(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = userInfo.getUserId();
        CPQ_Settings__c cpqSettings;
        Map<String,CPQ_Settings__c> cpqSettingsMap = getCPQSettingsMap();
        if (cpqSettingsMap.containsKey(userId)){
            cpqSettings = cpqSettingsMap.get(userId);
        } else if (cpqSettingsMap.containsKey(userProfileId)){
            cpqSettings = cpqSettingsMap.get(userProfileId);
        } else if (cpqSettingsMap.containsKey(userOrgId)){
            cpqSettings = cpqSettingsMap.get(userOrgId);
        }
        System.debug('--- CPQ Settings: '+cpqSettings);
        return cpqSettings;
    }
}