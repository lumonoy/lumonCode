@isTest
public class DynamicQueryUtilsTest { 
    @TestSetup
    static void PrepareAccountData(){       
        UtilsTestDataFactory.setupAccountRecords();
    }   
    @isTest
    static void getObjectDataTest() {
        Account acct = [SELECT Id FROM Account WHERE Name = 'B2C Account' LIMIT 1];
        String sObjectName = 'Account';
        String fieldNames = 'Id,Name';
		List<String> fieldNameList = new List<String>(fieldNames.split(','));
        String recordId = acct.Id;
        String orderBy = 'Name';
        String orderDir = 'desc';
		Integer recordLimit = 10000;
		List<sObject> myRecordData = DynamicQueryUtils.getObjectRecords(sObjectName, fieldNameList, recordLimit, recordId, Orderby, orderDir);
        System.assertNotEquals(myRecordData.size(),0,
        					'Expected atleast one Record to be returned');  
    }
    @isTest
    static void getChildDataTest() {
        Account acct = [SELECT Id FROM Account WHERE Name = 'B2B Account' LIMIT 1];
        Contact cont = new Contact(LastName='TestContact',MailingCountry='Germany',AccountId=acct.Id);
        insert cont;       
        String sObjectName = 'Contact';
        String fieldNames = 'Id,Name';
		List<String> fieldNameList = new List<String>(fieldNames.split(','));
        String recordId = acct.Id;
        String orderBy = 'Name';
        String orderDir = 'desc';
		Integer recordLimit = 10000;
		List<sObject> myChildRecordData = DynamicQueryUtils.getChildObjectRecords(sObjectName, fieldNameList, recordLimit, recordId, Orderby, orderDir);
        System.assertNotEquals(myChildRecordData.size(),0,'Expected atleast one Record to be returned');  
    }
    @isTest
    static void getAllObjectDataTest() {
        Account acct1 = [SELECT Id FROM Account WHERE Name = 'B2C Account' LIMIT 1];
        Account acct2 = [SELECT Id FROM Account WHERE Name = 'B2B Account' LIMIT 1];  
        String sObjectName = 'Account';
        String fieldNames = 'Id,Name';
		List<String> fieldNameList = new List<String>(fieldNames.split(','));
        String orderBy = 'Name';
        String orderDir = 'desc';
		Integer recordLimit = 10000;
		List<sObject> myObjectRecordData = DynamicQueryUtils.getAllObjectRecords(sObjectName, fieldNameList, recordLimit, Orderby, orderDir);
        System.assertNotEquals(myObjectRecordData.size(),0,'Expected atleast one Record to be returned');  
    }
    @isTest
    static void getAllObjectDataGroupedTest() {
        Account acct1 = [SELECT Id FROM Account WHERE Name = 'B2C Account' LIMIT 1];
        Account acct2 = [SELECT Id FROM Account WHERE Name = 'B2B Account' LIMIT 1];  
        String sObjectName = 'Account';
        String fieldNames = 'Id,Name,ShippingCountry,NumberOfEmployees';
		List<String> fieldNameList = new List<String>(fieldNames.split(','));
        String groupBy = 'ShippingCountry';
        String orderBy = 'ShippingCountry';
        String orderDir = 'desc';
		Integer recordLimit = 10000;
		List<sObject> myGroupedObjectRecordData = DynamicQueryUtils.getAllObjectRecordsGrouped(sObjectName, fieldNameList, recordLimit,groupBy, Orderby, orderDir);
        System.assertNotEquals(myGroupedObjectRecordData.size(),0,'Expected atleast one Record to be returned');  
    }
    @isTest
    static void getDataCountAndRollupTest() {
        Account acct1 = [SELECT Id FROM Account WHERE Name = 'B2C Account' LIMIT 1];
        Account acct2 = [SELECT Id FROM Account WHERE Name = 'B2B Account' LIMIT 1];  
        String sObjectName = 'Account';
        String fieldNames = 'ShippingCountry';
		List<String> fieldNameList = new List<String>(fieldNames.split(','));
        String countField = 'NumberOfEmployees';
        String counter = 'TotalEmployees';
        String rollupGroup = 'ShippingCountry';
		Integer recordLimit = 10000;
		List<sObject> myGroupedObjectRecordData = DynamicQueryUtils.getObjectRecordsCountedByRollup(sObjectName, fieldNameList, recordLimit,countField,counter, rollupGroup);
        System.assertNotEquals(myGroupedObjectRecordData.size(),0,'Expected atleast one Record to be returned');  
    }
}