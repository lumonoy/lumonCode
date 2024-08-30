/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LeadControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupLeadB2C();
        LumonTestDataFactory.setupLeadMC();
        //LumonTestDataFactory.setupLeadB2B();
        Test.stopTest();
    }   
    private static Id b2cLeadId = LumonTestDataFactory.b2cLeadId;
    private static Id mcLeadId = LumonTestDataFactory.mcLeadId;
    //private static Lead mcLead = LumonTestDataFactory.mcLead;
    //private static Id b2bLeadId = LumonTestDataFactory.b2bLeadId;
    @IsTest
    static void getLeadTest(){
        Test.startTest();
        Lead lead = LeadController.getLead(b2cLeadId);
        System.Debug ('--- getLeadTest - Lead: '+ lead.Name);
        System.assertNotEquals(null,lead.name, 'Expected a Lead to be returned');
        System.debug('--- getLeadTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getLeadTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getLeadsTest(){
        List<Id> leadIds = new List<Id>{b2cLeadId};
        Test.startTest();
        List<Lead> leads = LeadController.getLeads(leadIds);
        System.Debug ('----'+ leads.size() +' Leads Returned');
        if (leads.size()>0){
            System.Debug (leads);
        }
        System.assertNotEquals(0,leads.size(), 'Expected One or More Leads to be returned');
        System.debug('--- getLeadsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getLeadsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
	static void convertLeadsTest () {
        Id leadToConvert = b2cLeadId;
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- convertLeadsTest - Input: '+leadToConvert);
        try {
        	converterOutput = LeadController.convertLeads(new List<Id>{leadToConvert});
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('--- convertLeadsTest - Output: '+converterOutput);
        System.debug('--- convertLeadsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- convertLeadsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
	}
    @IsTest
	static void convertMCLeadsTest () {        
        Id leadToConvertId = mcLeadId;
        Lead leadToConvert = LeadController.getLead(mcLeadId);
        leadToConvert.Email_Opt_In__c = True;
        Update leadToConvert;
        Lead convertedLead = new Lead();
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- convertMCLeadsTest - Input: '+leadToConvert);
        try {
        	converterOutput = LeadController.convertLeads(new List<Id>{leadToConvertId});
            convertedLead = LeadController.getLead(mcLeadId);
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        System.debug('--- convertMCLeadsTest - Output: '+converterOutput);
        System.assertEquals(true,convertedlead.Finland_Sync_to_MC__c, ' Sync to MC False for Finland');
        System.assertEquals(false,convertedlead.Other_Countries_Sync_to_MC__c, ' Sync to MC True for Other Countries');
        System.assertEquals(false,convertedlead.Spain_Sync_to_MC__c, ' Sync to MC True for Spain');

        Lead convertedLeadRelations = [SELECT Id, ConvertedAccount.Finland_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc,ConvertedAccount.Spain_Sync_to_MC__pc,
                             			ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c,ConvertedContact.Spain_Sync_to_MC__c,
                             			ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c,ConvertedOpportunity.Spain_Sync_to_MC__c
                                     FROM Lead WHERE ID =: mcLeadId LIMIT 1];
        System.assertEquals(true,convertedlead.ConvertedAccount.Finland_Sync_to_MC__pc, ' Sync to MC False for Finland');
        System.assertEquals(false,convertedlead.ConvertedAccount.Other_Countries_Sync_to_MC__pc, ' Sync to MC True for Other Countries');
        System.assertEquals(false,convertedlead.ConvertedAccount.Spain_Sync_to_MC__pc, ' Sync to MC True for Spain');

        System.assertEquals(true,convertedlead.ConvertedContact.Finland_Sync_to_MC__c, ' Sync to MC False for Finland');
        System.assertEquals(false,convertedlead.ConvertedContact.Other_Countries_Sync_to_MC__c, ' Sync to MC True for Other Countries');
        System.assertEquals(false,convertedlead.ConvertedContact.Spain_Sync_to_MC__c, ' Sync to MC True for Spain');

        System.assertEquals(true,convertedlead.ConvertedOpportunity.Finland_Sync_to_MC__c, ' Sync to MC False for Finland');
        System.assertEquals(false,convertedlead.ConvertedOpportunity.Other_Countries_Sync_to_MC__c, ' Sync to MC True for Other Countries');
        System.assertEquals(false,convertedlead.ConvertedOpportunity.Spain_Sync_to_MC__c, ' Sync to MC True for Spain');
		System.debug('--- convertMCLeadsTest - Lead Output: '+convertedLead);
        System.debug('--- convertMCLeadsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- convertMCLeadsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
	}
}