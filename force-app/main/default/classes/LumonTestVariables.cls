/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-18-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestVariables {
    @TestVisible private static Id CS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CS_Case').getRecordTypeId();
    @TestVisible private static Id TS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TS_Case').getRecordTypeId();
    @TestVisible private static Id SF_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Case').getRecordTypeId();
    @TestVisible private static Id FAC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FAC_Case').getRecordTypeId();
    @TestVisible private static Id INST_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('INST_Case').getRecordTypeId();
    @TestVisible private static Id RECL_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RECL_Case').getRecordTypeId();
    @TestVisible private static Id SPEC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SPEC_Case').getRecordTypeId();
    @TestVisible private static Id PERM_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PERM_Case').getRecordTypeId();
    @TestVisible private static Id LOG_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LOG_Case').getRecordTypeId();
    @TestVisible private static Id WEB_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB_Case').getRecordTypeId();

    /********** User Data Records ***********/
    @TestVisible private static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
        }
    }
    @TestVisible private static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='admin.testuser@email123.com')];
        }
    }
    @TestVisible private static User salesUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='sales.testuser@email123.com')];
        }
    }
    @TestVisible private static User salesManagerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='salesmgr.testuser@email123.com')];
        }
    }
    @TestVisible private static User installerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installer.testuser@email123.com')];
        }
    }
    @TestVisible private static User installationManagerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installmgr.testuser@email123.com')];
        }
    }
    @TestVisible private static User technicalSupportUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='techsupport.testuser@email123.com')];
        }
    }
    @TestVisible private static User customerServiceUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='customerService.testuser@email123.com')];
        }
    }
    @TestVisible private static User marketingUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='marketing.testuser@email123.com')];
        }
    }
    @TestVisible private static Role_Settings__c roleSettings {
        get { 
            return  Role_Settings__c.getInstance();
        }
    }
    @TestVisible private static Boolean isAdmin {
        get { 
            return roleSettings.isAdmin__c;
        }
    }
    /********** User Data Setup ***********/
    @TestVisible private static List<String> businessTypes {
        get {
            return  New List<String>{'Consumer','Project','Reseller'};//,'Reseller'};
        }
    }
    @TestVisible private static List<String> countries {
        get {
            return New List<String>{'FI'};//,,'ES''SE','CA'};
        }
    }
    @TestVisible private static List<String> organizations {
        get {
            return New List<String>{'LSU'};//'LU','LCE',
        }
    }
    @TestVisible private static List<String> districts {
        get {
            return New List<String>{'FI_South'};//,'FI_North','FI_West','FI_East'};
            //'ES_Andalucia','ES_Aragon','ES_Canarias','ES_Cataluna','ES_Levante','ES_Madrid','ES_Mallorca'

        }
    }
    @TestVisible private static List<String> profitCenters {
        get {
            return New List<String>{'4010 LSU Vantaa West','4011 LSU Vantaa East','401 LSU Vantaa Project',
                                    // ,'4012 LSU Espoo','4013 LSU Helsinki'
                                    //'4022 LSU Lahti','402 LSU Kouvola','4031 LSU Tampere',
                                    //'4032 LSU Turku','4033 LSU Vaasa','4041 LSU Jyväskylä','4042 LSU Kuopio','4043 LSU Oulu',
                                    '4044 LSU Reseller'};
            //'100 LUI Administration','10 SVI Production','110 LNA Administration','15 SVI Production Aftersales',
            //'160 LNP Production','161 LNP Administration',
            //'172 LNC Vancouver','173 LNC West dealers','174 LNC Toronto','175 LNC Dealers','176 LNC Hamilton','177 LNC US','178 LNC Customer service',
            //'181 LNU US Dealers','182 LNU Buffalo',
            //'20 SVI Consumer','25 SVI Consumer West','30 SVI B2B Finland','40 SVI Webshop','50 SVI B2B Export','90 SVI Administration',
            //'200 LUI International','210 LUI Kouvola','220 LUI Jyväskylä','230 LUI Oulu','240 LUI Vantaa','250 LUI Kuopio','274 LUI Kouvola',
            //'280 LFE Production','290 LFE Administration',
            //'310 LU Glass processing','320 LU Glazing','322 LU Balustrade','324 LU Roofs','325 LU Production administration','328 LU Marketing','329 LU R&D','330 LU Logistics','331 LU Sourcing','350 LU HR','390 LU Customer service','398 LU IT','399 LU Finance',
            //'4010 LSU Vantaa West','4011 LSU Vantaa East','4012 LSU Espoo','4013 LSU Helsinki','401 LSU Vantaa Project','4022 LSU Lahti','402 LSU Kouvola','4031 LSU Tampere',
            //'4032 LSU Turku','4033 LSU Vaasa','4041 LSU Jyväskylä','4042 LSU Kuopio','4043 LSU Oulu',
            //'4044 LSU Reseller','405 LSU Sales center','406 LSU Industrial sales','409 LSU Administration',
            //'410 SLU Stockholm','411 SLU Göteborg','412 SLU Malmö','413 SLU Västerås','420 SLU Reseller','430 SLU North Sweden','440 SLU Aftersales','450 SLU Administration',
            //'510 LCE Malaga','511 LCE Almeria','512 LCE Marbella','520 LCE Barcelona','530 LCE Zaragoza','540 LCE Valencia','550 LCE Madrid Sur','551 LCE Madrid Norte',
            //'560 LCE Reseller','570 LCE Aftersales','590 LCE Administration',
            //'601 INT Spain','602 INT Sweden','603 INT Germany','604 INT Austria','605 INT Denmark','606 INT Netherlands','607 INT France','608 INT Ireland',
            //'609 INT Belgium','60 SVI Industrial Sales','610 INT Latvia','611 INT Slovakia','612 INT Great Britain','650 INT Canada','651 INT Other licence',
            //'652 INT Russia','655 INT Norway','656 INT Czech Republic','659 INT Poland','660 INT Iceland','662 INT Lebanon','663 INT Switzerland',
            //'664 INT Egypt','667 INT Chile','668 INT Middle East','697 INT Latin America','698 INT Other reseller','699 INT Administration',
            //'710 LNO Oslo','720 LNO Reseller','730 LNO Drammen','740 LNO Aftersales','750 LNO Administration',
            //'810 LDE Administration','820 LDE Reseller','830 LDE Project','870 LSW Consumer',
            //'910 ZAO Reseller','920 ZAO St Petersburg','950 LDA Reseller','997 LFR Reseller'
        }
    }

    @TestVisible private static List<String> planTypes {
        get {
            return New List<String>{'Visual','Sovelia','Services','Sales','Supplies'}; // Not using Blinds or Extra Sales
        }
    }
    @TestVisible private static Product_Settings__c productSettings {
        get { 
            return Product_Settings__c.getInstance();
        }
    }
    @TestVisible private static List<String> visualProductGroups {
        get { 
            return productSettings.Visual_Products__c.split(';');
        }
    }
    @TestVisible private static List<String> soveliaProductGroups {
        get { 
            return productSettings.Sovelia_Products__c.split(';');
        }
    }
    @TestVisible private static List<String> servicesProducts {
        get { 
            return productSettings.Service_Product_Group__c.split(';');
        }
    }
    @TestVisible private static List<String> extraSalesProducts {
        get { 
            return productSettings.Extra_Sales_Product__c.split(';');
        }
    }
    @TestVisible private static List<String> otherProducts {
        get { 
            return productSettings.Other_Products__c.split(';');
        }
    }
    @TestVisible private static List<String> sparepartsProducts {
        get { 
            return productSettings.Spare_Part_Product_Group__c.split(';');
        }
    }
    @TestVisible private static List<String> productGroups {
        get { 
            List<String> productGroups = new List<String>();
            Set<String> productGroupKeys = new Set<String>();
            productGroupKeys.addAll(visualProductGroups);
            productGroupKeys.addAll(soveliaProductGroups);
            productGroupKeys.addAll(servicesProducts);
            productGroupKeys.addAll(extraSalesProducts);
            productGroupKeys.addAll(otherProducts);
            productGroupKeys.addAll(sparepartsProducts);
            productGroups.addAll(productGroupKeys);
            return productGroups;
        }
    } 
    @TestVisible private static List<Product2> mainProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True];
        }
    } 
    @TestVisible private static List<Product2> soveliaProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Sovelia'];
        }
    } 
    @TestVisible private static List<Product2> visualProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Visualovelia'];
        }
    }
    @TestVisible private static List<Product2> retractableProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LG'];
        }
    } 
    @TestVisible private static List<Product2> slidingProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LGS'];
        }
    } 
    @TestVisible private static List<Product2> fixedWallProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LFIXEDWALL'];
        }
    } 
    @TestVisible private static List<Product2> balustradeProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LUMONKAIDE'];
        }
    }  
    @TestVisible private static List<Product2> terraceProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c IN ('VT3','VT4')];
        }
    }   
    @TestVisible private static List<Product2> blindsProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'VISORBLINDSALES'];
        }
    }  
    @TestVisible private static Map<String,Id> mainProductMap {
        get {
            Map<String,Id> mainProductCodeToIdMap = new Map<String,Id>();
            for (Product2 mainProduct : mainProducts) {
                mainProductCodeToIdMap.put(mainProduct.Product_Group__c, mainProduct.Id);
            }
            return mainProductCodeToIdMap;
        }
    }
    @TestVisible private static List<Id> mainProductIds {
        get{
            return new List<Id>(new Map<Id, Product2>(mainProducts).keySet()); 
        }
    } 
    @TestVisible private static List<Product2> configurableProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = False AND Cost_Type__c IN ('tuotteet','verhot')];
            
        }
    } 
    @TestVisible private static List<Id> configurableProductIds {
        get{
            return new List<Id>(new Map<Id, Product2>(configurableProducts).keySet()); 
        }
    } 
    @TestVisible private static List<Id> installationProductIds {
        get{
            List<Product2> products = [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = False AND Cost_Type__c IN ('askuormitu')];
            return new List<Id>(new Map<Id, Product2>(products).keySet()); 
        }
    } 
    @TestVisible private static List<Product2> products {
        get {
            return [SELECT  name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive,QuantityUnitOfMeasure FROM Product2];
        }
    } 
    @TestVisible private static List<Id> productIds {
        get {
            return new List<Id>(new Map<Id, Product2>(products).keySet());
        }
    } 
    @TestVisible private static List<String> costTypes {
        get {
            List<String> costTypes = new List<String>();
            costTypes.add('alihankint');
            costTypes.add('as.tarvike');
            costTypes.add('asennus');
            costTypes.add('asennus1');
            costTypes.add('asennus2');
            costTypes.add('asennus3');
            costTypes.add('askuormitu');
            costTypes.add('costreserv');
            costTypes.add('kulukorv.');
            costTypes.add('lupahakem.');
            costTypes.add('myynti fi');
            costTypes.add('nostokulut');
            costTypes.add('nostvuokra');
            costTypes.add('perustus');
            costTypes.add('rahti');
            costTypes.add('rahti1');
            costTypes.add('rahti2');
            costTypes.add('rahti3');
            costTypes.add('tuotekust.');
            costTypes.add('tuotteet');
            costTypes.add('ulk.as.pal');
            costTypes.add('vakuutus');
            costTypes.add('verhot');
            return costTypes;
        }
    }
    @TestVisible private static List<Factory_Price__c> factoryPrices{
        get{
            return [SELECT Id, Name,  
                            Organization__c, Country__c, 
                            Business_Type__c,
                            Factory_Multiplier__c, 
                            IsActive__c, 
                            Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c  
                    FROM Factory_Price__c ];
        }
    }
    @TestVisible private static List<Product_Cost__c> productCosts{
        get{
            return [SELECT Id, Name,  
                            Organization__c, Country__c, 
                            Business_Type__c,District__c,
                            Cost_Multiplier__c, 
                            IsActive__c, 
                            Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c                            
                    FROM Product_Cost__c ];
        }
    }
    @TestVisible private static List<Sales_Price__c> salesPrices{
        get{
            return [SELECT Id, Name,   
                            Organization__c, Country__c, 
                            Business_Type__c,District__c,
                            Profit_Center__c,BusinessId__c,
                            Sales_Multiplier__c, 
                            IsActive__c, 
                            Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c  
                    FROM Sales_Price__c ];
        }
    }
    @TestVisible private static Map<String,List<String>> productGroupMap {
        get{
            List<String> productGroups = new List<String>();
            List<String> costTypes = new List<String>();
            Map<String,List<String>> productGroupMap = new Map<String,List<String>>();
            List<AggregateResult> aggrGroupCosttype = [SELECT Count(Id) productCount, Product_Group__c productGroup,Cost_Type__c costType FROM Product2
                                                    GROUP BY Product_Group__c, Cost_Type__c];
            if(aggrGroupCosttype != null && aggrGroupCosttype.size() > 0){ 
                for(AggregateResult agr : aggrGroupCosttype){
                    String productGroup = (STRING) agr.get('productGroup');
                    String costType = (STRING) agr.get('costType');
                    //System.debug('--- productGroup: '+productGroup);
                    //System.debug('--- costType: '+costType);
                    if (!productGroups.contains(productGroup)) {
                        productGroups.add(productGroup);
                    }
                    if (!costTypes.contains(costType)) {
                        costTypes.add(costType);  
                    }
                    if (!productGroupMap.containsKey(productGroup)){
                        productGroupMap.put(productGroup,new List<String>());
                    } else {
                        List<String> groupCostTypes = productGroupMap.get(productGroup);
                        groupCostTypes.add(costType);
                        productGroupMap.put(productGroup,groupCostTypes);
                    }                
                }
            }
            return productGroupMap;
        }
    }   
    @TestVisible private static Map<String,Map<String,List<String>>> productToItemMap {
        get{
            Map<String,Map<String,List<String>>> productToItemMap = new Map<String,Map<String,List<String>>>();
            Set<String> uniqueSalesCodes = new Set<String>();
            List<String> salesCodes = new List<String>();
            List<AggregateResult> aggrSalesCodes = [SELECT Count(Id) productCount, Product_Group__c productCode,Cost_Type__c costType, Sales_Code__c itemCode FROM Product2
                                                    GROUP BY Product_Group__c,Cost_Type__c, Sales_Code__c];
            if(aggrSalesCodes != null && aggrSalesCodes.size() > 0){ 
                for(AggregateResult agr : aggrSalesCodes){                   
                    String productCode = (STRING) agr.get('productCode');
                    String costType = (STRING) agr.get('productCode');
                    String itemCode = (STRING) agr.get('itemCode');                   
                    if (!productToItemMap.containsKey(productCode)) {
                        productToItemMap.put(productCode,new Map<String,List<String>>());
                    }
                    Map<String,List<String>> costToItemMap = productToItemMap.get(productCode);
                    if (!costToItemMap.containsKey(costType)) {
                        costToItemMap.put(costType,new List<String>());
                    }
                    List<String> items = costToItemMap.get(costType);
                    items.add(itemCode);
                    costToItemMap.put(productCode,items);
                    productToItemMap.put(productCode,costToItemMap);
                }                
            }
            return productToItemMap;
        }
    }   
    @TestVisible private static List<Base_Price__c> basePrices{
        get{
            return [SELECT Id, Product_Code__c, Cost_Type__c, Item_Code__c,  Base_Price__c, IsActive__c FROM Base_Price__c];
        }
    }
    @TestVisible private static List<Installation_Time__c> installationTimes{
        get{
            return [SELECT Id,Product__c, Hours__c,Minutes__c,IsActive__c FROM Installation_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible private static List<Production_Time__c> productionTimes{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible private static List<Production_Time__c> productionDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Days__c > 0];
        }
    }
    @TestVisible private static List<Production_Time__c> extraDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Extra_Days__c > 0];
        }
    }
    @TestVisible private static Id b2cLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company = null)]?.Id;
        }
    }
    @TestVisible private static Id b2bLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company != null)]?.Id;
        }
    }
    @TestVisible private static List<Lead> leads{
        get{
            return [SELECT Id, Finland_Sync_to_MC__c, Other_Countries_Sync_to_MC__c, Spain_Sync_to_MC__c, 
                            Email_Opt_In__c, Email_Opt_In_Date_Time__c, SMS_Opt_In__c, SMS_Opt_In_Date_Time__c, 
                            HasOptedOutOfEmail,
                            ConvertedContactId, ConvertedAccountId,ConvertedOpportunityId,
                            ConvertedAccount.Finland_Sync_to_MC__pc,  ConvertedAccount.Spain_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc, 
                            ConvertedAccount.Finland_Sync_to_MC__c,  ConvertedAccount.Spain_Sync_to_MC__c, ConvertedAccount.Other_Countries_Sync_to_MC__c, 
                            ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Spain_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c, 
                            ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Spain_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c, 
                            ConvertedDate
                    FROM Lead];
        }
    }
    @TestVisible private static List<Id> leadIds {
        get{
            return new List<Id>(new Map<Id, Lead>(leads).keySet()); 
        }
    } 
    @TestVisible private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    @TestVisible private static Id b2cRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = true) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible private static Id b2bRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = false) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible private static Id b2cLeadRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE Name Like 'B2C Lead%' AND (SobjectType='Lead')]?.Id;
        }
    }
    @TestVisible private static Id b2bLeadRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE Name Like 'B2B Lead%' AND (SobjectType='Lead')]?.Id;
        }
    }
    @TestVisible private static Id b2cOpportunityRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE Name Like 'B2C%' AND (SobjectType='Opportunity')]?.Id;
        }
    }
    @TestVisible private static Id b2bOpportunityRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE Name Like 'B2B%' AND (SobjectType='Opportunity')]?.Id;
        }
    }
    @TestVisible private static Id reclamationCaseRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (SobjectType='Case')]?.Id;
        }
    }
    @TestVisible private static List<Account> accounts{
        get{
            return [SELECT Id, IsPersonAccount, Business_Type__c, PersonMailingAddress, PersonOtherAddress,BillingAddress, ShippingAddress FROM Account ];
        }
    }
    @TestVisible private static Id b2cAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Account b2cAccount{
        get{
            return [SELECT Id,Name,Business_Type__c, 
                            BillingCountry, ShippingCountry,
                            BillingCity, ShippingCity, 
                            BillingPostalCode, ShippingPostalCode, 
                            BillingStreet, ShippingStreet  
                    FROM Account WHERE (IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = false)]?.Id;
        }
    }
    @TestVisible private static Account b2bAccount{
        get{
            return [SELECT Id,Name,Business_Type__c, 
                            BillingCountry, ShippingCountry,
                            BillingCity, ShippingCity, 
                            BillingPostalCode, ShippingPostalCode, 
                            BillingStreet, ShippingStreet  
                    FROM Account WHERE (IsPersonAccount = false)];
        }
    }
    @TestVisible private static List<Contact> contacts{
        get{
            return [SELECT Id, AccountId, IsPersonAccount, LastName, FirstName, Salutation, Name, 
                    OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherAddress, 
                    MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingAddress, 
                    Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department FROM Contact ];
        }
    }
    @TestVisible private static List<Contact> b2cContacts{
        get{
            return [SELECT Id, AccountId, IsPersonAccount, LastName, FirstName, Salutation, Name, 
                    OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherAddress, 
                    MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingAddress, 
                    Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department FROM Contact WHERE isPersonAccount = true];
        }
    }
    @TestVisible private static List<Contact> b2bContacts{
        get{
            return [SELECT Id, AccountId, IsPersonAccount, LastName, FirstName, Salutation, Name, 
                    OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherStateCode, OtherCountryCode, OtherAddress, 
                    MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStateCode, MailingCountryCode, MailingAddress, 
                    Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department FROM Contact WHERE isPersonAccount = false];
        }
    }
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible private static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive,Product2.ProductCode, Product2.Product_Group__c, Product2.Sales_Code__c FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }
    @TestVisible private static List<Opportunity> opportunities{
        get{
            return [SELECT Id,Name, Business_Type__c, StageName,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Order_Type__c = 'Normal')];
        }
    }    
    @TestVisible private static List<Id> opportunityIds {
        get{
            return new List<Id>(new Map<Id, Opportunity>(opportunities).keySet()); 
        }
    } 
    @TestVisible private static List<OpportunityLineItem> opportunityProducts{
        get{
            return [SELECT Id, OpportunityId, SortOrder, PricebookEntryId, Product2Id, ProductCode, Name, 
                            CurrencyIsoCode, Quantity, TotalPrice, UnitPrice, ListPrice, ServiceDate, Description 
                    FROM OpportunityLineItem];
        }
    }    
    @TestVisible private static List<Id> opportunityProductsIds {
        get{
            return new List<Id>(new Map<Id, OpportunityLineItem>(opportunityProducts).keySet()); 
        }
    }
    @TestVisible private static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2cOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Id =: b2cOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static List<Opportunity> b2cOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Account.IsPersonAccount = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2bOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Id =: b2bOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static List<Opportunity> b2bOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false)];
        }
    }
    @TestVisible private static List<Quote> quotes{
        get{
            return [SELECT Id,Name,Pricebook2Id,opportunityId,AccountId FROM Quote];
        }
    }    
    @TestVisible private static List<Id> quoteIds{
        get{
            return new List<Id>(new Map<Id, Quote>(quotes).keySet()); 
        }
    }  
    @TestVisible private static Id b2cQuoteId{
        get{
            return [SELECT Id,Pricebook2Id, isSyncing, OpportunityId  FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static String b2cQuoteNumber{
        get{
            return [SELECT Id,Pricebook2Id, isSyncing, OpportunityId,QuoteNumber  FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.QuoteNumber;
        }
    }
    @TestVisible private static String b2bQuoteNumber{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId,QuoteNumber FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.QuoteNumber;
        }
    }
    @TestVisible private static Id b2cSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (OpportunityId =: b2cOpportunityId AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE ( OpportunityId =: b2bOpportunityId  AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }  
    @TestVisible private static List<Case> cases{
        get{
            return [SELECT Id,RecordTypeId FROM Case];
        }
    }    
    @TestVisible private static List<Id> caseIds {
        get{
            return new List<Id>(new Map<Id, Case>(cases).keySet()); 
        }
    } 
    @TestVisible private static List<Opportunity> reclamations{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE Order_Type__c = 'Reclamation'];
        }
    }
    @TestVisible private static Id b2cReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2cReclamation{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2cReclamationId ) LIMIT 1];
        }
    }
    @TestVisible private static Id b2bReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Account.IsPersonAccount = false AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Configuration__c> configPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c ];
        }
    } 
    @TestVisible private static List<Configuration__c> visualConfigPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c  WHERE Plan_Type__c = 'Visual'];
        }
    } 
    @TestVisible private static List<Configuration__c> soveliaConfigPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c  WHERE Plan_Type__c = 'Sovelia'];
        }
    } 
    @TestVisible private static List<Id> configPlanIds {
        get{
            return new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        }
    } 
    @TestVisible private static List<Configuration_Product__c> configProducts {
        get{
            return [ SELECT Id,Name, Configuration__c, Product__c,RVN_Number__c,RVN__c,Quantity__c, Product__r.QuantityUnitOfMeasure, Product__r.Sales_Code__c FROM Configuration_Product__c];
        }
    } 
    @TestVisible private static List<Id> configProductIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet()); 
        }
    } 
    @TestVisible private static List<Configuration_Option__c> configOptions {
        get{
            return [ SELECT Id,Name, Configuration_Product__c, Product__c,RVN_Number__c,RVN__c,Quantity__c, Product__r.QuantityUnitOfMeasure, Product__r.Sales_Code__c FROM Configuration_Option__c];
        }
    } 
    @TestVisible private static List<Id> configOptionIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Option__c>(configOptions).keySet()); 
        }
    }
    @TestVisible private static Configuration__c b2cConfiguration{
        get{
            return ConfigurationPlanController.getConfigurationPlan(b2cConfigurationPlanId);
        }
    }
    @TestVisible private static List<Configuration__c> b2cConfigurations{
        get{
            return ConfigurationPlanController.getConfigurationPlans(new List<Id>{b2cOpportunityId});
        }
    }
    @TestVisible private static List<Configuration_Product__c> b2cConfigProducts{
        get{
            return [SELECT  Id,
                            Name,
                            Quantity__c,
                            Product_Group__c,
                            Product_Model__c,
                            Sales_Code__c,
                            Product__c,
                            Configuration__c,
                            RVN_Number__c,
                            RVN__c,
                            Visual_Structure_Number__c,
                            Sovelia_Structure_Number__c,
                            Product__r.Product_Group__c,
                            Visual_Product_Id__c,
                            Sovelia_Product_Id__c
                    FROM Configuration_Product__c WHERE (Configuration__c in :b2cConfigurations)];
        }
    }
    @TestVisible private static List<Configuration_Option__c> b2cConfigOptions{
        get{
            return [SELECT  Id,
                            Name,
                            Line_Number__c,
                            Quantity__c,
                            Product__c,
                            Product__r.Product_Group__c,
                            Product__r.Cost_Category__c,
                            Product__r.Cost_Type__c,
                            Product__r.Product_Category__c,
                            Product__r.Product_Type__c,
                            Product__r.Product_Item__c,
                            Product__r.ProductCode,
                            Product__r.Sales_Code__c,
                            Product_Code__c,
                            Product_Group__c,
                            Product_Model__c,
                            Configuration_Plan__c,
                            Configuration_Product__c,
                            Configuration_Product__r.Configuration__c,
                            RVN_Number__c
                    FROM Configuration_Option__c WHERE (Configuration_Product__c IN :b2cConfigProducts)];
        }
    }
    @TestVisible private static List<Configuration_Message__c> b2cConfigMessages{
        get{
            return [SELECT Id FROM Configuration_Message__c WHERE (Configuration_Product__c IN :b2cConfigProducts)];
        }
    }
    @TestVisible private static Id b2cConfigurationPlanId{
        get{
            return [SELECT Id,Opportunity__c FROM Configuration__c WHERE Opportunity__c =:b2cOpportunityId LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<ContentDocumentLink> b2cConfigurationFiles{
        get{
            return [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId];
        }
    }
    @TestVisible private static List<Factory__c> factories{
        get{
            return [SELECT Id FROM Factory__c];
        }
    }
    @TestVisible private static List<Id> factoryIds{
        get{
            return new List<Id>(new Map<Id, Factory__c>(factories).keySet()); 
        }
    }   
    @TestVisible private static List<Warehouse__c> warehouses{
        get{
            return [SELECT Id FROM Warehouse__c];
        }
    }
    @TestVisible private static List<Id> warehouseIds{
        get{
            return new List<Id>(new Map<Id, Warehouse__c>(warehouses).keySet()); 
        }
    }
    @TestVisible private static List<Building__c> buildings{
        get{
            return [SELECT Id FROM Building__c];
        }
    }
    @TestVisible private static List<Id> buildingIds{
        get{
            return new List<Id>(new Map<Id, Building__c>(buildings).keySet()); 
        }
    }
    @TestVisible private static List<Schema.Location> locations{
        get{
            return [SELECT Id, LocationType, 
                    Latitude, Longitude, Location, Description, DrivingDirections, TimeZone, 
                    ParentLocationId, PossessionDate, ConstructionStartDate, ConstructionEndDate, 
                    OpenDate, CloseDate, RemodelStartDate, RemodelEndDate, IsMobile, IsInventoryLocation, 
                    VisitorAddressId, RootLocationId, LocationLevel, ExternalReference, ShouldSyncWithOci, LogoId 
                    FROM Location];
        }
    }
    @TestVisible private static List<QuoteLineItem> quoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice,Product2.ProductCode, Product2.Product_Group__c, Product2.Sales_Code__c FROM QuoteLineItem];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2cQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2cSyncedQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cSyncedQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2bQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2bSyncedQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bSyncedQuoteId];
        }
    }
    @TestVisible private static List<Pricing_Summary__c> pricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c];
        }
    }
    @TestVisible private static List<OperatingHours> operatingHours{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours];
        }
    } 
    @TestVisible private static Id availabilityHoursId{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours WHERE Name LIKE '%Availability Calenda%' LIMIT 1]?.Id;
        }
    } 
    @TestVisible private static Id workingHoursId{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours WHERE Name LIKE '%Time Slots Calendar%' LIMIT 1]?.Id;
        }
    } 
    @TestVisible private static List<ServiceTerritory> serviceTerritories{
        get{
            return [SELECT Id,  Name, CurrencyIsoCode,  ParentTerritoryId, TopLevelTerritoryId, Description, OperatingHoursId, 
                        Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                        IsActive, TypicalInTerritoryTravelTime, SchedulingConstraintId, TravelModeId, 
                        FSL__Hide_Emergency_Map__c, FSL__Internal_SLR_Geolocation__Latitude__s, FSL__Internal_SLR_Geolocation__Longitude__s, 
                        FSL__Internal_SLR_Geolocation__c, FSL__NumberOfServicesToDripFeed__c, FSL__O2_Enabled__c, FSL__Service_Cluster_Min_Size__c, 
                        FSL__Service_Cluster_Proximity__c, FSL__System_Jobs__c, FSL__TerritoryLevel__c, Parent_Name__c, Appointment_Booking_Offset__c, 
                        LUM_Dispatching_Offset__c, Scheduling_Calendar__c, Parents_Parent_Name__c, Related_Case_Queue_name__c
                        FROM ServiceTerritory];
        }
    }
    @TestVisible private static List<ServiceTerritoryMember> serviceTerritoryMembers{
        get{
            return [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, 
                        EffectiveStartDate, EffectiveEndDate, 
                        Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                        OperatingHoursId, TravelModeId, FSL__Internal_SLR_HomeAddress_Geolocation__Latitude__s, 
                        FSL__Internal_SLR_HomeAddress_Geolocation__Longitude__s, FSL__Internal_SLR_HomeAddress_Geolocation__c, 
                        Resource_Name__c FROM ServiceTerritoryMember];
        }
    }   
    @TestVisible private static List<TimeSlot> timeSlots{
        get{
            return [SELECT Id,Type,DayOfWeek,StartTime,EndTime FROM TimeSlot];
        }
    } 
    @TestVisible private static List<ServiceResource> serviceResources{
        get{
            return [SELECT Id,Name, ServiceCrewId,ResourceType,FSL__GanttLabel__c,RelatedRecordId FROM ServiceResource];
        }
    }       
    @TestVisible private static FSL__Scheduling_Policy__c schedulingPolicy{
        get{
            return  [SELECT Id,Name FROM FSL__Scheduling_Policy__c LIMIT 1];
        }
    }
    @TestVisible private static List<WorkOrder> workOrders{
        get{
            return  [SELECT Id,Subject, WorkOrderNumber,AccountId,ContactId,CaseId,EntitlementId,ServiceContractId,AssetId,RootWorkOrderId,WorkTypeId,ServiceTerritoryId,StatusCategory,Opportunity__c FROM WorkOrder];
        }
    }
    @TestVisible private static List<ServiceAppointment> serviceAppointments{
        get{
            return [SELECT Id,Status,EarliestStartTime,DueDate ,ServiceTerritoryId,ParentRecordId FROM ServiceAppointment];
        }
    }
    @TestVisible private static List<Configuration_Message__c> configMessages{
        get{
            return [SELECT Id FROM Configuration_Message__c WHERE (Configuration_Product__c IN :configProducts)];
        }
    }
    @TestVisible private static List<Pricing_Summary__c> b2cPricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c WHERE(Opportunity__c = :b2cOpportunityId)];
        }
    }
    @TestVisible private static List<Contract> contracts{
        get{
            return [SELECT Id,Pricebook2Id, AccountId, Opportunity__c,Quote__c  FROM Contract];
        }
    }
    @TestVisible private static List<Id> contractIds {
        get{
            return new List<Id>(new Map<Id, Contract>(contracts).keySet()); 
        }
    }
    @TestVisible private static List<ContentDocumentLink> contractMessages {
        get {
            return [SELECT Id, ContentDocument.Title, ContentDocumentId, ContentDocument.FileType 
                    FROM ContentDocumentLink WHERE Id IN: contractIds];
        }
    }
    @TestVisible private static List<Order> orders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order];
        }
    }
    @TestVisible private static List<Id> orderIds {
        get{
            return new List<Id>(new Map<Id, Order>(orders).keySet()); 
        }
    }
    @TestVisible private static List<Order> b2cOrders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId)];
        }
    }
    @TestVisible private static Id normalCaseId{
        get{
            return [SELECT Id FROM Case WHERE Type = 'Normal']?.Id;
        }
    }
    @TestVisible private static Id specialOrderCaseId{
        get{
                return [SELECT Id FROM Case WHERE Type = 'Special Order']?.Id;
            }
    }
    @TestVisible private static Id reclamationCaseId{
        get{
            return [SELECT Id FROM Case WHERE Type = 'Reclamation']?.Id;
        }
    }
    @TestVisible private String visualPricingJSON{
        get {
            return string.valueOf([SELECT Visual_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'visual' LIMIT 1]);
        }
    }
    @TestVisible private String soveliaPricingJSON{
        get {
            return string.valueOf([SELECT Sovelia_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'sovelia' LIMIT 1]);
        }
    }
    @TestVisible private static String testPricingJSON {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();}
    }
    @TestVisible private static String roboPricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Visual_Pricing_Robo_99' ].Body.toString();}
    }
    @TestVisible private static String retractablePricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'RetractablePricing' ].Body.toString();}
    }
    @TestVisible private static String soveliaPricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Sovelia_Pricing' ].Body.toString();}
    }
    @TestVisible private static String soveliaReport {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Sovelia_Report' ].Body.toString();}
    }
}