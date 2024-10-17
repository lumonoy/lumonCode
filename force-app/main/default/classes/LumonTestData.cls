/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestData {
    /********** Static Test Data Records ***********/
    @TestVisible public static String soveliaPricing  = [SELECT Body FROM StaticResource WHERE Name = 'SoveliaPricing' ].Body.toString();
    @TestVisible public static String soveliaReport = [SELECT Body FROM StaticResource WHERE Name = 'SoveliaReport' ].Body.toString();
    @TestVisible public static String visualPricing  = [SELECT Body FROM StaticResource WHERE Name = 'VisualPricing' ].Body.toString();
    //@TestVisible public static String visualStatistics = [SELECT Body FROM StaticResource WHERE Name = 'visualStatistics' ].Body.toString();
    @TestVisible public static String consumerBatchJSON  = [SELECT Body FROM StaticResource WHERE Name = 'ConsumerBatch' ].Body.toString();
    @TestVisible public static String projectBatchJSON = [SELECT Body FROM StaticResource WHERE Name = 'ProjectBatch' ].Body.toString();
    /********** Custom MetaData ***********/
    @TestVisible public static List<String> visualProducts = new List<String>{'LG;LGS;LFIXEDWALL;LUMONKAIDE;VT3;VT4'};
    @TestVisible public static List<String> soveliaProducts = new List<String>{'VISORBLIND;VISORBLINDSALES'};
    @TestVisible public static List<String> servicesProducts = new List<String>{'MAINT;BASIC;INSPECT;FIRST;SERVICE;EXTEND;HOURS;RENOV'};   
    @TestVisible public static List<String> extraSalesProducts = new List<String>{'LISAHIN'};//'LISÄHIN';
    @TestVisible public static List<String> sparepartsProducts = new List<String>{'TARVIKE; VARUSTE'};
    //String legacyMainProducts = 'LUMON5;LUMON6;LUMON6T;LT3;VT3;KIINTEÄSEI;LUMON7S';
    //String otherMainProducts = 'TERRACEMAT;LISÄPROF 1';
    //String installableProducts = soveliaMainProducts+';'+visualMainProducts;
    //String mainProductActualCodes = '30310020;90370001;90400001;90240001;90260001;90750001;90780001;62860088';
    //String reclamationActualCodes = '30210020R;90379999;90409999;90249999;90269999;90759999;90789999;62860090';
    //String reclamationTestCodes = 'R-LG;R-LGS;R-LFIXEDWALL;R-LUMONKAIDE;R-VT3;R-VT4';
    //String reclamationCodes = reclamationActualCodes+';'+reclamationTestCodes;
    
    //String specialProductTerraceCodes = 'PD9750050;PD9780010;PD9750050;PD975004;PD9750043;PD9750042,PD9780052';
    //String specialProductBalconyCodes = 'PD9240105;PD9240106;PD9240107:PD9390017';
    /********** Alphabet ***********/
    @TestVisible public static String letters {
        get {
            return  ('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
        }
    }
    /********** Lists ***********/
    @TestVisible public static List<String> businessTypes {
        get {
            return  new List<String>{'1','4','7'};//,'Reseller'};// NOTE: Valueset has only Numbers as API 1,7,4 Not 'Consumer','Project','Reseller'
        }
    }
    @TestVisible public static List<String> countryCodes {
        get {
            return new List<String>{'FI'};//,,'ES''SE','CA'};
        }
    }
    @TestVisible public static List<String> organizations {
        get {
            return new List<String>{'LSU'};//'LU','LCE',
        }
    }
    @TestVisible public static List<String> districts {
        get {
            return new List<String>{'FI_South'};//,'FI_North','FI_West','FI_East'};
            //'ES_Andalucia','ES_Aragon','ES_Canarias','ES_Cataluna','ES_Levante','ES_Madrid','ES_Mallorca'
    
        }
    }
    @TestVisible public static List<String> profitCenters {
        get {
            return new List<String>{'4010 LSU Vantaa West','4011 LSU Vantaa East','401 LSU Vantaa Project',
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
    
    @TestVisible public static List<String> planTypes {
        get {
            return new List<String>{'Visual','Sovelia','Services','Sales','Supplies'}; // Not using Blinds or Extra Sales
        }
    }
    /*public static void setupLumonTestData() {
        try {     
            LumonTestUsers.setupUserData();   
            LumonTestLocations.setupLocationData();   
            LumonTestProductSettings.setupProductSettings();
            LumonTestProducts.setupProductData();
            LumonTestBasePrices.setupBasePriceData();
            LumonTestInstallationTimes.setupInstallationTimeData();
            LumonTestProductionTimes.setupProductionTimeData();
            LumonTestPriceMultipliers.setupPriceMultiplierData();
            LumonTestPricebooks.setupPricebookData();
            LumonTestAccounts.setupAccountData();
            LumonTestOpportunities.setupOpportunityData();
            LumonTestConfigurationPlans.setupConfigurationData();
            LumonTestConfigurationProducts.setupConfigurationProductData();
            LumonTestConfigurationOptions.setupConfigurationOptionData();
            LumonTestQuoteLines.setupQuoteLineData();
            LumonTestReclamations.setupReclamationData();
        }catch (Exception e){
            System.debug('--- LumonTestData - Exception '+e);
        } 
    }
    @isTest
    public static void setupLumonDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupLumonTestData();
            testResult = 'successfully inserted Test Data';
        } catch (exception e){
            testResult = 'Error when inserting Test Data: '+e.getMessage();
        }
        System.debug('--- LumonTestData - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestData - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }*/

    @TestVisible public static Map<String,List<String>> addressMap {
        get {
            Map<String,List<String>> addressMap = new Map<String,List<String>>();
            addressMap.put('b2cAccount', new List<String>{'Finland','City','12345','Some Street 100','FI_South'}); 
            addressMap.put('b2bAccount', new List<String>{'Finland','City','12345','Some Street 200','FI_South'}); 
            addressMap.put('contact', new List<String>{'Finland','City','12345','Some Street 300','FI_South'}); 
            addressMap.put('lead', new List<String>{'Finland','City','12345','Some Street 1','FI_South'}); 
            return addressMap;
        }
    }
    @TestVisible public static List<List<Object>> holidayDays {
        get {
            List<List<Object>> holidayDays=new List<List<Object>>();
            List<Object> holidayDay1 = new List<Object>{'Uudenvuodenpäivä',true,'2024-01-01'};
            List<Object> holidayDay2= new List<Object>{'Jouluaatto',true,'2024-12-24'};
            List<Object> holidayDay3 = new List<Object>{'Joulupäivä',true,'2024-12-25'};
            List<Object> holidayDay4 = new List<Object>{'Tapaninpäivä',true,'2024-12-26'};
            holidayDays.add(holidayDay1);
            holidayDays.add(holidayDay2);
            holidayDays.add(holidayDay3);
            holidayDays.add(holidayDay4);

            return holidayDays;
        }
    }
    @TestVisible public static List<String> productGroups {
        get {
            return new List<String>{'LG','LGS','BASIC','EXTEND','HOURS','INSPECT','LFIXEDWALL','LISÄKUSTAN','LUMONKAIDE','LUMONTOLPK','MAINT','PELTI','RENOV','SERVICE','TERRACEMAT','VISORBLINDSALES','VT3','VT4'};
            //'AUKKOLASI','AUKKOLASIL','BASIC','EXTEND','HOURS','INSPECT','KEHYSLASI','LAMILASIT','LCE AUKKOL','LCE AUKOLA','LCE KATTO','LCE PELTI','LCE VÄLISE','LCE VARUST','LFIXEDWALL','LG','LGS','LISÄKUSTAN','LUMONKAIDE','LUMONTOLPK','MAINT','OtherSale2','OtherSale3','OtherSales','PELTI','RENOV','SERVICE','SLUPROF','TERRACEMAT','USCANOWN','VÄLISEINÄ','VISORBLINDSALES','VT3','VT4'
    
        }
    }
    @TestVisible public static List<String> costTypes {
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
}