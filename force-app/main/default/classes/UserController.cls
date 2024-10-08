/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-05-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class UserController {
    @AuraEnabled(cacheable=false)
    public static User getUser(Id userId) {
        // Populate List from SOQL query on User
        List<Id> userIds = new List<Id>();
        userIds.add(userId);
        List<User> users =  getUsers(userIds);  
        User user = users[0];
        System.debug('--- UserController - User: '+user.Name); 
        return user;  
    }
    @AuraEnabled(cacheable=false)
    public static User getUserByName(String userShortName) {
        // Populate List from SOQL query on User
        Id userId = [SELECT Id FROM User WHERE AD_Short_Username__c =: userShortName LIMIT 1]?.Id; 
        List<Id> userIds = new List<Id>();
        userIds.add(userId);
        User user = new User();
        List<User> users =  getUsers(userIds); 
        if  (users?.size()>0) {
            user = users[0];
            System.debug('--- UserController - User: '+user.Name); 
        }        
        return user;
    }
    @AuraEnabled(cacheable=false)
    public static List<User> getUsers(List<Id> UserIds) {
        // Populate List from SOQL query on User
        System.debug('--- UserController - Get Users'); 
        List<User> users = ([  SELECT  Id,Name,
                                        AD_Short_Username__c, 
                                        AD_Manager_Id__c, 
                                        AD_Profit_Center__c, 
                                        AD_Office__c,                                        
                                        UserName,Email,
                                        UserRoleId, UserRole.DeveloperName,
                                        ProfileId, Profile.Name,
                                        IsActive, 
                                        Organization__c, OrganizationAttribute__c,
                                        CountryCode, CountryAttribute__c,
                                        District__c, DistrictAttribute__c, 
                                        ProfitCenter__c, ProfitCenterAttribute__c,  
                                        Office__c, OfficeAttribute__c                     
                                    FROM User 
                                    WHERE Id IN: userIds
                                    AND IsActive = true]);  
        System.debug('--- Users: '+users.size()); 
        return users;  
    }
}