/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-16-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class CountryMappingControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        
        Test.stopTest();
    }   
    @IsTest
    static void getCountryMappingByAlpha2Test(){
        Test.startTest();
        String searchString = 'FI';
        Country_Mapping__mdt countryMapping = CountryMappingController.getCountryMappingByAlpha2(searchString);
        System.Debug ('--- getCountryMappingByAlpha2Test - Country Mapping: '+ countryMapping);
        System.assertNotEquals(null,countryMapping, 'Expected One  Country Mapping to be returned');
        System.debug('--- getCountryMappingByAlpha2Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getCountryMappingByAlpha2Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCountryMappingByAlpha3Test(){
        Test.startTest();
        String searchString = 'FIN';
        Country_Mapping__mdt countryMapping = CountryMappingController.getCountryMappingByAlpha3(searchString);
        System.Debug ('--- getCountryMappingByAlpha3Test - Country Mapping: '+ countryMapping);
        System.assertNotEquals(null,countryMapping, 'Expected One  Country Mapping to be returned');
        System.debug('--- getCountryMappingByAlpha3Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getCountryMappingByAlpha3Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCountryMappingByCodeTest(){
        Test.startTest();
        String searchString = '358';
        Country_Mapping__mdt countryMapping = CountryMappingController.getCountryMappingByCode(searchString);
        System.Debug ('--- getCountryMappingByCodeTest - Country Mapping: '+ countryMapping);
        System.assertNotEquals(null,countryMapping, 'Expected One  Country Mapping to be returned');
        System.debug('--- getCountryMappingByCodeTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getCountryMappingByCodeTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getCountryMappingByNameTest(){
        Test.startTest();
        String searchString = 'Finland';
        Country_Mapping__mdt countryMapping = CountryMappingController.getCountryMappingByName(searchString);
        System.Debug ('--- getCountryMappingByNameTest - Country Mapping: '+ countryMapping);
        System.assertNotEquals(null,countryMapping, 'Expected One  Country Mapping to be returned');
        System.debug('--- getCountryMappingByNameTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getCountryMappingByNameTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}