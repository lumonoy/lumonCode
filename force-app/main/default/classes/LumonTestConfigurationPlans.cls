/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationPlans {
    @TestVisible private static String visualPricing = LumonTestData.visualPricing;
    @TestVisible private static String soveliaPricing = LumonTestData.soveliaPricing;
    @TestVisible private static List<String> planTypes = LumonTestData.planTypes;
    @TestVisible public static List<Configuration__c> configurationPlans {
        get{
            return [ SELECT Id, Name,Floor__c,Line__c,Unit__c,PlanType__c FROM Configuration__c ];
        }
    } 
    @TestVisible public static List<Id> configPlanIds {
        get{
            return new List<Id>(new Map<Id, Configuration__c>(configurationPlans).keySet()); 
        } 
    } 
    public static void setupConfigurationPlans() {
        List<Configuration__c> configPlans = new List<Configuration__c>();
        Integer nbr = 0;   
        for (String planType : planTypes ) {
            nbr++;
            Configuration__c configPlan = new Configuration__c();
            //configPlan.Opportunity__c = opportunityId;
            configPlan.Unit__c = 'A'+nbr;// public String apartment; // Door Nbr in Apartment
            configPlan.Floor__c = '1';// public Integer floor; // Floor Nbr in Building
            configPlan.Line__c = String.Valueof(nbr);// public String line; //?
            configPlan.PlanType__c = planType;
            configPlan.Name=planType +' Configuration Plan';
            if (planType == 'visual') {
                configPlan.Visual_Id__c = 'Visual-'+nbr;//public String Id; // Unique Visual Configuration Id   
            } else if (planType == 'sovelia') {
                configPlan.Sovelia_Id__c = 'Sovelia-'+nbr;//public String Id; // Unique Sovelia Configuration Id   
            }         
            System.debug('--- LumonTestConfigurationPlans - Configuration Plan '+configPlan);
            configPlans.add(configPlan);
        }
        if (configPlans.size()>0) {
            insert configPlans;
        }
        System.debug('--- Created '+configPlans.size()+ ' Configuration Plans');
        System.debug('--- LumonTestConfigurationPlans - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationPlans - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationPlanData() {
        try {           
            setupConfigurationPlans();
        }catch (Exception e){
            System.debug('--- LumonTestConfigurationPlans - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationPlanData();
            testResult = 'successfully inserted Configurations';
        } catch (exception e){
            testResult = 'Error when inserting Configurations: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationPlans - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationPlans - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}