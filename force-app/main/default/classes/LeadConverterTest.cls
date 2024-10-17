/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class LeadConverterTest {
	@TestSetup
    static void prepareData() { 
        Test.startTest();
        LumonTestLeads.setupLeadB2C();
        Test.stopTest();
    }     
    
    @IsTest
	static void convertLeadsB2CTest () {
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'B2C Lead' LIMIT 1];
        Lead leadToCreate = LumonTestLeads.b2cLead;
        insert leadToCreate;
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- LeadConverterTest - Input : '+leadToCreate.Id);
        System.debug('--- LeadConverterTest - Business Type : '+leadToCreate.BusinessType__c);
        System.debug('--- LeadConverterTest - Property Type : '+leadToCreate.PropertyType__c);
        System.debug('--- LeadConverterTest - Segment : '+leadToCreate.CustomerSegment__c);
        try {
        	converterOutput = LeadConverter.convertLeads(new List<Id>{leadToCreate.Id});
        } catch (Exception e) {
            System.debug('--- LeadConverterTest - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('--- LeadConverterTest - Output : '+converterOutput);
        Test.stopTest();
	}
}