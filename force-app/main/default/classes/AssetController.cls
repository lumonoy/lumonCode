/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class AssetController {
    /**** Methods for Finding Asset Entries ****/
    @AuraEnabled(cacheable=false)
    public static Asset getAsset(Id assetId) {
        // Populate List from SOQL query on Asset
        List<Id> assetIds = new List<Id>();
        assetIds.add(assetId);
        System.debug('--- AssetController - Get Asset with Id '+assetId); 
        List<Asset> assets =  getAssets(assetIds);  
        Asset asset = assets[0];
        System.debug('--- AssetController - Asset: '+asset.Name); 
        return asset;  
    }
    @AuraEnabled(cacheable=false)
    public static Asset getAssetByNumber(String assetNumber) {
        // Populate List from SOQL query on Asset
        Id assetId = [SELECT Id FROM Asset WHERE SerialNumber =: assetNumber LIMIT 1]?.Id; 
        List<Id> assetIds = new List<Id>();
        assetIds.add(assetId);
        Asset asset = new Asset();
        System.debug('--- AssetController - Get Customer with Id '+assetId); 
        List<Asset> assets =  getAssets(assetIds); 
        if  (assets?.size()>0) {
            asset = assets[0];
            System.debug('--- AssetController - Asset: '+asset.Name); 
        }        
        return asset;
    }
    @AuraEnabled(cacheable=false)
    public static List<Asset> getAssetsByAccount(Id accountId) {
        // Populate List from SOQL query on Asset
        List<Asset> customerAssets = new List<Asset>();
        customerAssets = getAssets(new List<Id> {accountId});
        return customerAssets;
    }
    @AuraEnabled(cacheable=false)
    public static List<Asset> getAssets(List<Id> recordIds) {
        // Populate List from SOQL query on Asset
        System.debug('--- AssetController - Get Assets'); 
        List<Asset> assets = ([  SELECT Id,Name, 
                                    OwnerId, LocationId, 
                                    ContactId, AccountId, 
                                    ParentId, RootAssetId, 
                                    Product2Id, ProductCode, 
                                    ProductFamily, ProductDescription, 
                                    IsCompetitorProduct,                                    
                                    CreatedDate, CreatedById, 
                                    LastModifiedDate, LastModifiedById, 
                                    SystemModstamp, IsDeleted, 
                                    CurrencyIsoCode, SerialNumber, 
                                    InstallDate, ManufactureDate, 
                                    PurchaseDate, UsageEndDate,
                                    Status, 
                                    StatusReason,                                     
                                    Uuid, ExternalIdentifier, 
                                    Price, Quantity, 
                                    Description, 
                                    AssetProvidedById, AssetServicedById, 
                                    IsInternal, AssetLevel, StockKeepingUnit, 
                                    Address,
                                    Street, City, State, PostalCode, 
                                    StateCode, Country, CountryCode, 
                                    Latitude, Longitude, GeocodeAccuracy 
                                    //Assets_related_notes__c, Configuration_Product__c, Order__c, ServiceTerritory__c, Type__c, Asset_Warranty__c, Combination_name__c          
                                    FROM Asset 
                                    WHERE Id IN: recordIds
                                    OR AccountId IN: recordIds
                                    OR ParentId IN: recordIds
                                    OR Product2Id IN: recordIds]);  
        System.debug('--- AssetController - Assets: '+assets.size()); 
        return assets;  
    }
}