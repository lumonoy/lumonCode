/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-20-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class ConfigurationDataControllerTest { 
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupProducts();
        LumonTestProducts.setupProducts('LG');
        //LumonTestProducts.setupProducts('LGS');
        //LumonTestProducts.setupProducts('LFIXEDWALL');
        LumonTestProducts.setupProducts('VT3');
        //LumonTestProducts.setupProducts('VT4');    
        //LumonTestProducts.setupProducts('VISORBLINDSALES');
        LumonTestProducts.setupSoveliaProducts();
        //LumonTestProducts.setupRetractableProducts();
        LumonTestPricebooks.setupPricebookEntries();
        LumonTestPriceParameters.setupPriceParameters();
        LumonTestInstallationTimes.setupInstallationTimes();
        LumonTestProductionTimes.setupProductionTimes();
        LumonTestConfigurations.setupConfigurationData();
        // B2C Setup
        /*LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();*/
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    
    @IsTest
    static void getVisualPricingFilesTest(){
        Test.startTest();
        Id  configurationId =  [SELECT Id FROM Configuration__c WHERE opportunity__c =: b2cOpportunityId]?.Id;
        System.debug('--- getVisualPricingFilesTest - configurationId: '+configurationId); 
        
        Map<ID, String> pricingFileMap = ConfigurationDataController.getVisualPricingFiles(b2cOpportunityId);
        System.debug('--- getVisualPricingFilesTest - pricingFileMap: '+pricingFileMap); 
        System.assertNotEquals(null, pricingFileMap, 'Expecting atleast 1 File to be returned');
        System.debug('--- getVisualPricingFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualPricingFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

    @IsTest
    static void loadVisualPricingFileTest(){
        Id configurationId =  [SELECT Id FROM Configuration__c WHERE opportunity__c =: b2cOpportunityId]?.Id;
        Id pricingDocId =  [SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE linkedEntityId =: configurationId AND ContentDocument.Title Like '%Pricing%']?.ContentDocumentId;
        String result;
        System.debug('--- getVisualPricingFilesTest - configurationId: '+configurationId); 
        Test.startTest();
        try {
            ConfigurationDataController.loadVisualPricingFile(pricingDocId,b2cOpportunityId, 'Opportunity', configurationId);
        } catch (exception e) {
            result = e.getMessage();
        }
        System.assertEquals(null, result, 'Expecting File to be Loaded to be returned');
        System.debug('--- loadVisualPricingFileTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- loadVisualPricingFileTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    
    @isTest
    static void loadBlindsReportsFileTest(){
        Id configurationId =  [SELECT Id FROM Configuration__c WHERE opportunity__c =: b2cOpportunityId]?.Id;
        
        Id pricingDocId =  [SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE linkedEntityId =: configurationId AND ContentDocument.Title Like '%Report%']?.ContentDocumentId;
        String result;
        
        List<Configuration_Product__c> cpList = new List<Configuration_Product__c>();
        Configuration_Product__c cp = new Configuration_Product__c();
        cp.Name='VISORBLINDSALES'; //public String name; // Name of the Product Model
        cp.Configuration__c = configurationId; // Parent Configuration
        cp.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
        cp.Sovelia_Structure_Number__c = '60001678';
        cp.Features_Confirmed__c = False;//public Boolean hasFeaturesBeenConfirmed;
        cp.Measurements_Verified__c = False;// public Boolean hasMeasurementsBeenVerified;                                       
        cp.Inspection_Code__c = 2;//public Integer productInspectCode;
        insert cp;
        cpList.add(cp);
        
        String blindsTitle = 'Blinds_Report_60001678';
         ContentVersion blindsStructureFile = new ContentVersion(
            Title = blindsTitle,
            PathOnClient = blindsTitle + '.json',
            VersionData = Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'Sovelia_Report'].Body.toString())
        );
        insert blindsStructureFile;
        insert new List<ContentDocumentLink> {
            new ContentDocumentLink(
                ShareType = 'V',
                LinkedEntityId = cp.Configuration__c,
                ContentDocumentId = [
                    SELECT ContentDocumentId FROM ContentVersion WHERE Id = :blindsStructureFile.Id LIMIT 1
                ].ContentDocumentId
            )
        };
        
        Test.startTest();
        try {
            ConfigurationDataController.populateAdditionalProductParameters(cpList);
        } catch (exception e) {
            result = e.getMessage();
        }
		Test.stopTest();
        
    }

    @IsTest
    static void populateConfigurationAttributesTest() {
        List<Configuration_Product__c> configurationProducts = [
            SELECT Id, Configuration__c, Configuration__r.Visual_Structure_Number__c
            FROM Configuration_Product__c WHERE Configuration__r.Opportunity__c = :b2cOpportunityId
        ];

        Configuration_Product__c configurationProduct = configurationProducts.get(0);
        System.debug('--- populateConfigurationAttributesTest - configurationProduct: '+configurationProduct);

        Test.startTest(); 
        ConfigurationDataController.populateAdditionalProductParameters(b2cOpportunityId);
        System.debug('--- populateConfigurationAttributesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- populateConfigurationAttributesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        
        List<Configuration_Attribute__c> attributes = [
            SELECT Id, Glass_Thickness__c FROM Configuration_Attribute__c
        ];
        System.debug('--- populateConfigurationAttributesTest -attributes: '+attributes); 
        Assert.isFalse(attributes.isEmpty(), 'Attributes should have been created');
    }
    /*@IsTest
    static void populateFromStructureFile() {
        List<Configuration_Product__c> configurationProducts = [
            SELECT Id, Configuration__c, Configuration__r.Visual_Structure_Number__c
            FROM Configuration_Product__c WHERE Configuration__r.Opportunity__c = :b2cOpportunityId
        ];
        Configuration_Product__c configurationProduct = configurationProducts.get(0);
        String documentationTitle = 'Visual_Documentation.xml';
        String visualStructureNumber = configurationProduct.Configuration__r.Visual_Structure_Number__c;
        String structureTitle = 'Visual_Structure_' + visualStructureNumber;
        ContentVersion visualStructureFile = new ContentVersion(
            Title = structureTitle,
            PathOnClient = structureTitle + '.json',
            VersionData = Blob.valueOf([SELECT Body FROM StaticResource WHERE Name = 'retractableStructure'].Body.toString())
        );
        insert visualStructureFile;
        insert new List<ContentDocumentLink> {
            new ContentDocumentLink(
                ShareType = 'V',
                LinkedEntityId = configurationProducts.get(0).Configuration__c,
                ContentDocumentId = [
                    SELECT ContentDocumentId FROM ContentVersion WHERE Id = :visualStructureFile.Id LIMIT 1
                ].ContentDocumentId
            )
        };

        Test.startTest(); 
        ConfigurationDataController.populateAdditionalProductParameters(b2cOpportunityId);
        System.debug('--- populateFromStructureFile - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- populateFromStructureFile - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        List<Configuration_Attribute__c> attributes = [
            SELECT Id, Glass_Thickness__c FROM Configuration_Attribute__c
        ];
        Assert.isFalse(attributes.isEmpty(), 'Attributes should have been created');
    }*/

}