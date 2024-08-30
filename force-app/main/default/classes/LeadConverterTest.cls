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
		System.debug('*** Converter Input : '+leadToCreate.Id);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Business_Type__c);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Property_Type__c);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Customer_Segment__c);
        try {
        	converterOutput = LeadConverter.convertLeads(new List<Id>{leadToCreate.Id});
        } catch (Exception e) {
            System.debug('*** The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('*** Converter Output : '+converterOutput);
        Test.stopTest();
	}*/
    @IsTest
	static void convertLeadsB2CTest () {
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
		System.debug('*** Converter Input : '+leadToCreate.Id);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Business_Type__c);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Property_Type__c);
        System.debug('*** Converter Input Lead Business Type : '+leadToCreate.Customer_Segment__c);
        try {
        	converterOutput = LeadConverter.convertLeads(new List<Id>{leadToCreate.Id});
        } catch (Exception e) {
            System.debug('*** The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
		System.debug('*** Converter Output : '+converterOutput);
        Test.stopTest();
	}
}