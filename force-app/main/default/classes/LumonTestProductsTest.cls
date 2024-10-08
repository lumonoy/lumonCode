/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestProductsTest {
    @IsTest
    public static void setProductDataLG(){
        Test.startTest();
        LumonTestProducts.setupProducts('LG');
        Test.stopTest();
    }
}