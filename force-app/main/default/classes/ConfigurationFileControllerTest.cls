/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-08-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationFileControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestConfigurationFiles.setupConfigFiles();
        Test.stopTest();
    }
	@IsTest
    static void getConfigurationFilesTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Test.startTest();
        List<ContentDocumentLink>  configFiles = ConfigurationFileController.getConfigurationFiles(recordId); 
        System.assertNotEquals(0, configFiles.size(), 'Expecting Configuration Files to be returned');
        System.debug('--- getConfigurationFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getFileNameToLinkMapTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Test.startTest();
        Map<String,ContentDocumentLink> configFileMap = ConfigurationFileController.getFileNameToLinkMap(recordId); 
        System.assertNotEquals(null, configFileMap, 'Expecting Configuration File Map to be returned');
        System.debug('--- getFileNameToLinkMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getFileNameToLinkMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getVisualPricingFilesTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Test.startTest();
        List<ContentDocumentLink> configPricingFiles = ConfigurationFileController.getVisualPricingFiles(recordId); 
        System.assertNotEquals(0, configPricingFiles.size(), 'Expecting Configuration Pricing File to be returned');
        System.debug('--- getVisualPricingFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualPricingFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getVisualStructureFilesTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Test.startTest();
        List<ContentDocumentLink> configStructureFiles = ConfigurationFileController.getVisualStructureFiles(recordId); 
        System.assertNotEquals(0, configStructureFiles.size(), 'Expecting Configuration Structure File to be returned');
        System.debug('--- getVisualStructureFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualStructureFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    @IsTest
    static void getVisualDocumentationFilesTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Test.startTest();
        List<ContentDocumentLink> configDocumentationFiles = ConfigurationFileController.getVisualDocumentationFiles(recordId); 
        System.assertNotEquals(0, configDocumentationFiles.size(), 'Expecting Configuration Documentation File to be returned');
        System.debug('--- getVisualDocumentationFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualDocumentationFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    /*@IsTest
    static void getFileContentTest(){     
        String recordId = LumonTestConfigurationFiles.opportunityId;
        Id fileVersionId = [SELECT Id FROM ContentVersion LIMIT 1]?.Id;
        MockResponseGenerator mockResp = new MockResponseGenerator(JSON.serialize(response), 200);
		Test.setMock(HttpCalloutMock.class, mockResp);		
        Test.startTest();       
        String fileContent = ConfigurationFileController.getFileContent(fileVersionId);     
        System.assertNotEquals(null, fileContent, 'Expecting Configuration File Content to be returned');
        System.debug('--- getFileContentTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getFileContentTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }*/ 
}