/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ProcessVisualOutputTest {
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
	static void processVisualOutputTest() {
		String configString = '{'+
		'    \"apartment\": \"A1\",'+
		'    \"floor\": \"6\",'+
		'    \"id\": \"ABCDE1\",'+
		'    \"line\": \"123\",'+
		'    \"name\": \"Test Plan 1\",'+
		'    \"version\": 3,'+
		'    \"products\": ['+
		'      {'+
		'        \"id\": \"visualProductId1\",'+
		'        \"name\": \"COST\",'+
		'        \"productLength\": 0.0,'+
		'        \"priceParameters\": ['+
		'          {'+
		'            \"Amount\": 1.0,'+
		'            \"LocalSupplier\": true,'+
		'            \"ParameterCode\": \"\",'+
		'            \"SalesCode\": \"Option 1\",'+
		'            \"UniqueId\": 1,'+
		'            \"Unit\": \"PCS\"'+
		'          }'+
		'        ],'+
		'        \"rvn\": \"12345678\",'+
		'        \"hasFeaturesBeenConfirmed\": true,'+
		'        \"hasMeasurementsBeenVerified\": true,'+
		'        \"productInspectCode\": 2,'+
		'        \"productInspectMessageKeys\": ['+
		'          {'+
		'            \"MessageKey\": \"E11111\",'+
		'            \"SpaceSideNumber\": 1'+
		'          }'+
		'        ],'+
		'        \"reclaimedFeatureMessageKeys\": []'+
		'      }'+
		'    ]'+
		'  }'; 
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/processOutput/' + b2cOpportunityId + '&1234&' + b2cConfigurationPlanId + '/PricingDoc/json';
		req.httpMethod = 'POST';
		//req.requestBody = Blob.valueOf('{"test":"testValue"}');
		req.requestBody = Blob.valueOf(configString);

		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();
		ProcessVisualOutput.doPost();
		Test.stopTest();
		System.assertNotEquals(0, [SELECT count() FROM Configuration__c WHERE Opportunity__c =: b2cOpportunityId]);
	}

	@isTest
	static void processVisualOutput2Test() {
		String configString = '{'+
		'    \"apartment\": \"A1\",'+
		'    \"floor\": \"6\",'+
		'    \"id\": \"ABCDE1\",'+
		'    \"line\": \"123\",'+
		'    \"name\": \"Test Plan 1\",'+
		'    \"version\": 3,'+
		'    \"products\": ['+
		'      {'+
		'        \"id\": \"visualProductId1\",'+
		'        \"name\": \"COST\",'+
		'        \"productLength\": 0.0,'+
		'        \"priceParameters\": ['+
		'          {'+
		'            \"Amount\": 1.0,'+
		'            \"LocalSupplier\": true,'+
		'            \"ParameterCode\": \"\",'+
		'            \"SalesCode\": \"Option 1\",'+
		'            \"UniqueId\": 1,'+
		'            \"Unit\": \"PCS\"'+
		'          }'+
		'        ],'+
		'        \"rvn\": \"12345678\",'+
		'        \"hasFeaturesBeenConfirmed\": true,'+
		'        \"hasMeasurementsBeenVerified\": true,'+
		'        \"productInspectCode\": 2,'+
		'        \"productInspectMessageKeys\": ['+
		'          {'+
		'            \"MessageKey\": \"E11111\",'+
		'            \"SpaceSideNumber\": 1'+
		'          }'+
		'        ],'+
		'        \"reclaimedFeatureMessageKeys\": []'+
		'      }'+
		'    ]'+
		'  }'; 
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/processOutput/' + b2cOpportunityId + '&1234&/PricingDoc/json';
		req.httpMethod = 'POST';
		//req.requestBody = Blob.valueOf('{"test":"testValue"}');
		req.requestBody = Blob.valueOf(configString);

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessVisualOutput.doPost();

		Test.stopTest();
	}

	@isTest
	static void processVisualOutput3Test() {
		String configString = '{'+
		'    \"apartment\": \"A1\",'+
		'    \"floor\": \"6\",'+
		'    \"id\": \"ABCDE1\",'+
		'    \"line\": \"123\",'+
		'    \"name\": \"Test Plan 1\",'+
		'    \"version\": 3,'+
		'    \"products\": ['+
		'      {'+
		'        \"id\": \"visualProductId1\",'+
		'        \"name\": \"COST\",'+
		'        \"productLength\": 0.0,'+
		'        \"priceParameters\": ['+
		'          {'+
		'            \"Amount\": 1.0,'+
		'            \"LocalSupplier\": true,'+
		'            \"ParameterCode\": \"\",'+
		'            \"SalesCode\": \"Option 1\",'+
		'            \"UniqueId\": 1,'+
		'            \"Unit\": \"PCS\"'+
		'          }'+
		'        ],'+
		'        \"rvn\": \"12345678\",'+
		'        \"hasFeaturesBeenConfirmed\": true,'+
		'        \"hasMeasurementsBeenVerified\": true,'+
		'        \"productInspectCode\": 2,'+
		'        \"productInspectMessageKeys\": ['+
		'          {'+
		'            \"MessageKey\": \"E11111\",'+
		'            \"SpaceSideNumber\": 1'+
		'          }'+
		'        ],'+
		'        \"reclaimedFeatureMessageKeys\": []'+
		'      }'+
		'    ]'+
		'  }'; 
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/processOutput/' + b2cOpportunityId + '&&/PricingDoc/json';
		req.httpMethod = 'POST';
		//req.requestBody = Blob.valueOf('{"test":"testValue"}');
		req.requestBody = Blob.valueOf(configString);

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessVisualOutput.doPost();

		Test.stopTest();
	}

	@isTest
	static void processVisualOutput4Test() {
		String configString = '{'+
		'    \"apartment\": \"A1\",'+
		'    \"floor\": \"6\",'+
		'    \"id\": \"ABCDE1\",'+
		'    \"line\": \"123\",'+
		'    \"name\": \"Test Plan 1\",'+
		'    \"version\": 3,'+
		'    \"products\": ['+
		'      {'+
		'        \"id\": \"visualProductId1\",'+
		'        \"name\": \"COST\",'+
		'        \"productLength\": 0.0,'+
		'        \"priceParameters\": ['+
		'          {'+
		'            \"Amount\": 1.0,'+
		'            \"LocalSupplier\": true,'+
		'            \"ParameterCode\": \"\",'+
		'            \"SalesCode\": \"Option 1\",'+
		'            \"UniqueId\": 1,'+
		'            \"Unit\": \"PCS\"'+
		'          }'+
		'        ],'+
		'        \"rvn\": \"12345678\",'+
		'        \"hasFeaturesBeenConfirmed\": true,'+
		'        \"hasMeasurementsBeenVerified\": true,'+
		'        \"productInspectCode\": 2,'+
		'        \"productInspectMessageKeys\": ['+
		'          {'+
		'            \"MessageKey\": \"E11111\",'+
		'            \"SpaceSideNumber\": 1'+
		'          }'+
		'        ],'+
		'        \"reclaimedFeatureMessageKeys\": []'+
		'      }'+
		'    ]'+
		'  }'; 
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/processOutput/' + b2cOpportunityId + '&1234&/PricingDoc/json';
		req.httpMethod = 'POST';
		//req.requestBody = Blob.valueOf('{"test":"testValue"}');
		req.requestBody = Blob.valueOf(configString);

		RestContext.request = req;
		RestContext.response= res;

		Test.startTest();

		ProcessVisualOutput.doPost();

		Test.stopTest();
	}
}