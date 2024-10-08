/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class PriceListControllerTest {
    @TestSetup
    static void prepareData() {
        List<Product2> products = LumonTestVariables.products;
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- PriceListControllerTest - Using Existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        LumonTestBasePrices.setupBasePriceData();
        Test.stopTest();
    }
    @IsTest
    static void  getBasePriceToItemMapTest() {
        test.startTest();
        String errorMessage;
        try {
            Map<String,Base_Price__c> basePriceToItemMap = PriceListController.getBasePriceToItemMap();
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- No Pricebook Returned');
        }
        System.assertEquals(null,errorMessage, 'Expected basePrice to be Returned');
        System.debug('--- PriceListControllerTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PriceListControllerTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}