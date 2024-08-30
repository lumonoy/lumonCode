/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ConfigurationItemsTest {
    @IsTest
    static void parseZeroItemsTest() {
        String itemsJSON = '{'+
        '    \"ParentId\": \"123\",'+
        '    \"lineItems\": []'+
        '  }';  
        ConfigurationItems items = ConfigurationItems.parseConfigurationItems(itemsJSON);
        System.assert(items != null);
    }
    @IsTest
    static void parseOneItemTest() {
        String itemsJSON = '{'+
        '    \"ParentId\": \"123\",'+
        '    \"lineItems\": ['+
        '      {'+
        '        \"ProductCode\": \"item 1\",'+
        '        \"Product2Id\": \"123\",'+
        '        \"Quantity\": 10.0,'+
        '        \"UnitOfMeasure\": \"pcs\",'+
        '        \"BasePrice\": 1,'+
        '        \"FactoryPrice\": 2,'+
        '        \"Cost\": 1.50,'+
        '        \"UnitPrice\": 10.50,'+
        '        \"SalesPrice\": 21.00'+
        '      }'+
        '    ]'+
        '  }';  
        ConfigurationItems items = ConfigurationItems.parseConfigurationItems(itemsJSON);
        System.assert(items != null);
    }
}