/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestBasePrices {
    public static void setupBasePrices(){
        List<Base_Price__c> basePrices = new List<Base_Price__c>();
        Map<String,Map<String,List<String>>> productToItemMap = LumonTestVariables.productToItemMap;
        Integer i = 0;
        for (String productCode : productToItemMap.keySet() ) {
            Map<String,List<String>> costToItemMap = productToItemMap.get(productCode);           
            for (String costType : costToItemMap.keySet()) {     
                List<String> itemCodes = costToItemMap.get(costType);
                for (String itemCode : itemCodes) {  
                    i++;
                    Base_Price__c basePriceEntry = new Base_Price__c();
                    basePriceEntry.Name__c = productCode+'-'+costType+'-'+itemCode; 
                    basePriceEntry.Description__c = ''; 
                    basePriceEntry.Unit_Of_Measure__c = costType == 'askuormitu' ? 'h' :'pcs';
                    basePriceEntry.Base_Price__c = 10;
                    //basePriceEntry.Maintori_Id__c = itemCode; 
                    //basePriceEntry.isActive__c = true;
                    basePriceEntry.Product_Code__c = productCode;
                    basePriceEntry.Cost_Type__c =costType;
                    basePriceEntry.item_Code__c = itemCode;                 
                    basePriceEntry.Salestori_Id__c = i;
                    basePriceEntry.Minumum_Price__c = 0;  
                    basePriceEntry.Batch_Price__c = 0;                 
                    //basePriceEntry.Manual_Processing__c = false;
                    basePriceEntry.Delivery_Time__c = 1;
                    basePriceEntry.Cost_Multiplier__c = 0;
                    basePriceEntry.Commission__c = 100;                   
                    basePriceEntry.Volume_Discount__c = 0;
                    //basePriceEntry.Emphasis__c;
                    //basePriceEntry.Variant__c;                    
                    basePriceEntry.Site_Discount__c = 0;
                    basePrices.add(basePriceEntry);
                }
            }
        }
        insert basePrices;
    }
    public static void setupBasePriceData(){
        setupBasePrices();
        List<Base_Price__c> basePrices = LumonTestVariables.basePrices;
        System.debug('--- LumonTestBasePrices - Inserted '+basePrices.size()+' Base Prices'); 
    }  
    @TestSetup
    static void prepareData() {
        List<Product2> products = LumonTestVariables.products;
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestBasePrices - Using Existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupBasePriceDataTest(){
        String testResult;
        Test.startTest();
        Try {
            setupBasePriceData();
            testResult = 'successfully inserted Base Prices';
        } catch (exception e){
            testResult = 'Error when inserting Base Prices: '+e.getMessage();
        }
        Test.stopTest();
        List<Base_Price__c> basePrices = LumonTestVariables.basePrices;
        System.debug('--- LumonTestPriceMultipliers - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
        System.AssertNotEquals(0, basePrices.size(),'Expected Base Prices to be Inserted');
    }
}