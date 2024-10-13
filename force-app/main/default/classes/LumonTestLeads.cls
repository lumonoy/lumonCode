/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestLeads {
    public class CustomException extends Exception {}
    @TestVisible private static Map<String,List<String>> addressMap{
        get{
            return LumonTestData.addressMap;
        }
    }
    @TestVisible private static Lead b2cLead{
        get{
            return [SELECT Id, FirstName, LastName, BusinessType__c, CustomerSegment__c, PropertyType__c FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company = null)];
        }
    }
    @TestVisible private static Id b2cLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company = null)]?.Id;
        }
    }
    @TestVisible private static Id b2bLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company != null)]?.Id;
        }
    }
    @TestVisible private static List<Lead> leads{
        get{
            return [SELECT Id, Finland_Sync_to_MC__c, Other_Countries_Sync_to_MC__c, Spain_Sync_to_MC__c, 
                            Email_Opt_In__c, Email_Opt_In_Date_Time__c, SMS_Opt_In__c, SMS_Opt_In_Date_Time__c, 
                            HasOptedOutOfEmail,
                            ConvertedContactId, ConvertedAccountId,ConvertedOpportunityId,
                            ConvertedAccount.Finland_Sync_to_MC__pc,  ConvertedAccount.Spain_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc, 
                            ConvertedAccount.Finland_Sync_to_MC__c,  ConvertedAccount.Spain_Sync_to_MC__c, ConvertedAccount.Other_Countries_Sync_to_MC__c, 
                            ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Spain_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c, 
                            ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Spain_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c, 
                            ConvertedDate
                    FROM Lead];
        }
    }
    @TestVisible private static List<Id> leadIds {
        get{
            return new List<Id>(new Map<Id, Lead>(leads).keySet()); 
        }
    }  
    public static void setupLeadB2C(){
        List<String> leadAddress = addressMap.get('b2cLead'); //'Finland','Vantaa','12345','Street 100','FI_South'
        Id b2cLeadRecordTypeId = LumonTestVariables.b2cLeadRecordTypeId;
        Lead lead1 = new Lead(FirstName = 'My',
                                    LastName = 'Lead 1',
                                    //BusinessType__c = '1',
                                    //Property_Type__c = 'ROW',
                                    LeadSource	= 'Other',
                                    Status = 'Sales Lead',
                                    Email='b2c.lead@external.com',
									MobilePhone = '+348000001', 
                                    Country = leadAddress[0], 
                                    City = leadAddress[1],
                                    PostalCode = leadAddress[2],
                                    Street = leadAddress[3],
                                    RecordTypeId = b2cLeadRecordTypeId);
        insert lead1;
        System.debug('--- LumonTestLeads - setupLeadB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - setupLeadB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupLeadB2B(){
        List<String> leadAddress = addressMap.get('b2bLead'); //'Finland','Vantaa','12345','Street 100','FI_South'
        Id b2bLeadRecordTypeId = LumonTestVariables.b2bLeadRecordTypeId;
        Lead lead1 = new Lead(FirstName = 'My',
                                        LastName = 'Lead 2',
                                        Company = 'Lead Company',
                                        //BusinessType__c = '4',
                                        //Property_Type__c = 'PRJB',
                                        LeadSource	= 'Other',
                                        Status = 'Sales Lead',
                                        Email='b2b.lead@external.com',
									    MobilePhone = '+348000002',  
                                        Country = leadAddress[0], 
                                        City = leadAddress[1],
                                        PostalCode = leadAddress[2],
                                        Street = leadAddress[3],
                                        RecordTypeId = b2bLeadRecordTypeId);
                                        insert lead1;
        System.debug('--- LumonTestLeads - setupLeadB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - setupLeadB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupLeadData(){
        setupLeadB2C();
        setupLeadB2B();
    }
    @TestSetup
    static void prepareData() { 
        Test.startTest();
        Test.stopTest();
    } 
    @IsTest
    static void setupLeadDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupLeadData();
            testResult = 'successfully inserted Leads';
        } catch (exception e){
            testResult = 'Error when inserting Leads: '+e.getMessage();
        }
        System.debug('--- LumonTestLeads - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Lead> leads = LumonTestVariables.leads;
        System.AssertNotEquals(0, leads?.size(), ' Expected Leads to be Inserted');
    }  
    @IsTest
    static void setupLeadB2CTest(){
        String testResult;
        Test.startTest();
        try {
            setupLeadB2C();
            testResult = 'successfully inserted B2C Lead';
        } catch (exception e){
            testResult = 'Error when inserting B2C Lead: '+e.getMessage();
        }
        System.debug('--- LumonTestLeads - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Lead> leads = LumonTestVariables.leads;
        System.AssertNotEquals(0, leads?.size(), ' Expected Leads to be Inserted');
    }  
    @IsTest
    static void setupLeadB2BTest(){
        String testResult;
        Test.startTest();
        try {
            setupLeadB2B();
            testResult = 'successfully inserted B2B Lead';
        } catch (exception e){
            testResult = 'Error when inserting B2B Lead: '+e.getMessage();
        }
        System.debug('--- LumonTestLeads - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Lead> leads = LumonTestVariables.leads;
        System.AssertNotEquals(0, leads?.size(), ' Expected Leads to be Inserted');
    }  
}