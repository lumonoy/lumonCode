/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestPriceMultipliers {
    public static void setupFactoryMultipliers() {    
        List<String> organizations = LumonTestVariables.organizations;
        List<String> countryCodes = LumonTestVariables.countries;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> districts = LumonTestVariables.districts;
        List<String> productGroups= LumonTestVariables.productGroups;
        List<String> costTypes = LumonTestVariables.costTypes;
        List<Factory_Price__c> fps = new List<Factory_Price__c>();  
        for (String org : organizations) {
            for (String businessType : businessTypes) {
                for (String country : countryCodes) {  
                    List<Factory_Price__c> countryFactoryMultipliers= new List<Factory_Price__c>();                  
                    for (String pg : productGroups) {
                        List<Factory_Price__c> groupFactoryMultipliers= new List<Factory_Price__c>();
                        for (String  ct: costTypes) {
                            Factory_Price__c fp = new Factory_Price__c();
                            fp.Organization__c = org;
                            fp.Country__c = country;
                            fp.Business_Type__c = businessType;
                            fp.Product_Group__c = pg;
                            fp.Cost_Type__c = ct;
                            fp.Factory_Multiplier__c = 10.0;
                            fp.IsActive__c  = true;
                            //fps.add(fp);
                            groupFactoryMultipliers.add(fp);
                            countryFactoryMultipliers.add(fp);
                        }  
                    }    
                    insert countryFactoryMultipliers;            
                }
            }
        }
        List<Factory_Price__c> factoryPrices = LumonTestVariables.factoryPrices;
        System.debug('--- LumonTestPriceMultipliers - Factory Multipliers: '+factoryPrices);
    }
    public static void setupCostMultipliers() {
        List<Product_Cost__c> pcs = new List<Product_Cost__c>();
        List<String> organizations = LumonTestVariables.organizations;
        List<String> countryCodes = LumonTestVariables.countries;
        List<String> businessTypes = LumonTestVariables.businessTypes;
        List<String> districts = LumonTestVariables.districts;
        List<String> productGroups= LumonTestVariables.productGroups;
        List<String> costTypes = LumonTestVariables.costTypes;
        for (String org : organizations) {
            for (String businessType : businessTypes) {
                for (String country : countryCodes) {
                    for( String district : districts) { 
                        List<Product_Cost__c> districtCostMultipliers= new List<Product_Cost__c>();                      
                        for (String pg : productGroups) {
                            List<Product_Cost__c> groupCostMultipliers= new List<Product_Cost__c>();
                            for (String  ct: costTypes) {
                                Product_Cost__c pc = new Product_Cost__c();
                                pc.Organization__c = org;
                                pc.Country__c = country;
                                pc.Business_Type__c = businessType;
                                pc.District__c = district;
                                pc.Product_Group__c = pg;
                                pc.Cost_Type__c = ct;
                                pc.Cost_Multiplier__c = 20.0;
                                pc.IsActive__c  = true;
                                groupCostMultipliers.add(pc);
                                districtCostMultipliers.add(pc);
                                //pcs.add(pc);
                            }                          
                        }   
                        insert districtCostMultipliers;                     
                    }
                }
            }
        }
        List<Product_Cost__c> productCosts = LumonTestVariables.productCosts;
        System.debug('--- LumonTestPriceMultipliers - Cost Multipliers: '+productCosts);
    }
    public static void setupPriceMultipliers() {       
        //String profit = '4043 LSU Oulu';
        List<String> organizations = LumonTestVariables.organizations;
        List<String> countryCodes = LumonTestVariables.countries;
        List<String> businessTypes = LumonTestVariables.businessTypes;

        List<String> districts = LumonTestVariables.districts;
        List<String> profitCenters = LumonTestVariables.profitCenters;
        List<String> productGroups = LumonTestVariables.productGroups;
        List<String> costTypes = LumonTestVariables.costTypes;
        List<Sales_Price__c> sps = new List<Sales_Price__c>();
        for (String org : organizations) {
            for (String businessType : businessTypes) {
                for (String country : countryCodes) {
                    for( String district : districts) {
                        setupPriceMultipliers(org,country,businessType,district);
                    }
                }
            }
        }
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.debug('--- LumonTestPriceMultipliers -  Price Multipliers: '+salesPrices);
    }
    public static void setupPriceMultipliers(String org, String country, String businessType, String district) {       
        //String profit = '4043 LSU Oulu';
        List<String> organizations = LumonTestVariables.organizations;
        List<String> countryCodes = LumonTestVariables.countries;
        List<String> businessTypes = LumonTestVariables.businessTypes;

        List<String> districts = LumonTestVariables.districts;
        List<String> profitCenters = LumonTestVariables.profitCenters;
        List<String> productGroups = LumonTestVariables.productGroups;
        List<String> costTypes = LumonTestVariables.costTypes;
        List<Sales_Price__c> priceMultipliers = new List<Sales_Price__c>();
        for (String profitCenter : profitCenters) {                         
            for (String pg : productGroups) {
                for (String  ct: costTypes) {
                    Sales_Price__c sp = new Sales_Price__c();
                    sp.Organization__c = org;
                    sp.Country__c = country;
                    sp.Business_Type__c = businessType;
                    sp.District__c = district;
                    //sp.Profit_Center__c = profit;
                    sp.Product_Group__c = pg;
                    sp.Cost_Type__c = ct;
                    sp.Sales_Multiplier__c = 30.0;
                    sp.IsActive__c  = true;
                    //sps.add(sp);
                    priceMultipliers.add(sp);   
                }
            } 
        }
        if (priceMultipliers.size()>0){
        	insert priceMultipliers;
        }
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.debug('--- LumonTestPriceMultipliers -  Price Multipliers: '+salesPrices);
    }
    public static void setupPriceMultiplierData(){
        setupFactoryMultipliers();
        setupCostMultipliers();
        setupPriceMultipliers();
        List<Factory_Price__c> factoryPrices = LumonTestVariables.factoryPrices;
        List<Product_Cost__c> productCosts = LumonTestVariables.productCosts;
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.debug('--- LumonTestPriceMultipliers - Inserted '+factoryPrices.size()+' Factory Multipliers'); 
        System.debug('--- LumonTestPriceMultipliers - Inserted '+productCosts.size()+' Cost Multipliers'); 
        System.debug('--- LumonTestPriceMultipliers - Inserted '+salesPrices.size()+' Price Multipliers'); 
    }  
    @TestSetup
    static void prepareData() {
        List<Product2> products = LumonTestVariables.products;
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestPriceMultipliers - Using Existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupPriceMultipliersDataTest(){
        String testResult;
        Test.startTest();
        Try {
            setupPriceMultiplierData();
            testResult = 'successfully inserted Price Multipliers';
        } catch (exception e){
            testResult = 'error when inserting Price Multipliers: '+e.getMessage();
        }
        Test.stopTest();
        List<Factory_Price__c> factoryPrices = LumonTestVariables.factoryPrices;
        List<Product_Cost__c> productCosts = LumonTestVariables.productCosts;
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.debug('--- LumonTestPriceMultipliers - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
        System.AssertNotEquals(0, factoryPrices.size(),'Expected Factory Prices to be Inserted');
        System.AssertNotEquals(0, productCosts.size(),'Expected Prodyct Costs to be Inserted');
        System.AssertNotEquals(0, salesPrices.size(),'Expected Sales Prices to be Inserted');
    }
    @IsTest
    static void setupFactoryPricesTest(){
        String testResult;
        Test.startTest();
        Try {
            setupFactoryMultipliers();
            testResult = 'successfully inserted Price Multipliers';
        } catch (exception e){
            testResult = 'error when inserting Price Multipliers: '+e.getMessage();
        }
        Test.stopTest();
        List<Factory_Price__c> factoryPrices = LumonTestVariables.factoryPrices;
        System.debug('--- LumonTestPriceMultipliers - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
        System.AssertNotEquals(0, factoryPrices.size(),'Expected Factory Prices to be Inserted');
    }
    @IsTest
    static void setupProductCostsTest(){
        String testResult;
        Test.startTest();
        Try {
            setupCostMultipliers();
            testResult = 'successfully inserted Price Multipliers';
        } catch (exception e){
            testResult = 'error when inserting Price Multipliers: '+e.getMessage();
        }
        Test.stopTest();
        List<Product_Cost__c> productCosts = LumonTestVariables.productCosts;
        System.debug('--- LumonTestPriceMultipliers - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
        System.AssertNotEquals(0, productCosts.size(),'Expected Prodyct Costs to be Inserted');
    }
    @IsTest
    static void setupSalesPricesTest(){
        String testResult;
        Test.startTest();
        Try {
            setupPriceMultipliers();
            testResult = 'successfully inserted Price Multipliers';
        } catch (exception e){
            testResult = 'error when inserting Price Multipliers: '+e.getMessage();
        }
        Test.stopTest();
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.debug('--- LumonTestPriceMultipliers - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
        System.AssertNotEquals(0, salesPrices.size(),'Expected Sales Prices to be Inserted');
    }

}