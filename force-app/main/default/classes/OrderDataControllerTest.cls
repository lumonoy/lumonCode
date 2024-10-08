/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-13-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public with sharing class OrderDataControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   

    @IsTest
    static void parseOrderMessageJSONTest(){  
        String orderMessageJSON = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessage' ].Body.toString();     
        Test.startTest();
		OrderData orderData = OrderDataController.parseOrderMessageJSON(orderMessageJSON);
        System.debug('--- OrderDataControllerTest - parseOrderMessageJSONTest - orderData: '+orderData); 
        System.assertNotEquals(null,orderData, 'Expected JSON to be parsed');
        System.debug('--- OrderDataControllerTest - parseOrderMessageJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseOrderMessageJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseOrderMessageFrends1Test(){    
        String orderMessageJSON = [SELECT Body FROM StaticResource WHERE Name = 'plantori_test1_json' ].Body.toString();   
        Test.startTest();
		OrderData orderData = OrderDataController.parseOrderMessageJSON(orderMessageJSON);
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends1Test - orderData: '+orderData); 
        System.assertNotEquals(null,orderData, 'Expected JSON to be parsed');
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends1Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends1Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseOrderMessageFrends2Test(){  
        String orderMessageJSON = [SELECT Body FROM StaticResource WHERE Name = 'plantori_test2_json' ].Body.toString();     
        Test.startTest();
		OrderData orderData = OrderDataController.parseOrderMessageJSON(orderMessageJSON);
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends2Test - orderData: '+orderData); 
        System.assertNotEquals(null,orderData, 'Expected JSON to be parsed');
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends2Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseOrderMessageFrends2Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseXMLTest(){   
        String orderMessageXML = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessageXML' ].Body.toString();    
        Test.startTest();
		String orderMessageJSON = OrderDataController.parseXML(orderMessageXML);
        System.debug('--- OrderDataControllerTest - parseXMLTest - orderData: '+orderMessageJSON); 
        System.assertNotEquals(null,orderMessageXML, 'Expected XML to be parsed');
        System.debug('--- OrderDataControllerTest - parseXMLTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseXMLTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseOrderMessageXMLTest(){  
        String orderMessageXML = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessageXML' ].Body.toString();     
        Test.startTest();
		OrderData orderData = OrderDataController.parseOrderMessageXML(orderMessageXML);
        System.debug('--- OrderDataControllerTest - parseOrderMessageXMLTest - orderData: '+orderData); 
        System.assertNotEquals(null,orderData, 'Expected XML to be parsed');
        System.debug('--- OrderDataControllerTest - parseOrderMessageXMLTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseOrderMessageXMLTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void parseOrderMessageTest(){ 
        String orderMessageXML = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessageXML' ].Body.toString();   
        String orderMessageJSON = [SELECT Body FROM StaticResource WHERE Name = 'plantori_test2_json' ].Body.toString();       
        Test.startTest();  
		OrderData orderData1 = OrderDataController.parseOrderMessage(orderMessageXML);
        System.debug('--- OrderDataControllerTest - parseOrderMessageTest - orderData from XML: '+orderData1); 
        System.assertNotEquals(null,orderData1, 'Expected One or More Entries to be returned');
        OrderData orderData2 = OrderDataController.parseOrderMessage(orderMessageJSON);
        System.debug('--- OrderDataControllerTest - parseOrderMessageTest - orderData from JSON: '+orderData2); 
        System.assertNotEquals(null,orderData2, 'Expected One or More Entries to be returned');
        System.assertEquals(orderData1,orderData2, 'Expected result to be equal');
        System.debug('--- OrderDataControllerTest - parseOrderMessageTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- OrderDataControllerTest - parseOrderMessageTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}