/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-08-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class InboundDataApiControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        Product2 mainProduct = new Product2(Name='Lumon Glazing Retractable', 
                                   IsActive=True,
                                   ProductCode='LG',
                                   ProductGroup__c='LG',
                                   ProductCategory__c='Product Groups',
                                   ProductCode__c = '90240001',
                                   Installation__c = true,
                                   Configurator__c = 'Visual');
        insert mainProduct;
        WorkType workType = new WorkType(Name = 'Installation',
                                            Type__c = 'New Product installation',
                                            ShouldAutoCreateSvcAppt = true,
                                            FSL__Due_Date_Offset__c = 60*24*7, // 1 week in minutes
                                            DurationType = 'Minutes',
                                            EstimatedDuration = 60);
        insert workType;
    }
    @isTest
	static void testDoPost(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
		StaticResource sr= [SELECT id, body FROM StaticResource WHERE Name = 'orderMessage_project_batch1' LIMIT 1];
        req.requestURI = '/services/apexrest/InboundDataApi/';  
		req.requestBody = sr.body;
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
		
        Test.startTest();
        InboundDataApiController.doPost();
        Test.stopTest();

    }   
    @isTest
	static void testDoPostCatch(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/InboundDataApi/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;		
        Test.startTest();
        InboundDataApiController.doPost();
        Test.stopTest();
    }   

  }