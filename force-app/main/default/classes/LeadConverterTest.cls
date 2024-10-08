/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class LeadConverterTest {
	/*@IsTest
	static void convertLeadsB2BTest () {
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'B2B Lead' LIMIT 1];
        Lead leadToCreate = new Lead(RecordTypeId = rt.Id, FirstName = 'My',
                                    LastName = 'Test Conversion', 
                                    Company = 'SFDC', MobilePhone = '+48500500500', 
                                    PostalCode = '97979', Country = 'Finland', 
                                    City = 'Kaupunki',Street = 'Katu 1',
                                    Business_Type__c = 'Reseller', Property_Type__c = 'APA',
                                    Customer_Segment__c = '1000');
        insert leadToCreate;
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- LeadConverterTest - Converter Input : '+leadToCreate.Id);
        System.debug('--- LeadConverterTest - Converter Input Lead Business Type : '+leadToCreate.Business_Type__c);
        System.debug('--- LeadConverterTest - Converter Input Lead Business Type : '+leadToCreate.Property_Type__c);
        System.debug('--- LeadConverterTest - Converter Input Lead Business Type : '+leadToCreate.Customer_Segment__c);
        try {
        	converterOutput = LeadConverter.convertLeads(new List<Id>{leadToCreate.Id});
        } catch (Exception e) {
            System.debug('--- LeadConverterTest - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('--- LeadConverterTest - Converter Output : '+converterOutput);
        Test.stopTest();
	}*/
    @IsTest
	static void convertLeadB2CTest () {
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'B2C Lead' LIMIT 1];
        Lead leadToCreate = new Lead(RecordTypeId = rt.Id, FirstName = 'My',
                                    LastName = 'Test Conversion',
									MobilePhone = '+34800500500', 
                                    PostalCode = '97979', Country = 'Finland', 
                                    City = 'City',Street = 'Street 123',
                                    Business_Type__c = 'Consumer', Property_Type__c = 'COT',
                                    Customer_Segment__c = '1100');
        insert leadToCreate;
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- LeadConverterTest - Converter Input : '+leadToCreate.Id);
        System.debug('--- LeadConverterTest - Converter Input Lead Business Type : '+leadToCreate.Business_Type__c);
        System.debug('--- LeadConverterTest - Converter Input Lead Property Type : '+leadToCreate.Property_Type__c);
        System.debug('--- LeadConverterTest - Converter Input Lead Customer Segment : '+leadToCreate.Customer_Segment__c);
        try {
        	converterOutput = LeadConverter.convertLeads(new List<Id>{leadToCreate.Id});
        } catch (Exception e) {
            System.debug('--- LeadConverterTest - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('--- LeadConverterTest - Converter Output : '+converterOutput);
        Test.stopTest();
	}
    @IsTest
	static void convertLeadsB2CTest () {
		RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'B2C Lead' LIMIT 1];
        Lead leadToCreate1 = new Lead(RecordTypeId = rt.Id, FirstName = 'My',
                                    LastName = 'Test Conversion 1',
									MobilePhone = '+34800500501', 
                                    PostalCode = '97979', Country = 'Finland', 
                                    City = 'City',Street = 'Street 123 1',
                                    Business_Type__c = 'Consumer', Property_Type__c = 'COT',
                                    Customer_Segment__c = '1100');
        insert leadToCreate1;
        Lead leadToCreate2 = new Lead(RecordTypeId = rt.Id, FirstName = 'My',
                                    LastName = 'Test Conversion 2',
									MobilePhone = '+34800500502', 
                                    PostalCode = '97979', Country = 'Finland', 
                                    City = 'City',Street = 'Street 123 2',
                                    Business_Type__c = 'Consumer', Property_Type__c = 'COT',
                                    Customer_Segment__c = '1100');
        insert leadToCreate2;
        Test.startTest();
        List<List<String>> converterOutput = new List<List<String>>();
		System.debug('--- LeadConverterTest - Converter Input : '+leadToCreate1.Id);
		System.debug('--- LeadConverterTest - Converter Input : '+leadToCreate2.Id);
        List<Id> leadIds = new List<Id>();
        leadIds.add(leadToCreate1.Id);
        leadIds.add(leadToCreate2.Id);
        try {
        	converterOutput = LeadConverter.convertLeads(leadIds);
        } catch (Exception e) {
            System.debug('--- LeadConverterTest - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('--- LeadConverterTest - Converter Output : '+converterOutput);
        Test.stopTest();
	}
}