/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-04-2024
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
                    basePriceEntry.UnitOfMeasure__c = costType == 'askuormitu' ? 'h' :'pcs';
                    basePriceEntry.BasePrice__c = 10;
                    //basePriceEntry.MaintoriId__c = itemCode; 
                    //basePriceEntry.isActive__c = true;
                    basePriceEntry.ProductCode__c = productCode;
                    basePriceEntry.CostType__c =costType;
                    basePriceEntry.itemCode__c = itemCode;                 
                    basePriceEntry.SalestoriId__c = i;
                    basePriceEntry.MinumumPrice__c = 0;  
                    basePriceEntry.BatchPrice__c = 0;                 
                    //basePriceEntry.ManualProcessing__c = false;
                    basePriceEntry.DeliveryTime__c = 1;
                    basePriceEntry.CostMultiplier__c = 0;
                    basePriceEntry.Commission__c = 100;                   
                    basePriceEntry.VolumeDiscount__c = 0;
                    //basePriceEntry.Emphasis__c;
                    //basePriceEntry.Variant__c;                    
                    basePriceEntry.SiteDiscount__c = 0;
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