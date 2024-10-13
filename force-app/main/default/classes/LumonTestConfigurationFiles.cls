/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public with sharing class LumonTestConfigurationFiles {
    public class CustomException extends Exception {}
    @Testvisible private static List<Id> configPlanIds = LumonTestConfigurationPlans.configPlanIds;
    @Testvisible private static List<Id> configProductIds = LumonTestConfigurationProducts.configProductIds;
    @Testvisible private static String configJSON = LumonTestData.visualPricing;
    @Testvisible private static List<ContentVersion> imageDocumentVersions {
        get { 
            return [SELECT Id, ContentDocumentId, Title, FileType FROM ContentVersion WHERE Title = 'Picture' AND FileType = 'jpg'];
        }
    }
    @Testvisible private static List<ContentVersion> pricingDocumentVersions {
        get {
                return [SELECT Id, ContentDocumentId, Title, FileType FROM ContentVersion WHERE Title LIKE 'Pricing%' AND FileType = 'json'];
        }
    } 
    @Testvisible private static List<Id> imageDocumentVersionIds {
        get { 
                return new List<Id>(new Map<Id, ContentVersion>(imageDocumentVersions).keySet());  
        }
    }
    @Testvisible private static List<Id> pricingDocumentVersionIds {
        get {
            return new List<Id>(new Map<Id, ContentVersion>(pricingDocumentVersions).keySet());
        }
    }
    @Testvisible private static ContentDocumentLink imageDocumentLinks {
        get { 
            return [SELECT Id, ContentDocumentId,LinkedEntityId, ShareType  
                    FROM ContentDocumentLink 
                    WHERE ContentDocumentId IN: imageDocumentVersionIds];
        }
    }
    @Testvisible private static ContentDocumentLink pricingDocumentLinks {
        get {
                return [SELECT Id, ContentDocumentId,LinkedEntityId, ShareType 
                        FROM ContentDocumentLink 
                        WHERE ContentDocumentId IN: imageDocumentVersionIds];
        }
    }          

    /**
    * @description Prepare a Picture file and link it to Configuration Plan and Product
    * @author Henk Reynders | 10-01-2024 
    * @param configurationId 
    * @param configProductIds 
    * @return
    **/
    public static void setupImageDocuments() {
        List<ContentDocumentLink> imageDocumentLinksToInsert = new List<ContentDocumentLink>();
        for (Id configProductId : configProductIds){
            System.debug('--- LumonTestConfigurationFiles - setupImageDocument - Plan: '+configPlanIds[0]);
            // Prepare the Content Version
            ContentVersion imageDocumentVersion = new ContentVersion();
            imageDocumentVersion.Title='Picture_'+configProductId;
            imageDocumentVersion.ContentLocation= 's';
            imageDocumentVersion.PathOnClient = imageDocumentVersion.Title + '.jpg';
            Blob imageBody=Blob.valueOf('Picture File for Configuration Product '+configProductId);
            imageDocumentVersion.VersionData=imageBody;
            insert imageDocumentVersion;

            // Create Content Document Link to Configuration Plan
            ContentDocumentLink imagePlanLink = new ContentDocumentLink();
            imagePlanLink.ContentDocumentId = imageDocumentVersion.ContentDocumentId;
            imagePlanLink.ShareType = 'V';
            imagePlanLink.LinkedEntityId = configPlanIds[0];
            imageDocumentLinksToInsert.add(imagePlanLink);

            // Create Content Document Link to Configuration Product
            ContentDocumentLink imageProductLink = new ContentDocumentLink();
            imageProductLink.ContentDocumentId = imageDocumentVersion.ContentDocumentId;
            imageProductLink.ShareType = 'V';
            imageProductLink.LinkedEntityId = configProductId;           
            imageDocumentLinksToInsert.add(imageProductLink);
        }
        if (imageDocumentLinksToInsert.size()>0) {
            insert imageDocumentLinksToInsert;
        }
        System.debug('--- LumonTestConfigurationFiles - setupImageDocument - Created '+imageDocumentLinksToInsert.size()+ ' Image Documents');
        System.debug('--- LumonTestConfigurationFiles - setupImageDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationFiles - setupImageDocument - SOQL USED: ' + LIMITS.getQueries());
    }
    /**
    * @description Prepare a Pricing file and link it to Configuration Plan
    * @author Henk Reynders | 10-01-2024 
    * @param configurationId 
    * @param configProductIds 
    * @return 
    **/
    public static void setupPricingDocuments() {
        List<ContentDocumentLink> pricingDocumentLinksToInsert = new List<ContentDocumentLink>();
        for (Id configPlanId : configPlanIds){
            ContentVersion pricingDocumentVersion = new ContentVersion();
            pricingDocumentVersion.Title='Pricing_' +configPlanId;
            pricingDocumentVersion.ContentLocation= 's';
            pricingDocumentVersion.PathOnClient = pricingDocumentVersion.Title + '.json';       
            Blob bodyBlob=Blob.valueOf(configJSON);
            pricingDocumentVersion.VersionData=bodyBlob;
            insert pricingDocumentVersion;
             
            // Link Content Document to Configuration
            ContentDocumentLink pricingDocumentLink = new ContentDocumentLink();
            pricingDocumentLink.ContentDocumentId = pricingDocumentVersion.ContentDocumentId;
            pricingDocumentLink.ShareType = 'V';
            pricingDocumentLink.LinkedEntityId = configPlanId;
            insert pricingDocumentLink;
            pricingDocumentLinksToInsert.add(pricingDocumentLink);
        }
        if (pricingDocumentLinksToInsert.size()>0) {
            insert pricingDocumentLinksToInsert;
        }
        System.debug('--- LumonTestConfigurationFiles - setupPricingDocuments - Created '+pricingDocumentLinksToInsert.size()+ ' Pricing Documents');
        System.debug('--- LumonTestConfigurationFiles - setupPricingDocuments - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationFiles - setupPricingDocuments - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationFileData() {
        try {      
            if (configPlanIds.size()>0){
                LumonTestConfigurationPlans.setupConfigurationPlanData();
            } 
            if (configProductIds.size()>0){
                LumonTestConfigurationProducts.setupConfigurationProductData();
            }
            setupImageDocuments();
            setupPricingDocuments();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationFiles - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {      
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationFileDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationFileData();
            testResult = 'successfully inserted Configuration Files';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Files: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationFiles - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationFiles - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}