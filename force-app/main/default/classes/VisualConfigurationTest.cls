/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class VisualConfigurationTest {
    @IsTest
    static void parseConfigOnlyTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigOneProductTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": [],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 1,'+
        '        \"productInspectMessageKeys\": [],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigTwoProductsTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": [],'+
        '        \"rvn\": \"1111111\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 1,'+
        '        \"productInspectMessageKeys\": [],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      },{'+
        '        \"id\": \"visualProductId2\",'+
        '        \"name\": \"Product2\",'+
        '        \"productLength\": 2.0,'+
        '        \"priceParameters\": [],'+
        '        \"rvn\": \"2222222\",'+
        '        \"hasFeaturesBeenConfirmed\": false,'+
        '        \"hasMeasurementsBeenVerified\": false,'+
        '        \"productInspectCode\": 2,'+
        '        \"productInspectMessageKeys\": [],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigOneParamTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"OP111111\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          }'+
        '        ],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 1,'+
        '        \"productInspectMessageKeys\": [],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigTwoParamsTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"OP111111\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          },'+
        '          {'+
        '            \"Amount\": 2.0,'+
        '            \"LocalSupplier\": false,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"OP22222\",'+
        '            \"UniqueId\": 2,'+
        '            \"Unit\": \"M2\"'+
        '          }'+
        '        ],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 1,'+
        '        \"productInspectMessageKeys\": [],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigOneErrorTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"OP111111\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          }'+
        '        ],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 2,'+
        '        \"productInspectMessageKeys\": ['+
        '          {'+
        '            \"MessageKey\": \"E11111\",'+
        '            \"SpaceSideNumber\": 1'+
        '          }'+
        '        ],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
    @IsTest
    static void parseConfigTwoErrorsTest() {
        String configJSON = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"Product1\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"OP111111\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          }'+
        '        ],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 2,'+
        '        \"productInspectMessageKeys\": ['+
        '          {'+
        '            \"MessageKey\": \"E11111\",'+
        '            \"SpaceSideNumber\": 1'+
        '          }'+
        '          ,{'+
        '            \"MessageKey\": \"E22222\",'+
        '            \"SpaceSideNumber\": 2'+
        '          }'+
        '        ],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }'; 
        VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(configJSON);
        System.assert(configObject != null);
    }
}