/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-16-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestLeads {
    public static void setupLeadB2C(){
        Id b2cLeadRecordTypeId = LumonTestVariables.b2cLeadRecordTypeId;
        Lead lead1 = new Lead(FirstName = 'My',
                                    LastName = 'Lead 1',
                                    Business_Type__c = 'Consumer',
                                    Property_Type__c = 'ROW',
                                    LeadSource	= 'Other',
                                    Status = 'Sales Lead',
                                    Email = 'my.lead1@test.com',
									MobilePhone = '+34800500100', 
                                    Street = 'Kuninkaantie 28',                             
                                    PostalCode = '01670', 
                                    City = 'Vantaa',
                                    Country = 'Finland',
                                    RecordTypeId = b2cLeadRecordTypeId);
        insert lead1;
        System.debug('--- LumonTestLeads - setupLeadB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - setupLeadB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupLeadB2B(){
        Id b2bLeadRecordTypeId = LumonTestVariables.b2bLeadRecordTypeId;
        Lead lead1 = new Lead(FirstName = 'My',
                                        LastName = 'Lead 2',
                                        Company = 'Lead Company',
                                        Business_Type__c = 'Project',
                                        Property_Type__c = 'PRJB',
                                        LeadSource	= 'Other',
                                        Status = 'Sales Lead',
                                        Email = 'my.lead2@test.com',
                                        MobilePhone = '+34800500200', 
                                        Street = 'Kuninkaantie 29',                             
                                        PostalCode = '01670', 
                                        City = 'Vantaa',
                                        Country = 'Finland',
                                        RecordTypeId = b2bLeadRecordTypeId);
                                        insert lead1;
        System.debug('--- LumonTestLeads - setupLeadB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLeads - setupLeadB2B - Queries used: '+LIMITS.getQueries());
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
        System.debug('--- LumonTestLeads - Queries used: '+LIMITS.getQueries());
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
        System.debug('--- LumonTestLeads - Queries used: '+LIMITS.getQueries());
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
        System.debug('--- LumonTestLeads - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Lead> leads = LumonTestVariables.leads;
        System.AssertNotEquals(0, leads?.size(), ' Expected Leads to be Inserted');
    }  
}