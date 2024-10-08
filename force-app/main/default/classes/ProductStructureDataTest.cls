/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-26-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public with sharing class ProductStructureDataTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   
    public static String structureJSON = [SELECT Body FROM StaticResource WHERE Name = 'Example_Structure_LGS' ].Body.toString();
    //public static String documentationXML = [SELECT Body FROM StaticResource WHERE Name = 'TestDocumentationXML' ].Body.toString();
    //public static String structureXML;// = [SELECT Body FROM StaticResource WHERE Name = 'TestStructureXML' ].Body.toString();
    @IsTest
    static void parseStructureJSONTest(){       
        Test.startTest();
		ProductStructureData.Structure structureData = ProductStructureData.parseStructureJSON(structureJSON);
        System.debug('--- ProductStructureDataTest - parseStructureJSONTest - structureData: '+structureData); 
        System.assertNotEquals(null,structureData, 'Expected JSON to be parsed');
        System.debug('--- ProductStructureDataTest - parseStructureJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- ProductStructureDataTest - parseStructureJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}