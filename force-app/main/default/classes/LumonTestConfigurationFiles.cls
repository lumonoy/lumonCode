/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public with sharing class LumonTestConfigurationFiles {
    @TestVisible private static Id opportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @isTest
    public static void setupConfigFiles(){
        Id accountId = setupAccount();  
        Id opportunityId = setupOpportunity(accountId);
        Id configPlanId = setupConfigurationPlan(opportunityId);
        List<Id> productIds = setupProducts();
        List<Id> configProductIds = setupConfigurationProducts(configPlanId, productIds);
        List<Id> imageDocIds = setupVisualImageDocuments(configPlanId,configProductIds);
        List<Id> pricingDocIds = setupVisualPricingDocuments(configPlanId,configProductIds);
        List<Id> visualDocIds = setupContentFiles(configPlanId,configProductIds );
        }
    public static Id setupAccount(){
        // Create B2C Account
        String country ='Finland';
        String city='Vantaa';
        String postalCode = '01740';
        String street='Vanha Kalliosolantie 8';
        String district = 'FI_South';
        LumonTestAccounts.setupAccountB2C(country,city, postalCode, street,district, false);
     	Id accountId = [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        System.debug('--- setupAccount - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccount - Queries used: '+LIMITS.getQueries());
        return accountId;
    }
    public static Id setupOpportunity(Id accountId){
        // Create B2C Opportunity
        String org = 'LSU';
        String district = 'FI_South';
        String businessType = 'Consumer';
        LumonTestOpportunities.setupOpportunityB2C(accountId, org,district, businessType);
		Id oportunityId = [SELECT Id FROM Opportunity WHERE (AccountId =: accountId )]?.Id;
        System.debug('--- setupOpportunity - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunity - Queries used: '+LIMITS.getQueries());
        return oportunityId;
    }
    public static Id setupConfigurationPlan(Id opportunityId) {
        if (String.isBlank(opportunityId)){
            System.debug('No Parent Opportunity created');
        }
        // Create Parent Config B2C
        Configuration__c configPlan = new Configuration__c(
                                            Opportunity__c = opportunityId,
                                            Name='Configuration Plan 1',
                                            Plan_Apartment__c = 'C1',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = 'B2C-ABCDE1',//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '100',// public String line; //?
                                            Plan_Name__c = 'B2C Plan 1',// public String name; // Name of the Configuration
                                            //public List<Products> products; // Product Model aka Configurable Product
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version    
        insert configPlan;
        System.debug('--- setupConfigurationPlan - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationPlan - Queries used: '+LIMITS.getQueries());
        return configPlan.Id;
    }
    public static List<Id> setupProducts(){

        Product2 p1 = new Product2(Name='LG', IsActive=True,ProductCode='LG',Product_Group__c='LG',Product_Category__c='Product Groups');
        Product2 p2 = new Product2(Name='LGS', IsActive=True,ProductCode='LGS',Product_Group__c='LGS',Product_Category__c='Product Groups');
        Product2 p3 = new Product2(Name='VT3', IsActive=True,ProductCode='VT3',Product_Group__c='VT3',Product_Category__c='Product Groups');
        Product2 p4 = new Product2(Name='VT4', IsActive=True,ProductCode='VT4',Product_Group__c='VT4',Product_Category__c='Product Groups'); 
    	insert new List<Product2> {p1,p2,p3,p4};
        List<Product2> products = new List<Product2>([SELECT Product_Group__c,Id FROM Product2 WHERE Product_Category__c = 'Product Groups' AND IsActive  = TRUE ]);
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet());   
        return productIds;
    }
    public static List<Id> setupConfigurationProducts(Id configurationId, List<Id> productIds) {
        // Create Parent Config B2C
        Map<String,Product2> productGroupMap = new Map<String,Product2>();
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        List<Product2> products = new List<Product2>([SELECT Product_Group__c,Id FROM Product2 WHERE Product_Category__c = 'Product Groups' AND IsActive  = TRUE AND Id IN: productIds]);
        for (Integer i = 0; i<products.size();i++){
            Configuration_Product__c configProduct = new Configuration_Product__c(
                                        Name=products[i].Product_Group__c, //public String name; // Name of the Product Model
                                        Configuration__c = configurationId, // Parent Configuration
                                        Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                        Product_Group__c = products[i].product_Group__c,
                                        Product__c = products[i].Id,
                						Installer_Message__c = '<p>Testing</p>',
                                        Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                        Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                        Visual_Product_Id__c = products[i].Id,//public String Id; // Product Code of Product Model
                                        Inspection_Code__c = 2,//public Integer productInspectCode;
                                        Product_Length__c = 2.5 //public Double productLength;
                                        //RVN__c = RVN); // public String rvn; //ProjectNbr + Structure);
            );
            configProducts.add(configProduct);
        }
        upsert configProducts;
        System.debug('--- setupConfigurationProductsB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationProductsB2C - Queries used: '+LIMITS.getQueries());
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet());   
        return configProductIds;
    }
    public static List<Id> setupVisualImageDocuments(Id configurationId,List<Id> configProductIds) {
        List<ContentVersion> imageDocumentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> imageDocumentLinks = new List<ContentDocumentLink>();
        for (Integer i = 0; i<configProductIds.size();i++){
            System.debug('--- setupVisualImageDocument - Plan: '+configurationId);
            ContentVersion imageDocumentVersion = new ContentVersion();
            imageDocumentVersion.Title='Picture'+i;
            imageDocumentVersion.ContentLocation= 's';
            imageDocumentVersion.PathOnClient = imageDocumentVersion.Title + '.jpg';
            Blob imageBody=Blob.valueOf('----Visual Picture Document'+i);
            imageDocumentVersion.VersionData=imageBody;
            insert imageDocumentVersion;
            ContentVersion newDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageDocumentVersion.Id];
            // Create Content Document Version to Configuration
            ContentDocumentLink imageDocumentLink = new ContentDocumentLink();
            imageDocumentLink.ContentDocumentId = newDocumentVersion.ContentDocumentId;
            imageDocumentLink.ShareType = 'V';
            imageDocumentLink.LinkedEntityId = configurationId;
            insert imageDocumentLink;
            imageDocumentVersions.add(imageDocumentVersion);
            imageDocumentLinks.add(imageDocumentLink);
        }

        System.debug('--- setupVisualImageDocumentss - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupVisualImageDocument - Queries used: '+LIMITS.getQueries());
        List<Id> imageDocumentLinkIds = new List<Id>(new Map<Id, ContentDocumentLink>(imageDocumentLinks).keySet());  
        return imageDocumentLinkIds;
    }
    public static List<Id> setupVisualPricingDocuments(Id configurationId,List<Id> configProductIds) {
        List<ContentVersion> pricingDocumentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> pricingDocumentLinks = new List<ContentDocumentLink>();
        for (Integer i = 0; i<configProductIds.size();i++){
            ContentVersion pricingDocumentVersion = new ContentVersion();
            pricingDocumentVersion.Title='Visual Pricing'+i;
            pricingDocumentVersion.ContentLocation= 's';
            pricingDocumentVersion.PathOnClient = pricingDocumentVersion.Title + '.json';
            String ConfigString = '{'+
                            '    \"apartment\": \"A1\",'+
                            '    \"floor\": \"6\",'+
                            '    \"Id\": \"B2C-ABCDE1\",'+
                            '    \"line\": \"123\",'+
                            '    \"name\": \"Test Plan 1\",'+
                            '    \"version\": 2,'+
                            '    \"products\": ['+
                            '      {'+
                            '        \"Id\": \"visualProductId1\",'+
                            '        \"name\": \"COST\",'+
                            '        \"productLength\": 0.0,'+
                            '        \"priceParameters\": ['+
                            '          {'+
                            '            \"Amount\": 1.0,'+
                            '            \"LocalSupplier\": true,'+
                            '            \"ParameterCode\": \"\",'+
                            '            \"SalesCode\": \"Option 1\",'+
                            '            \"UniqueId\": 1,'+
                            '            \"Unit\": \"PCS\"'+
                            '          }'+
                            '        ],'+
                            '        \"rvn\": \"12345678\",'+
                            '        \"hasFeaturesBeenConfirmed\": true,'+
                            '        \"hasMeasurementsBeenVerified\": true,'+
                            '        \"productInspectCode\": 2,'+
                            '        \"productInspectMessageKeys\": ['+
                            '          {'+
                            '            \"MessageKey\": \"E11111\",'+
                            '            \"SpaceSideNumber\": 1'+
                            '          }'+
                            '        ],'+
                            '        \"reclaimedFeatureMessageKeys\": []'+
                            '      }'+
                            '    ]'+
                            '  }';
                            Blob bodyBlob=Blob.valueOf(ConfigString);
            pricingDocumentVersion.VersionData=bodyBlob;
            insert pricingDocumentVersion;
            ContentVersion newPricingDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingDocumentVersion.Id];
             
            // Link Content Document to Configuration
            ContentDocumentLink pricingDocumentLink = new ContentDocumentLink();
            pricingDocumentLink.ContentDocumentId = newPricingDocumentVersion.ContentDocumentId;
            pricingDocumentLink.ShareType = 'V';
            pricingDocumentLink.LinkedEntityId = configurationId;

            insert pricingDocumentLink;
            pricingDocumentVersions.add(pricingDocumentVersion);
            pricingDocumentLinks.add(pricingDocumentLink);
        }
        System.debug('--- setupVisualPricingDocuments - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupVisualPricingDocuments - Queries used: '+LIMITS.getQueries());
        List<Id> pricingDocumentLinkIds = new List<Id>(new Map<Id, ContentDocumentLink>(pricingDocumentLinks).keySet());  
        return pricingDocumentLinkIds;
    }
    public static List<Id> setupContentFiles(Id configurationId, List<Id> configProductIds){
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> contentLinks = new List<ContentDocumentLink>();
        List<Configuration_Product__c> configProducts = [SELECT Id,RVN__c,Product_Group__c,Configuration__c FROM Configuration_Product__c WHERE Configuration__c = :configurationId];
        
        for (configuration_Product__c configProduct : configProducts){
            String rvnNumber = configProduct.RVN__c;
            String productGroup = configProduct.Product_Group__c;
            //String json = '{\"country\":\"FI5\",\"product_type\":\"LGS\",\"terrain_class\":1,\"building_height\":90,\"reference_windspeed\":9,\"slope\":0,\"wind_pressure\":0.8,\"corner_coefficient\":0,\"structure\":0,\"product_openings\":1,\"report\":0,\"structure_number\":\"B2C-0-1\"}';
            String json = '{\"country\":\"FI5\",\"product_type\":';
            json += productGroup;
            json += ',\"terrain_class\":1,\"building_height\":90,\"reference_windspeed\":9,\"slope\":0,\"wind_pressure\":0.8,\"corner_coefficient\":0,\"structure\":0,\"product_openings\":1,\"report\":0,\"structure_number\":';
            json += rvnNumber;
            json += '}';
            String title = 'Visual_Structure_'+rvnNumber;
            String path = title+'.json';
            contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(json), 
                                                 Title = title, 
                                                 PathOnClient = path));
            String xml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
            xml += '<structural_version_number>';
            xml += rvnNumber;
            xml += '</structural_version_number>';
            xml += '<balconyglazing><product_name>';
            xml += productGroup;
            xml += '</product_name><weight><value>303.609344482422</value></weight></balconyglazing>';
            xml += '<area><value>321</value></area><blinds_area><value>11</value></blinds_area><glass_count><value>1</value></glass_count></products>';
            String xmlTitle = 'Visual_Plan_Statistics_'+productGroup+'_'+rvnNumber;
            String xmlPath = xmlTitle+'.xml';
            contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(xml), 
                                                    Title = xmlTitle, 
                                                    PathOnClient = xmlPath));

            String documentationXml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
            documentationXml += '<name>TESTVisualDocumentation</name>';
            documentationXml += '<space><corner_multiplier>No</corner_multiplier></space>';
            documentationXml += '<balconyglazing><product_code>';
            documentationXml += productGroup;
            documentationXml += '</product_code>';
            documentationXml += '<product_code_short>LFIXEDWALL</product_code_short><structural_version_number>';
            documentationXml += rvnNumber;
            documentationXml += '</structural_version_number>';
            documentationXml += '<unique_system_id>-Ei7ms2lCkKX-OgKYSUlhQ</unique_system_id><product_weight>303.609344482422</product_weight>';
            documentationXml += '<order_xml_info>&lt;rivipaino&gt;303.609344482422&lt;/rivipaino&gt;&lt;sivut&gt;&lt;sivu&gt;&lt;numero&gt;1&lt;/numero&gt;&lt;profiilivari-yla&gt;RAL9006&lt;/profiilivari-yla&gt;&lt;profiilivari-ala&gt;RAL9006&lt;/profiilivari-ala&gt;&lt;lasi-vahvuus&gt;8&lt;/lasi-vahvuus&gt;&lt;lasi-vari&gt;20090017&lt;/lasi-vari&gt;&lt;lasi-karkaisu&gt;1&lt;/lasi-karkaisu&gt;&lt;muovivari-yla&gt;Tummanharmaa&lt;/muovivari-yla&gt;&lt;muovivari-ala&gt;Tummanharmaa&lt;/muovivari-ala&gt;&lt;profiili-yla&gt;11222206&lt;/profiili-yla&gt;&lt;profiili-ala&gt;11243001&lt;/profiili-ala&gt;&lt;profiili-saato&gt;11241205&lt;/profiili-saato&gt;&lt;profiilipituus&gt;3000&lt;/profiilipituus&gt;&lt;lasitus-pituus&gt;3000&lt;/lasitus-pituus&gt;&lt;lasitus-korkeus&gt;2000&lt;/lasitus-korkeus&gt;&lt;lasivasen-kpl&gt;4&lt;/lasivasen-kpl&gt;&lt;lasioikea-kpl&gt;0&lt;/lasioikea-kpl&gt;&lt;kulmanylitys&gt;0&lt;/kulmanylitys&gt;&lt;sivun-paino&gt;220.997283935547&lt;/sivun-paino&gt;&lt;alkukulma&gt;90&lt;/alkukulma&gt;&lt;loppukulma&gt;90&lt;/loppukulma&gt;&lt;jarjestelmakulma&gt;&lt;/jarjestelmakulma&gt;&lt;/sivu&gt;&lt;/sivut&gt;</order_xml_info>';
            documentationXml += '</balconyglazing></products>';
            String docTitle = 'Visual_Documentation_'+productGroup+'_'+rvnNumber;
            String docPath = docTitle+'.xml';
            contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(documentationXml), 
                                                    Title = docTitle, 
                                                    PathOnClient = docPath));
            System.debug('*** documentationXml ***'+documentationXml);
            String outputXml = '<?xml version="1.0" encoding="utf-16"?><configuration><PAATASO><REKLAMAATIO>0</REKLAMAATIO>';
            outputXml += '<RAKENNENUMERO>#ORDER_NO#12345678</RAKENNENUMERO><ERIKOISTILAUS>0</ERIKOISTILAUS></PAATASO></configuration>';
            contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(outputXml), Title = 'Visual Output_'+configProduct.RVN__c, PathOnClient = 'VisualOutput_12345678.xml'));
        }
        insert contentVersions;
        for (ContentVersion contentVersion : contentVersions) {
            ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId, LinkedEntityId = configurationId);
            contentLinks.add(cdl);
        }
        insert contentLinks;
        System.debug('--- setupContentFiles - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupContentFiles - Queries used: '+LIMITS.getQueries());
        List<Id> contentLinkIds = new List<Id>(new Map<Id, ContentDocumentLink>(contentLinks).keySet());   
        
        return contentLinkIds;
    }

}