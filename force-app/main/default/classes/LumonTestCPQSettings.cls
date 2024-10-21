/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
@istest
public with sharing class LumonTestCPQSettings {
	public static void setupCPQSettings(){  
        Id cpqSettingsOwner = CPQ_Settings__c.getOrgDefaults().SetupOwnerId;  
        Id orgId = [SELECT Id FROM Organization].Id;
        CPQ_Settings__c cpqSettings = new CPQ_Settings__c();
        cpqSettings.Name = 'Default CPQ Setting';
        cpqSettings.SetupOwnerId = orgId;
        cpqSettings.Debug__c = False;
        cpqSettings.Enhanced_Pricing__c	= False;
        cpqSettings.Group_Items__c	= False;
        cpqSettings.Use_Pricelist__c = False;
        cpqSettings.Discount_Override__c = False;
        cpqSettings.Buffer_Override__c = False;
        cpqSettings.Detailed_View__c = False;
        cpqSettings.maxDiscount__c = 0;
        cpqSettings.Closed_Stages__c = ('Closed Won;Cancelled;Closed Lost');
        cpqSettings.Configure_Stages__c = ('Configure;Price;Quoting');
        // To be Deleted Fields
        // cpqSettings.IsAdmin__c	FALSE
        //cpqSettings.IsManager__c	FALSE
        //cpqSettings.IsSales__c	FALSE
        //cpqSettings.IsSupport__c	FALSE
        insert cpqSettings;
        System.debug('--- LumonTestCPQSettings - inserted cpqSettings: '+cpqSettings );
    }
    @Istest
    public static void setupCPQSettingsTest(){
        String testresult;
        try {
            setupCPQSettings();            
        	testresult = ('Inserted CPQ Settings'); 
		} catch (Exception e) {
            //Any other exceptions that occur will go here
            String errorMessage = e.getMessage(); 
            testresult = ('Error - An Exception Occured:'+errorMessage);
        }
        System.debug('--- LumonTestCPQSettings - Test Result: '+testresult );
        System.assertNotEquals('Error',testresult,' Expected CPQ Settings to be Inserted without Error');
    }
}