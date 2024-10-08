/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-04-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class AssetControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    @IsTest
    static void getAssetTest(){          
        Id assetId = [SELECT Id FROM Asset LIMIT 1]?.Id;
        Test.startTest();
        Asset assetRecord = AssetController.getAsset(assetId);
        System.Debug ('--- '+ assetRecord.Id +' Asset Returned');
        System.assertNotEquals(null,assetRecord, 'Expected Asset Record to be returned');
        System.debug('--- getAssetRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAssetRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAssetsTest(){
        Opportunity opp = OpportunityController.getOpportunityRecord(b2copportunityId);     
        Id assetId = [SELECT Id FROM Asset LIMIT 1]?.Id;
        Test.startTest();
        List<Id> assetIds = new List<Id> {assetId};
        List<Asset> assets = AssetController.getAssets(assetIds);
        System.Debug ('--- '+ assets.size() +' Assets Returned');
        System.assertNotEquals(0,assets.size(), 'Expected Asset Record to be returned');
        System.debug('--- getAssetsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAssetsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}