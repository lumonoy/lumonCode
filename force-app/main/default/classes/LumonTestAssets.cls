/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestAssets {
    public class CustomException extends Exception {}
    @TestVisible public static Id buildingAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Building').getRecordTypeId();
    @TestVisible public static Id unitAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Apartment').getRecordTypeId();
    @TestVisible public static Id planAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
    @TestVisible public static Id productAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
    @TestVisible public static List<Product2> mainProducts = LumonTestProducts.mainProducts;
    @TestVisible public static Account b2cAccount = LumonTestAccounts.b2cAccount;
    @TestVisible public static Account b2bAccount = LumonTestAccounts.b2bAccount;
    @TestVisible public static List<Asset> assets{
        get{
            return [SELECT Id,Name FROM Asset];
        }
    }

    @TestVisible public static List<Asset> buildingAssets{
        get{
            return [SELECT Id,Name FROM Asset WHERE recordType.DeveloperName = 'Building'];
        }
    }
    @TestVisible public static List<Asset> apartmentAssets{
        get{
            return [SELECT Id,Name FROM Asset WHERE recordType.DeveloperName = 'Apartment'];
        }
    }
    @TestVisible public static List<Asset> planAssets{
        get{
            return [SELECT Id,Name FROM Asset WHERE recordType.DeveloperName = 'Plan'];
        }
    }
    @TestVisible public static List<Asset> productAssets{
        get{
            return [SELECT Id,Name FROM Asset WHERE recordType.DeveloperName = 'Product'];
        }
    }
    /********** Asset Data Setup ***********/
    public static void setupBuildingAsset(){
        // Create Asset of Record Type Building
        System.debug('---- setupBuildingAsset - Building');
        Asset buildingAsset = new Asset( Name='Building Asset 1',
                                            RecordTypeId = buildingAssetRecordTypeId,
                                            //ContactId, 
                                            AccountId = b2cAccount.Id
                                            //ParentId, 
                                            //RootAssetId, 
                                            //Product2Id, ProductCode, ProductFamily, ProductDescription, IsCompetitorProduct, 
                                            //SerialNumber 
                                            //PurchaseDate,InstallDate, ManufactureDate, UsageEndDate
                                            //Status , StatusReason, 
                                            //Price, Quantity, Description, 
                                            //OwnerId, RecordTypeId, 
                                            //LocationId, 
                                            //AssetProvidedById, AssetServicedById, 
                                            //IsInternal, AssetLevel, 
                                            //Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                            //Assets_related_notes__c, Configuration_Product__c, Order__c, ServiceTerritory__c, Type__c, Asset_Warranty__c, Combination_name__c
                                            );
        insert buildingAsset;
        System.debug('---- setupBuildingAsset - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupBuildingAsset - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupApartmentAsset(){
       // Create Asset of Record Type Apartment
        System.debug('---- setupApartmentAsset - Apartment');
        Asset apartmentAsset = new Asset( Name='Apartment Asset 1-A',
                                            RecordTypeId = unitAssetRecordTypeId,
                                            //ContactId, 
                                            AccountId = b2cAccount.Id,
                                            ParentId = buildingAssets[0]?.Id
                                            //RootAssetId, 
                                            //Product2Id, ProductCode, ProductFamily, ProductDescription, IsCompetitorProduct, 
                                            //SerialNumber 
                                            //PurchaseDate,InstallDate, ManufactureDate, UsageEndDate
                                            //Status , StatusReason, 
                                            //Price, Quantity, Description, 
                                            //OwnerId, RecordTypeId, 
                                            //LocationId, 
                                            //AssetProvidedById, AssetServicedById, 
                                            //IsInternal, AssetLevel, 
                                            //Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                            //Assets_related_notes__c, Configuration_Product__c, Order__c, ServiceTerritory__c, Type__c, Asset_Warranty__c, Combination_name__c
                                            );
        insert apartmentAsset;
        System.debug('---- setupApartmentAsset - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupApartmentAsset - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupPlanAsset(){
        // Create Asset of Record Type Plan
        System.debug('---- setupPlanAsset - Plan');
        Asset planAsset = new Asset( Name='Plan Asset 1-A 1.1.1',
                                            RecordTypeId = planAssetRecordTypeId,
                                            //ContactId, 
                                            AccountId = b2cAccount.Id,
                                            ParentId = apartmentAssets[0]?.Id
                                            //RootAssetId, 
                                            //Product2Id, ProductCode, ProductFamily, ProductDescription, IsCompetitorProduct, 
                                            //SerialNumber 
                                            //PurchaseDate,InstallDate, ManufactureDate, UsageEndDate
                                            //Status , StatusReason, 
                                            //Price, Quantity, Description, 
                                            //OwnerId, RecordTypeId, 
                                            //LocationId, 
                                            //AssetProvidedById, AssetServicedById, 
                                            //IsInternal, AssetLevel, 
                                            //Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                            //Assets_related_notes__c, Configuration_Product__c, Order__c, ServiceTerritory__c, Type__c, Asset_Warranty__c, Combination_name__c
                                            );
        insert planAsset;
        System.debug('---- setupPlanAsset - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupPlanAsset - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupProductAssets(){
        List<Asset> productAssets = new List<Asset>();
        for (Product2 mainProduct : mainProducts) {
            // Create Asset of Record Type Product
            System.debug('---- setupProductAsset - Product');
            Asset productAsset = new Asset( Name='Product Asset 1-A 1.1.1 '+mainProduct.productGroup__c,
                                            RecordTypeId = productAssetRecordTypeId,
                                            //ContactId, 
                                            AccountId = b2cAccount.Id,
                                            ParentId = planAssets[0]?.Id,
                                            //RootAssetId, 
                                            Product2Id = mainProduct.Id
                                            //, ProductCode, ProductFamily, ProductDescription, IsCompetitorProduct, 
                                            //SerialNumber 
                                            //PurchaseDate,InstallDate, ManufactureDate, UsageEndDate
                                            //Status , StatusReason, 
                                            //Price, Quantity, Description, 
                                            //OwnerId, RecordTypeId, 
                                            //LocationId, 
                                            //AssetProvidedById, AssetServicedById, 
                                            //IsInternal, AssetLevel, 
                                            //Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                                            //Assets_related_notes__c, Configuration_Product__c, Order__c, ServiceTerritory__c, Type__c, Asset_Warranty__c, Combination_name__c
                                            );
            productAssets.add(productAsset);
        }
        if( productAssets.size()>0) {
            insert productAssets;
        }
        System.debug('--- Created '+productAssets.size()+ ' Product Assets');
        System.debug('---- setupProductAssets - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupProductAssets - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupAssetData(){ 
        if (mainProducts.size()>0) {
        } else {
            LumonTestProducts.setupProductData();
        }
        
        
        System.debug('--- LumonTestAssets- Inserting Assets');
        setupBuildingAsset();
        setupApartmentAsset();
        setupPlanAsset();
        setupProductAssets();
        System.debug('--- LumonTestAssets - Setup Assets CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestAssets - Setup Assets SOQL USED: ' + LIMITS.getQueries());
        System.debug('--- LumonTestAssets - Inserted '+assets.size()+' Assets'); 
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();
            LumonTestAccounts.setupAccountData();
        Test.stopTest();
    }
    @Istest
    public static void setupAssetDataTest(){
        String testResult;  
        Test.startTest();
        try {
            setupAssetData();
            testResult = ('Inserted '+assets?.size()+' Test Assets');
            System.assertNotEquals(0,assets?.size(), 'Expected Assets to be Created');
            
        } catch (exception e){
            testResult =('Error when inserting Assets: '+e.getMessage());
        }
        System.debug('--- LumonTestAssets - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestAssets - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestAssets - Test Result = '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}