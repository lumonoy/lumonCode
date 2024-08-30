/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/

@IsTest
private class ProcessSoveliaOutputTest {
	@TestSetup
	static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
	private static Id b2cConfigurationPlanId =LumonTestDataFactory.b2cConfigurationPlanId;

	@isTest
	static void processSoveliaOutputTest() {
		String rvn = [SELECT Id,RVN__c FROM Configuration_Product__c WHERE Configuration__c =: b2cConfigurationPlanId]?.get(0).RVN__c;
		String configString = '{"id":"1234", "name":"test123", "products":[{"rvn":"' + rvn + '"}]}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/soveliaOutput/' + b2cOpportunityId + '/pricing/json';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf(configString)));
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();
		ProcessSoveliaOutput.doPost();
		Test.stopTest();
		System.assert([SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: b2cConfigurationPlanId] > 0, 'There should be document created');
	}

	@isTest
	static void processSoveliaOutputReportTest() {
		String rvn = [SELECT Id,RVN__c FROM Configuration_Product__c WHERE Configuration__c =: b2cConfigurationPlanId]?.get(0).RVN__c;
		String configString = '{"RVN":"' + rvn + '"}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/soveliaOutput/' + b2cOpportunityId + '/report/json';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf(configString)));

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessSoveliaOutput.doPost();

		Test.stopTest();

		System.assert([SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: b2cConfigurationPlanId] > 0, 'There should be document created');
	}

	@isTest
	static void processSoveliaOutputCatchTest() {
		String rvn = [SELECT Id,RVN__c FROM Configuration_Product__c WHERE Configuration__c =: b2cConfigurationPlanId LIMIT 1]?.RVN__c;
		String configString = '{"RVN":"WRONG_RVN"}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/soveliaOutput/' + b2cOpportunityId + '/report/json';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf(configString)));

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessSoveliaOutput.doPost();

		Test.stopTest();
	}

	@isTest
	static void processSoveliaOutputCatch2Test() {
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =: b2cOpportunityId LIMIT 1];
		Configuration__c config = [SELECT Id FROM Configuration__c WHERE Id =:b2cConfigurationPlanId LIMIT 1];

		String configString = '{"test":"test123"}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/soveliaOutput/' + b2cOpportunityId + '/pricing/json';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf(EncodingUtil.base64Encode(Blob.valueOf(configString)));

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessSoveliaOutput.doPost();

		Test.stopTest();
	}
}