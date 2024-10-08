/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-15-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public with sharing class PricingDataProcessorTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   

    @IsTest
    static void deserializeTest(){  
        String pricingJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();     
        Test.startTest();
        PricingData planObject = PricingDataProcessor.deserialize(pricingJSON);
        System.debug('--- PricingDataProcessorTest - deserializeTest - plan: '+planObject); 
        System.assertNotEquals(null,planObject, 'Expected JSON to be parsed');
        System.debug('--- PricingDataProcessorTest - deserializeTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingDataProcessorTest - deserializeTest - SOQL USED: ' + LIMITS.getQueries());
    }
    @IsTest
    static void deserializeUntypedTest(){  
        String pricingJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();     
        Test.startTest();
        Map<String, Object> planObject = PricingDataProcessor.deserializeUntyped(pricingJSON);
        System.debug('--- PricingDataProcessorTest - deserializeUntypedTest - plan: '+planObject); 
        System.assertNotEquals(null,planObject, 'Expected JSON to be parsed');
        System.debug('--- PricingDataProcessorTest - deserializeUntypedTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingDataProcessorTest - deserializeUntypedTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseTest(){  
        String pricingJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();     
        Test.startTest();
        PricingData.ConfigurationPlan plan = PricingData.parsePricingJSON(pricingJSON);
        System.debug('--- PricingDataProcessorTest - parseTest - plan: '+plan); 
        System.assertNotEquals(null,plan, 'Expected JSON to be parsed');
        System.debug('--- PricingDataProcessorTest - parseTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingDataProcessorTest - parseTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}