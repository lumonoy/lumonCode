/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class CloneConfigurationControllerTest {
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
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
	private static Id b2cConfigurationPlanId = LumonTestDataFactory.b2cConfigurationPlanId;

	@IsTest
	static void cloneConfigurationTest() {
		//String expectedVisualId = '12345';
		String expectedVisualId = 'B2C-ABCDE1';
		List<String> resp;
        Configuration__c configuration = [SELECT Id,Opportunity__c,Visual_Id__c FROM Configuration__c LIMIT 1];
        System.debug('--- configuration: '+configuration);
				
        Test.startTest();
        String body = '{"error": null,"items": [{"origWebId": "ABCDE","copies": ["' + expectedVisualId + '"]}]}';
		MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
		Test.setMock(HttpCalloutMock.class, mockResp);
        resp = CloneConfigurationController.cloneConfiguration(new List<Id>{configuration.Id});
        System.debug('--- mock response: '+resp);
        Test.stopTest();
        System.debug('--- b2cConfigurationPlanId: '+b2cConfigurationPlanId);
		Configuration__c config = [SELECT Visual_Id__c FROM Configuration__c WHERE Id =: b2cConfigurationPlanId LIMIT 1];
		System.assertEquals(expectedVisualId, config.Visual_Id__c, 'Config Visual Id value should be updated!');
        System.debug('--- cloneConfigurationTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- cloneConfigurationTest - SOQL USED: ' + LIMITS.getQueries());       
	}	
	@IsTest
	static void cloneMultipleTest() {
		AutomationBypass__c bypass = new AutomationBypass__c();
        bypass.SkipAutomation__c = true;
        insert bypass;
        Opportunity opp = [SELECT Id,Order_type__c,Name,CloseDate,StageName FROM Opportunity LIMIT 1];		
		List<Configuration__c> configurations = new List<Configuration__c>{
			new Configuration__c(opportunity__c = opp.Id, Visual_Id__c = 'AAAAA'),
			new Configuration__c(opportunity__c = opp.Id, Visual_Id__c = ''),
			new Configuration__c(opportunity__c = opp.Id, Visual_Id__c = 'BBBBB')
		};
		insert configurations;			
		CloneConfigurationController.ItemWrapper responseItem1 = new CloneConfigurationController.ItemWrapper();
		responseItem1.origWebId = configurations.get(0).Visual_Id__c;
		responseItem1.copies = new List<String> { 'AAAA2' };
		CloneConfigurationController.ItemWrapper responseItem2 = new CloneConfigurationController.ItemWrapper();
		responseItem1.origWebId = configurations.get(2).Visual_Id__c;
		responseItem2.copies = new List<String> { 'BBBB2' };
		CloneConfigurationController.ResponseWrapper response = new CloneConfigurationController.ResponseWrapper();
		response.error = null;
		response.items = new List<CloneConfigurationController.ItemWrapper>{
			responseItem1,
			responseItem2
		};
		MockResponseGenerator mockResp = new MockResponseGenerator(JSON.serialize(response), 200);
		Test.setMock(HttpCalloutMock.class, mockResp);		
		List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet());       
		Test.startTest();
		List<Configuration__c> updatedConfigurations =
			CloneConfigurationController.cloneVisualConfigurations(opp.Id, new List<Id> {
				configurations.get(1).Id
			});
		Assert.isNull(updatedConfigurations, 'Nothing should have been returned');
		updatedConfigurations =
			CloneConfigurationController.cloneVisualConfigurations(opp.Id, configurationIds);
		Assert.areEqual(responseItem1.copies.get(0), updatedConfigurations.get(0).Visual_Id__c, 'Visual ids should match');
		Assert.areEqual(responseItem2.copies.get(0), updatedConfigurations.get(1).Visual_Id__c, 'Visual ids should match');
		CloneConfigurationController.cloneConfigurationPlan(opp.id,configurationIds);
        Test.stopTest();
        System.debug('--- cloneMultipleTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- cloneMultipleTest - SOQL USED: ' + LIMITS.getQueries());
	} 
    /*
    @IsTest
	static void cloneOpportunityTest() {
        String result;
        Test.startTest();
        Try{
            CloneConfigurationController.cloneOpportunity(b2cOpportunityId);
            result = 'Success';
        } catch(Exception e){
           	result = 'Error';
        }
        Test.stopTest();
		System.assertNotEquals('Error', result, 'Opportunity Clones should be executed!');
        System.debug('--- cloneOpportunityTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- cloneOpportunityTest - SOQL USED: ' + LIMITS.getQueries());        
	}	*/
}