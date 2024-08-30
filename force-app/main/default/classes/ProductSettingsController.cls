/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ProductSettingsController {
    public static Map<String,Product_Settings__c> getProductSettingsMap(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = UserInfo.getUserId();
        Map<String,Product_Settings__c> productSettingsMap = new Map<String,Product_Settings__c>(); 
        Product_Settings__c productSettingsOrg = Product_Settings__c.getInstance(userOrgId);
        if (productSettingsOrg != null) {
            productSettingsMap.put(userOrgId,productSettingsOrg);
        }       
        Product_Settings__c productSettingsProfile = Product_Settings__c.getInstance(userProfileId);
        if (productSettingsProfile != null) {
            productSettingsMap.put(userProfileId,productSettingsProfile);
        }  
        Product_Settings__c productSettingsUser = Product_Settings__c.getInstance(userId);
        if (productSettingsUser != null) {
            productSettingsMap.put(userId,productSettingsUser);
        }
        System.debug('--- Product Settings Map: '+productSettingsMap);
        return productSettingsMap;
    }
    public static Product_Settings__c getProductSettings(){
        Id userOrgId = userInfo.getOrganizationId();
        Id userProfileId = userinfo.getProfileId();
        Id userId = userInfo.getUserId();
        Product_Settings__c productSettings;
        Map<String,Product_Settings__c> productSettingsMap = getProductSettingsMap();
        if (productSettingsMap.containsKey(userId)){
            productSettings = productSettingsMap.get(userId);
        } else if (productSettingsMap.containsKey(userProfileId)){
            productSettings = productSettingsMap.get(userProfileId);
        } else if (productSettingsMap.containsKey(userOrgId)){
            productSettings = productSettingsMap.get(userOrgId);
        }
        System.debug('--- Product Settings: '+productSettings);
        return productSettings;
    }
}