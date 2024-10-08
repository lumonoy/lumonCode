/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-14-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class QuotingManagerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupQuoteB2C();  
        LumonTestDataFactory.setupSyncedQuoteB2C();    
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        LumonTestDataFactory.setupVisualPricingDocument();
        Test.stopTest();
    }
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cConfigurationPlanId = LumonTestDataFactory.b2cConfigurationPlanId; // First Plan related to Opportunity
	//private static String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
    //private static String soveliaPricingJSON = LumonTestConfigurations.soveliaPricingJSON;
    /* Process Stages to cover
    * Stage 1 Configure: Visual, Sovelia,Configurator, Services, Spares, Other
	* Stage 2 Price: Calculate
	* Stage 3 Quote: Prepare, Approve, Close
	* Stage 4 Contract:Draft, Update, Activate
	* Stage 5 Order:Draft, Update, Activate
	* Stage 6 Reclamation:Draft, Update
	*/
    @IsTest
    public static void visualConfigurationTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';

        String configAction = 'Configure';
        String configType = 'Visual';
        
        String visualPlanId = 'B2C-ABCDE1';
        String documentId = docId;
        String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
        String configJSON = visualPricingJSON;
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, visualPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Visual Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Visual Plan');
        System.debug('--- QuotingManagerTest - Visual Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Visual Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void soveliaTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Configure';
        String configType = 'Sovelia';        
        String soveliaPlanId = 'BLIND';
        String documentId = docId;
        String soveliaPricingJSON = LumonTestConfigurations.soveliaPricingJSON;
        String configJSON = soveliaPricingJSON;
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, soveliaPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Sovelia Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Sovelia Plan');
        System.debug('--- QuotingManagerTest - Sovelia Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Sovelia Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void reclamationTest() {
        Opportunity opp = [SELECT Id,Order_type__c from Opportunity where Id = :b2cOpportunityId limit 1];
        opp.Order_type__c = 'Reclamation';
        update opp;
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';

        String configAction = 'Configure';
        String configType = 'Visual';
        
        String visualPlanId = 'B2C-ABCDE1';
        String documentId = docId;
        String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
        String configJSON = visualPricingJSON;
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, visualPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - ReclamationTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to update Reclamation');
        System.debug('--- QuotingManagerTest -  CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest -  SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
	@IsTest
    public static void configuratorTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Configure';
        String configType = 'Configurator';        
        String visualPlanId = 'B2C-ABCDE1';
        String documentId = docId;
        String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
        String configJSON = visualPricingJSON;
      
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, visualPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - QuotingManagerConfiguratorTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Visual Plan successfully');
        System.debug('--- QuotingManagerTest - QuotingManagerConfiguratorTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - QuotingManagerConfiguratorTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void sparesTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Configure';
        String configType = 'Spares';        
        String configPlanId = 'SPARES';
        String documentId = docId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Spares Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Spares Plan');
        System.debug('--- QuotingManagerTest - Spares Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Spares Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void servicesTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Configure';
        String configType = 'Services';        
        String configPlanId = 'SERVICE';
        String documentId = docId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Services Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Services Plan');
        System.debug('--- QuotingManagerTest - Services Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Services Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void scheduleTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Quote';
        String configType = 'Schedule';        
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, '','', '');
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - scheduleTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Sovelia Plan');
        System.debug('--- QuotingManagerTest - scheduleTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - scheduleTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void generateTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Quote';
        String configType = 'Generate';        
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, '','', '');
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - generateTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Sovelia Plan');
        System.debug('--- QuotingManagerTest - generateTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - generateTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void quoteTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Quote';
        String configType = 'Prepare';        
        String configPlanId;
        String documentId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Quoting Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to update Quote!');
        System.debug('--- QuotingManagerTest - Quoting Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Quoting Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
     @IsTest
    public static void orderTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Order';
        String configType = 'Prepare';        
        String configPlanId;
        String documentId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - Order Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to update Quote!');
        System.debug('--- QuotingManagerTest - Order Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - Order Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void updateTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';
        String configAction = 'Order';
        String configType = 'Update';        
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess( configType, configAction, configId, recordId,
                                                                objectType, '','', '');
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - updateTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to process Sovelia Plan');
        System.debug('--- QuotingManagerTest - updateTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - updateTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void feedbackTest() {
        String errorMessage;
        String configId  = b2cConfigurationPlanId;
        Id docId = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId  LIMIT 1]?.Id;
        String recordId = b2cOpportunityId;
        String objectType = 'Opportunity';      
        String configPlanId;
        String documentId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess('Custom', 'Configure', configId, recordId,objectType, configPlanId,documentId, configJSON);
            QuotingManager.executeQuotingProcess('Approved','Quote',  configId, recordId,objectType, configPlanId,documentId, configJSON);
            QuotingManager.executeQuotingProcess('Closed','Quote', configId, recordId,objectType, configPlanId,documentId, configJSON);
            QuotingManager.executeQuotingProcess('Activated','Contract', configId, recordId,objectType, configPlanId,documentId, configJSON);
            QuotingManager.executeQuotingProcess('Activated', 'Order',  configId, recordId,objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - UI Feedback Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to send Feedback');
        System.debug('--- QuotingManagerTest - UI Feedback Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - UI Feedback Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
    @IsTest
    public static void deliverTest() {
        String errorMessage;
        String configId  = [SELECT Body FROM StaticResource WHERE Name = 'TestOrderMessageJSON' ].Body.toString();  
        Id docId;
        String recordId;
        String objectType;      
        String configPlanId;
        String documentId;
        String configJSON;   
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess('Process', 'Deliver', configId, recordId,objectType, configPlanId,documentId, configJSON);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- QuotingManagerTest - UI Feedback Test - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to send Feedback');
        System.debug('--- QuotingManagerTest - UI Feedback Test - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuotingManagerTest - UI Feedback Test - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    }
}