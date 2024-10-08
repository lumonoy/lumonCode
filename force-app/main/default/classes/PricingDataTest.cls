/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-14-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
private class PricingDataTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   

    @IsTest
    static void parsePricingJSONTest(){  
        String pricingJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();     
        Test.startTest();
		PricingData.PricingItems pricingItems = PricingData.parsePricingJSON(pricingJSON);
        System.debug('--- PricingDataTest - parsePricingJSONTest - pricingItems: '+pricingItems); 
        System.assertNotEquals(null,pricingItems, 'Expected JSON to be parsed');
        System.debug('--- PricingDataTest - parsePricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingDataTest - parsePricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parsePricingReclamationJSONTest(){  
        String pricingJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestPricingReclamationJSON' ].Body.toString();     
        Test.startTest();
		PricingData.PricingItems pricingItems = PricingData.parsePricingJSON(pricingJSON);
        System.debug('--- PricingDataTest - parsePricingReclamationJSONTest - pricingItems: '+pricingItems); 
        System.assertNotEquals(null,pricingItems, 'Expected JSON to be parsed');
        System.debug('--- PricingDataTest - parsePricingReclamationJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingDataTest - parsePricingReclamationJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}