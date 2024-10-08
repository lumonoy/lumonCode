/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurations {
    @TestVisible private static String visualPricingJSON {
        get {return retractablePricing;}
    }  
    @TestVisible private static String soveliaPricingJSON {
        get {return soveliaPricing; }
    }
    @TestVisible private static String testPricingJSON {
        get {return LumonTestVariables.testPricingJSON;}
    }
    @TestVisible private static String roboPricing {
        get {return LumonTestVariables.roboPricing;}
    }
    @TestVisible private static String retractablePricing {
        get {return LumonTestVariables.retractablePricing;}
    }
    @TestVisible private static String soveliaPricing {
        get {return LumonTestVariables.soveliaPricing;}
    }
    @TestVisible private static String soveliaReport {
        get {return LumonTestVariables.soveliaReport;}
    }
    private static List<Id> opportunityIds = LumonTestVariables.opportunityIds;
    private static List<String> planTypes = LumonTestVariables.planTypes;
    public static void setupConfigurationPlans() {        
        if (opportunityIds.size()>0){
            System.debug('--- LumonTestConfigurations - Using existing Test Opportunities');
        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        for (Id opportunityId : opportunityIds){

            setupConfigurationPlans(opportunityId, planTypes);
        }
    }
    public static void setupConfigurationPlans(Id opportunityId, List<String> planTypes) {
        List<Configuration__c> configPlansToUpsert = new List<Configuration__c>();
        Integer nbr = 0;   
        for (String planType : planTypes ) {
            nbr++;
            Configuration__c configPlan = new Configuration__c();
            configPlan.Opportunity__c = opportunityId;
            configPlan.Plan_Apartment__c = 'A'+nbr;// public String apartment; // Door Nbr in Apartment
            configPlan.Plan_Floor__c = '1';// public Integer floor; // Floor Nbr in Building
            configPlan.Plan_Line__c = String.Valueof(nbr);// public String line; //?
            configPlan.Plan_Name__c = 'Plan '+nbr;// public String name; // Name of the Configuration
            configPlan.plan_Type__c = planType;
            configPlan.Name=planType +' Configuration Plan';
            if (planType == 'visual') {
                configPlan.Visual_Id__c = 'Visual-'+nbr;//public String Id; // Unique Visual Configuration Id   
            } else if (planType == 'sovelia') {
                configPlan.Sovelia_Id__c = 'Sovelia-'+nbr;//public String Id; // Unique Sovelia Configuration Id   
            }         
            System.debug('--- LumonTestConfigurations - Configuration Plan '+configPlan);
            configPlansToUpsert.add(configPlan);
        }
        if (configPlansToUpsert.size()>0) {
            insert configPlansToUpsert;
        }
        System.debug('--- LumonTestConfigurations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurations - Queries used: '+LIMITS.getQueries());
    }
    public static void setupConfigurationPlanB2C() {
        List<Configuration__c> configPlansToUpsert = new List<Configuration__c>();
        Id opportunityId = lumonTestVariables.b2cOpportunityId;
        Id QuoteId = lumonTestVariables.b2cSyncedQuoteId;
        Integer nbr = 0;   
        for (String planType : planTypes ) {
            nbr++;
            Configuration__c configPlan = new Configuration__c();
            configPlan.Opportunity__c = opportunityId;
            configPlan.Quote__c = quoteId;
            configPlan.Plan_Apartment__c = 'A'+nbr;// public String apartment; // Door Nbr in Apartment
            configPlan.Plan_Floor__c = '1';// public Integer floor; // Floor Nbr in Building
            configPlan.Plan_Line__c = String.Valueof(nbr);// public String line; //?
            configPlan.Plan_Name__c = 'Plan '+nbr;// public String name; // Name of the Configuration
            configPlan.plan_Type__c = 'visual';
            configPlan.Name=planType +' Configuration Plan';
            if (planType == 'visual') {
                configPlan.Visual_Id__c = 'Visual-'+nbr;//public String Id; // Unique Visual Configuration Id   
            } else if (planType == 'sovelia') {
                configPlan.Sovelia_Id__c = 'Sovelia-'+nbr;//public String Id; // Unique Sovelia Configuration Id   
            }         
            System.debug('--- LumonTestConfigurations - Configuration Plan '+configPlan);
            configPlansToUpsert.add(configPlan);
        }
        if (configPlansToUpsert.size()>0) {
            insert configPlansToUpsert;
        }
        System.debug('--- LumonTestConfigurations - setupConfigurationPlanB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurations - setupConfigurationPlanB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupConfigurationData() {
        try {           
            setupConfigurationPlans();
        }catch (Exception e){
            System.debug('--- LumonTestConfigurations - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Opportunity> opportunities = LumonTestVariables.opportunities;
        if(opportunities?.size()>0){
            System.debug('--- LumonTestConfigurations - Using existing Opportunities');
        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationData();
            testResult = 'successfully inserted Configurations';
        } catch (exception e){
            testResult = 'Error when inserting Configurations: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurations - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Configuration__c> configPlans = LumonTestVariables.configPlans;
        System.AssertNotEquals(0, configPlans.size(), ' Expected Configuration Plans to be Inserted');
    }
}