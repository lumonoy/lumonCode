/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DynamicListViewControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        Test.stopTest();
    }
    private static String objectType = 'Account';
    @IsTest
    static void getlistViewTest(){  
        Test.startTest();
        List<ListView> objectListViews = DynamicListViewController.getlistView(objectType);
        System.Debug ('--- DynamicListViewControllerTest - getlistViewTest '+ objectListViews.size() +' Views Returned');
        System.assertNotEquals(0,objectListViews.size(), 'Expected ListViews to be returned');
        System.debug('--- DynamicListViewControllerTest - getlistViewTest CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- DynamicListViewControllerTest - getlistViewTest SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getListViewDataTest(){  
        Test.startTest();
        List<DynamicListViewController.ListViewData> objectListViewsData = DynamicListViewController.getListViewData(objectType);
        System.Debug ('--- DynamicListViewControllerTest -getListViewDataTest '+ objectListViewsData.size() +' View Data Returned');
        System.assertNotEquals(0,objectListViewsData.size(), 'Expected ListView Data to be returned');
        System.debug('--- DynamicListViewControllerTest - getListViewDataTest CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- DynamicListViewControllerTest - getListViewDataTest SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}