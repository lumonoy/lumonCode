/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-04-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class FieldServiceWorkControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        Product2 p1 = new Product2(Name='Lumon Glazing Retractable', 
                                   IsActive=True,
                                   ProductCode='LG',
                                   Product_Group__c='LG',
                                   Product_Category__c='Product Groups',
                                   Sales_Code__c = '90240001',
                                   Installation__c = true,
                                   Configurator__c = 'Visual');
        insert p1;
        WorkType wt = new WorkType(Name = 'Installation',
                                   Type__c = 'New Product installation',
        						   ShouldAutoCreateSvcAppt = true,
        						   FSL__Due_Date_Offset__c = 60*24*7, // 1 week in minutes
        						   DurationType = 'Minutes',
        						   EstimatedDuration = 60);
        insert wt;
    }
    @isTest
	static void testDoPost(){
		
        RestRequest req = new RestRequest(); 

        RestResponse res = new RestResponse();
		StaticResource sr= [SELECT id, body FROM StaticResource WHERE Name = 'plantori_test2_json' limit 1];
        req.requestURI = '/services/apexrest/FieldServiceInstallationApi/';  
		req.requestBody = sr.body;
        req.httpMethod = 'POST';

        RestContext.request = req;

        RestContext.response = res;
		
        Test.startTest();

        FieldServiceWorkApi.processOrderMessage();

        Test.stopTest();

    }   
    @isTest
	static void testDoPostCatch(){
		
        RestRequest req = new RestRequest(); 

        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FieldServiceInstallationApi/';  
        req.httpMethod = 'POST';

        RestContext.request = req;

        RestContext.response = res;
		
        Test.startTest();

        FieldServiceWorkApi.processOrderMessage();

        Test.stopTest();

    }   

  }