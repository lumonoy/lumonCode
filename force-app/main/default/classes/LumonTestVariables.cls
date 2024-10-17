/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-04-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestVariables {
    @TestVisible public static Boolean isPersonAccountEnabled = Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
    /********** RecordTypes ***********/
    @TestVisible public static Id CS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CS_Case').getRecordTypeId();
    @TestVisible public static Id TS_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('TS_Case').getRecordTypeId();
    @TestVisible public static Id SF_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Case').getRecordTypeId();
    @TestVisible public static Id FAC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FAC_Case').getRecordTypeId();
    @TestVisible public static Id INST_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('INST_Case').getRecordTypeId();
    @TestVisible public static Id RECL_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RECL_Case').getRecordTypeId();
    @TestVisible public static Id SPEC_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SPEC_Case').getRecordTypeId();
    @TestVisible public static Id PERM_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PERM_Case').getRecordTypeId();
    @TestVisible public static Id LOG_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LOG_Case').getRecordTypeId();
    @TestVisible public static Id WEB_CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB_Case').getRecordTypeId();

    @TestVisible public static Id b2cLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('B2C_Lead').getRecordTypeId();
    @TestVisible public static Id b2bLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('B2B_Lead').getRecordTypeId();
    @TestVisible public static Id resLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('B2B_Reseller').getRecordTypeId();
    @TestVisible public static Id b2cAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    @TestVisible public static Id b2bAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    @TestVisible public static Id b2cOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
    @TestVisible public static Id b2bOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
    @TestVisible public static Id buildingAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Building').getRecordTypeId();
    @TestVisible public static Id unitAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Apartment').getRecordTypeId();
    @TestVisible public static Id planAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
    @TestVisible public static Id productAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();


    /********** User Objects ***********/
    @TestVisible public static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            UserName, UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User WHERE(username='admin.testuser@sandbox.com')];
        }
    }
    /********** User Object Records ***********/
    @TestVisible public static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
        }
    }

    @TestVisible public static User b2cSalesUser{
        get{
            return LumonTestUsers.b2cSalesUser;
        }
    }
    @TestVisible public static User b2bSalesUser{
        get{
            return LumonTestUsers.b2bSalesUser;
        }
    }
    @TestVisible public static User salesManagerUser{
        get{
            return  LumonTestUsers.salesManagerUser;
        }
    }
    @TestVisible public static User installerUser{
        get{
            return  LumonTestUsers.installerUser;
        }
    }
    @TestVisible public static User installationManagerUser{
        get{
            return  LumonTestUsers.installationManagerUser;
        }
    }
    @TestVisible public static User technicalSupportUser{
        get{
            return  LumonTestUsers.technicalSupportUser;
        }
    }
    @TestVisible public static User customerServiceUser{
        get{
            return  LumonTestUsers.customerServiceUser;
        }
    }
    @TestVisible public static User ictSupportUser{
        get{
            return  LumonTestUsers.ictSupportUser;
        }
    }
    @TestVisible public static User marketingUser{
        get{
            return  LumonTestUsers.marketingUser;
        }
    }

    /*********** Role Settings *************/
    @TestVisible public static Role_Settings__c roleSettings {
        get { 
            return  Role_Settings__c.getInstance();
        }
    }
    @TestVisible public static Boolean isAdmin {
        get { 
            return roleSettings.isAdmin__c;
        }
    }
    /********** Business Attributes Setup ***********/
    @TestVisible public static List<String> businessTypes = LumonTestData.businessTypes;
    @TestVisible public static List<String> countryCodes = LumonTestData.countryCodes;
    @TestVisible public static List<String> organizations = LumonTestData.organizations;
    @TestVisible public static List<String> districts = LumonTestData.districts;
    @TestVisible public static List<String> profitCenters = LumonTestData.profitCenters;

    /********* Product Settings *************/


    @TestVisible public static Product_Settings__c productSettings {
        get { 
            return Product_Settings__c.getInstance();
        }
    }
    @TestVisible public static List<String> visualProductGroups {
        get { 
            return productSettings.Visual_Products__c.split(';');
        }
    }
    @TestVisible public static List<String> soveliaProductGroups {
        get { 
            return productSettings.Sovelia_Products__c.split(';');
        }
    }
    @TestVisible public static List<String> servicesProducts {
        get { 
            return productSettings.Service_Product_Group__c.split(';');
        }
    }
    @TestVisible public static List<String> extraSalesProducts {
        get { 
            return productSettings.Extra_Sales_Product__c.split(';');
        }
    }
    @TestVisible public static List<String> otherProducts {
        get { 
            return productSettings.Other_Products__c.split(';');
        }
    }
    @TestVisible public static List<String> sparepartsProducts {
        get { 
            return productSettings.Spare_Part_Product_Group__c.split(';');
        }
    }
    @TestVisible public static List<String> productGroups {
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
    @TestVisible public static List<Product2> mainProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True];
        }
    } 
    @TestVisible public static List<Product2> soveliaProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Sovelia'];
        }
    } 
    @TestVisible public static List<Product2> visualProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Visualovelia'];
        }
    }
    @TestVisible public static List<Product2> retractableProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LG'];
        }
    } 
    @TestVisible public static List<Product2> slidingProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LGS'];
        }
    } 
    @TestVisible public static List<Product2> fixedWallProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LFIXEDWALL'];
        }
    } 
    @TestVisible public static List<Product2> balustradeProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'LUMONKAIDE'];
        }
    }  
    @TestVisible public static List<Product2> terraceProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c IN ('VT3','VT4')];
        }
    }   
    @TestVisible public static List<Product2> blindsProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE Product_Group__c = 'VISORBLINDSALES'];
        }
    }  
    @TestVisible public static Map<String,Id> mainProductMap {
        get {
            Map<String,Id> mainProductCodeToIdMap = new Map<String,Id>();
            for (Product2 mainProduct : mainProducts) {
                mainProductCodeToIdMap.put(mainProduct.Product_Group__c, mainProduct.Id);
            }
            return mainProductCodeToIdMap;
        }
    }
    @TestVisible public static List<Id> mainProductIds {
        get{
            return new List<Id>(new Map<Id, Product2>(mainProducts).keySet()); 
        }
    } 
    @TestVisible public static List<Product2> configurableProducts {
        get{
            return [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = False AND Cost_Type__c IN ('tuotteet','verhot')];
            
        }
    } 
    @TestVisible public static List<Id> configurableProductIds {
        get{
            return new List<Id>(new Map<Id, Product2>(configurableProducts).keySet()); 
        }
    } 
    @TestVisible public static List<Id> installationProductIds {
        get{
            List<Product2> products = [SELECT name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2 WHERE isMainProduct__c = False AND Cost_Type__c IN ('askuormitu')];
            return new List<Id>(new Map<Id, Product2>(products).keySet()); 
        }
    } 
    @TestVisible public static List<Product2> products {
        get {
            return [SELECT  name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive,QuantityUnitOfMeasure FROM Product2];
        }
    } 
    @TestVisible public static List<Id> productIds {
        get {
            return new List<Id>(new Map<Id, Product2>(products).keySet());
        }
    } 
    
    @TestVisible public static List<Factory_Price__c> factoryPrices{
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
    @TestVisible public static List<Product_Cost__c> productCosts{
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
    @TestVisible public static List<Sales_Price__c> salesPrices{
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
    @TestVisible public static Map<String,List<String>> productGroupMap {
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
    @TestVisible public static Map<String,Map<String,List<String>>> productToItemMap {
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
    @TestVisible public static List<Base_Price__c> basePrices{
        get{
            return [SELECT Id, ProductCode__c, CostType__c, ItemCode__c,  BasePrice__c, IsActive__c FROM Base_Price__c];
        }
    }
    @TestVisible public static List<Installation_Time__c> installationTimes{
        get{
            return [SELECT Id,Product__c, Hours__c,Minutes__c,IsActive__c FROM Installation_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible public static List<Production_Time__c> productionTimes{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible public static List<Production_Time__c> productionDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Days__c > 0];
        }
    }
    @TestVisible public static List<Production_Time__c> extraDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Extra_Days__c > 0];
        }
    }
    @TestVisible public static List<String> planTypes {
        get {
            return New List<String>{'Visual','Sovelia','Services','Sales','Supplies'}; // Not using Blinds or Extra Sales
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
    @TestVisible private static Id b2bContactId{
        get{
            return [SELECT Id FROM Contact WHERE (FirstName = 'My' AND LastName = 'Contact')]?.Id;
        }
    }
    
    

    @TestVisible public static List<Account> accounts{
        get{
            return [SELECT Id, IsPersonAccount, Business_Type__c, PersonMailingAddress, PersonOtherAddress,BillingAddress, ShippingAddress FROM Account ];
        }
    }
    @TestVisible public static Id b2cAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true) LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Id b2bAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Account b2cAccount{
        get{
            return LumonTestAccounts.b2cAccount;
        }
    }
    @TestVisible public static Account b2bAccount{
        get{
            return LumonTestAccounts.b2bAccount;
        }
    }
    @TestVisible public static List<Contact> contacts{
        get{
            return LumonTestContacts.contacts;
        }
    }
    /******** Pricebooks **********/
    @TestVisible public static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible public static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive,Product2.ProductCode, Product2.Product_Group__c, Product2.Sales_Code__c FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }

    /******** Sales Objects **********/
    @TestVisible public static List<Opportunity> opportunities{
        get{
            return [SELECT Id,Name, BusinessType__c, StageName,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Order_Type__c = 'Normal')];
        }
    }    
    @TestVisible public static Opportunity b2cOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2cOpportunityId) LIMIT 1];
        }
    }
    @TestVisible public static List<Opportunity> b2cOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true)];
        }
    }
    @TestVisible public static Opportunity b2bOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Id =: b2bOpportunityId) LIMIT 1];
        }
    }
    @TestVisible public static List<Opportunity> b2bOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false)];
        }
    }
    @TestVisible public static List<Quote> quotes{
        get{
            return [SELECT Id,Name,Pricebook2Id,opportunityId,AccountId FROM Quote];
        }
    }  
    @TestVisible public static List<OpportunityLineItem> opportunityProducts{
        get{
            return [SELECT Id, OpportunityId, SortOrder, PricebookEntryId, Product2Id, ProductCode, Name, 
                            CurrencyIsoCode, Quantity, TotalPrice, UnitPrice, ListPrice, ServiceDate, Description 
                    FROM OpportunityLineItem];
        }
    }  
    /******** Sales Object Records **********/
    @TestVisible public static List<Id> opportunityIds {
        get{
            return new List<Id>(new Map<Id, Opportunity>(opportunities).keySet()); 
        }
    }  
    @TestVisible public static List<Id> opportunityProductsIds {
        get{
            return new List<Id>(new Map<Id, OpportunityLineItem>(opportunityProducts).keySet()); 
        }
    }
    @TestVisible public static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Account.IsPersonAccount = false) LIMIT 1]?.Id;
        }
    } 
    @TestVisible public static List<Id> quoteIds{
        get{
            return new List<Id>(new Map<Id, Quote>(quotes).keySet()); 
        }
    }  
    @TestVisible public static Id b2cQuoteId{
        get{
            return [SELECT Id,Pricebook2Id, isSyncing, OpportunityId  FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Id b2bQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Id b2cSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (OpportunityId =: b2cOpportunityId AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }
    @TestVisible public static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE ( OpportunityId =: b2bOpportunityId  AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }  
    /******** Services Object **********/
    @TestVisible public static List<Case> cases{
        get{
            return [SELECT Id,RecordTypeId FROM Case];
        }
    }    
    @TestVisible public static List<Opportunity> reclamations{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE Order_Type__c = 'Reclamation'];
        }
    }
    @TestVisible public static Opportunity b2cReclamation{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2cReclamationId ) LIMIT 1];
        }
    }
    /******** Services Object Records **********/
    @TestVisible public static List<Id> caseIds {
        get{
            return new List<Id>(new Map<Id, Case>(cases).keySet()); 
        }
    } 
    @TestVisible public static Id normalCaseId{
        get{
            return [SELECT Id FROM Case WHERE Type = 'Normal']?.Id;
        }
    }
    @TestVisible public static Id specialOrderCaseId{
        get{
                return [SELECT Id FROM Case WHERE Type = 'Special Order']?.Id;
            }
    }
    @TestVisible public static Id reclamationCaseId{
        get{
            return [SELECT Id FROM Case WHERE Type = 'Reclamation']?.Id;
        }
    }

    @TestVisible public static Id b2cReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }

    @TestVisible public static Id b2bReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId,Order_type__c FROM Opportunity WHERE (Account.IsPersonAccount = false AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    /******** Configuration Objects **********/
    @TestVisible public static List<Configuration__c> configurationPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c ];
        }
    } 
    @TestVisible public static List<Configuration__c> visualConfigPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c  WHERE Plan_Type__c = 'Visual'];
        }
    } 
    @TestVisible public static List<Configuration__c> soveliaConfigPlans {
        get{
            return [ SELECT Id, Name,Opportunity__c, Plan_Name__c, Plan_Floor__c,Plan_Line__c,Plan_Apartment__c,Plan_Type__c,Visual_Id__c,Sovelia_Id__c FROM Configuration__c  WHERE Plan_Type__c = 'Sovelia'];
        }
    } 
    @TestVisible public static List<Configuration_Product__c> configurationProducts {
        get{
            return [ SELECT Id,Name, Configuration__c, Product__c,RVN_Number__c,RVN__c,Quantity__c, Product__r.QuantityUnitOfMeasure, Product__r.Sales_Code__c FROM Configuration_Product__c];
        }
    } 
    @TestVisible public static List<Configuration_Option__c> configurationOptions {
        get{
            return [ SELECT Id,Name, Configuration_Product__c, Product__c,RVN_Number__c,RVN__c,Quantity__c, Product__r.QuantityUnitOfMeasure, Product__r.Sales_Code__c FROM Configuration_Option__c];
        }
    } 
    @TestVisible public static List<Configuration_Message__c> configurationMessages{
        get{
            return [SELECT Id FROM Configuration_Message__c WHERE (Configuration_Product__c IN :configurationProducts)];
        }
    }
    @TestVisible public String visualPricingJSON{
        get {
            return string.valueOf([SELECT Visual_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'visual' LIMIT 1]);
        }
    }
    @TestVisible public String soveliaPricingJSON{
        get {
            return string.valueOf([SELECT Sovelia_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'sovelia' LIMIT 1]);
        }
    }
    /******** Configuration Object Records **********/
    @TestVisible public static List<Id> configurationPlanIds {
        get{
            return new List<Id>(new Map<Id, Configuration__c>(configurationPlans).keySet()); 
        }
    } 

    @TestVisible public static List<Id> configurationProductIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Product__c>(configurationProducts).keySet()); 
        }
    } 

    @TestVisible public static List<Id> configurationOptionIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Option__c>(configurationOptions).keySet()); 
        }
    }
    /******** Quoting Objects **********/
    @TestVisible public static List<QuoteLineItem> quoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice,Product2.ProductCode, Product2.Product_Group__c, Product2.Sales_Code__c FROM QuoteLineItem];
        }
    }
    @TestVisible public static List<QuoteLineItem> b2cQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cQuoteId];
        }
    }
    @TestVisible public static List<QuoteLineItem> b2cSyncedQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cSyncedQuoteId];
        }
    }
    @TestVisible public static List<QuoteLineItem> b2bQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bQuoteId];
        }
    }
    @TestVisible public static List<QuoteLineItem> b2bSyncedQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bSyncedQuoteId];
        }
    }
    /******** Quoting Object Records **********/

    /******** Pricing Objects **********/
    @TestVisible public static List<Pricing_Summary__c> pricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c];
        }
    }
    /******** Pricing Object Records **********/
    @TestVisible public static List<Pricing_Summary__c> b2cPricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c WHERE(Opportunity__c = :b2cOpportunityId)];
        }
    }
    /******** Contract Objects **********/
    @TestVisible public static List<Contract> contracts{
        get{
            return [SELECT Id,Pricebook2Id, AccountId  FROM Contract];
        }
    }
    /******** Contract Object Records **********/
    @TestVisible public static List<Id> contractIds {
        get{
            return new List<Id>(new Map<Id, Contract>(contracts).keySet()); 
        }
    }
    @TestVisible public static List<ContentDocumentLink> contractMessages {
        get {
            return [SELECT Id, ContentDocument.Title, ContentDocumentId, ContentDocument.FileType 
                    FROM ContentDocumentLink WHERE Id IN: contractIds];
        }
    }
    /******** Order Object Records **********/
    @TestVisible public static List<Order> orders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order];
        }
    }
    @TestVisible public static List<Id> orderIds {
        get{
            return new List<Id>(new Map<Id, Order>(orders).keySet()); 
        }
    }
    @TestVisible public static List<Order> b2cOrders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId)];
        }
    }
    /******** Delivery Objects **********/
    @TestVisible public static List<Factory__c> factories{
        get{
            return [SELECT Id FROM Factory__c];
        }
    }
    @TestVisible public static List<Warehouse__c> warehouses{
        get{
            return [SELECT Id FROM Warehouse__c];
        }
    }
    @TestVisible public static List<Building__c> buildings{
        get{
            return [SELECT Id FROM Building__c];
        }
    }

    @TestVisible public static List<Apartment__c> apartments{
        get{
            return [SELECT Id FROM Apartment__c];
        }
    }

    @TestVisible public static List<Schema.Location> locations{
        get{
            return [SELECT Id, LocationType, 
                    Latitude, Longitude, Location, Description, DrivingDirections, TimeZone, 
                    ParentLocationId, PossessionDate, ConstructionStartDate, ConstructionEndDate, 
                    OpenDate, CloseDate, RemodelStartDate, RemodelEndDate, IsMobile, IsInventoryLocation, 
                    VisitorAddressId, RootLocationId, LocationLevel, ExternalReference, ShouldSyncWithOci, LogoId 
                    FROM Location];
        }
    }
    @TestVisible public static List<Schema.Address> addresses{
        get{
            return [SELECT Id, 
                            Name, Description, DrivingDirections,
                            ParentId, 
                            LocationType, AddressType, 
                            Street, City, State, PostalCode, 
                            Country, StateCode, CountryCode, 
                            Latitude, Longitude, GeocodeAccuracy, 
                            Address,  TimeZone 
                    FROM Address];
        }
    }
    /******** Delivery Object Records **********/   
    @TestVisible public static List<Id> factoryIds{
        get{
            return new List<Id>(new Map<Id, Factory__c>(factories).keySet()); 
        }
    }   
    @TestVisible public static List<Id> warehouseIds{
        get{
            return new List<Id>(new Map<Id, Warehouse__c>(warehouses).keySet()); 
        }
    }   
    @TestVisible public static List<Id> buildingIds {
        get{
            return new List<Id>(new Map<Id, Building__c>(buildings).keySet()); 
        }
    } 
    @TestVisible public static List<Id> apartmentIds {
        get{
            return new List<Id>(new Map<Id, Apartment__c>(apartments).keySet()); 
        }
    } 
    
    /******** Field Service Objects **********/
    @TestVisible public static List<OperatingHours> operatingHours{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours];
        }
    } 
    @TestVisible public static List<ServiceTerritory> serviceTerritories{
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
    @TestVisible public static List<ServiceTerritoryMember> serviceTerritoryMembers{
        get{
            return [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, 
                        EffectiveStartDate, EffectiveEndDate, 
                        Street, City, State, PostalCode, Country, StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, 
                        OperatingHoursId, TravelModeId, FSL__Internal_SLR_HomeAddress_Geolocation__Latitude__s, 
                        FSL__Internal_SLR_HomeAddress_Geolocation__Longitude__s, FSL__Internal_SLR_HomeAddress_Geolocation__c, 
                        Resource_Name__c FROM ServiceTerritoryMember];
        }
    }   
    @TestVisible public static List<TimeSlot> timeSlots{
        get{
            return [SELECT Id,Type,DayOfWeek,StartTime,EndTime FROM TimeSlot];
        }
    } 
    @TestVisible public static List<ServiceResource> serviceResources{
        get{
            return [SELECT Id,Name, ServiceCrewId,ResourceType,FSL__GanttLabel__c,RelatedRecordId FROM ServiceResource];
        }
    }       
    @TestVisible public static FSL__Scheduling_Policy__c schedulingPolicy{
        get{
            return  [SELECT Id,Name FROM FSL__Scheduling_Policy__c LIMIT 1];
        }
    }
    @TestVisible public static List<WorkOrder> workOrders{
        get{
            return  [SELECT Id,Subject, WorkOrderNumber,AccountId,ContactId,CaseId,EntitlementId,ServiceContractId,AssetId,RootWorkOrderId,WorkTypeId,ServiceTerritoryId,StatusCategory,Opportunity__c FROM WorkOrder];
        }
    }
    @TestVisible public static List<ServiceAppointment> serviceAppointments{
        get{
            return [SELECT Id,Status,EarliestStartTime,DueDate ,ServiceTerritoryId,ParentRecordId FROM ServiceAppointment];
        }
    }
     /******** Field Service Object Records **********/
    @TestVisible public static Id availabilityHoursId{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours WHERE Name LIKE '%Availability Calenda%' LIMIT 1]?.Id;
        }
    } 
    @TestVisible public static Id timeslotHoursId{
        get{
            return [SELECT Id,Name,Timezone FROM OperatingHours WHERE Name LIKE '%Time Slots Calendar%' LIMIT 1]?.Id;
        }
    } 
   
    
    
    
    
}