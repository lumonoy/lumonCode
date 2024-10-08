/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
@istest
public with sharing class LumonTestProductSettings {
	public static void setupProductSettings(){  
        Id productSettingsOwner = Product_Settings__c.getOrgDefaults().SetupOwnerId;  
        String visualMainProducts = 'LG;LGS;LFIXEDWALL;LUMONKAIDE;VT3;VT4';
        String soveliaMainProducts ='VISORBLIND;VISORBLINDSALES';
        String servicesMainProducts ='MAINT;BASIC;INSPECT;FIRST;SERVICE;EXTEND;HOURS;RENOV';        
        String extraSalesMainProducts = 'LISAHIN';//'LISÄHIN';
        String legacyMainProducts = 'LUMON5;LUMON6;LUMON6T;LT3;VT3;KIINTEÄSEI;LUMON7S';
        String otherMainProducts = 'TERRACEMAT;LISÄPROF 1';
        String installableProducts = soveliaMainProducts+';'+visualMainProducts;
        String sparePartsMainProducts = 'TARVIKE; VARUSTE';
        String mainProductActualCodes = '30310020;90370001;90400001;90240001;90260001;90750001;90780001;62860088';
        
        String mainProductCodes = mainProductActualCodes;
        
        String reclamationActualCodes = '30210020R;90379999;90409999;90249999;90269999;90759999;90789999;62860090';
        String reclamationTestCodes = 'R-LG;R-LGS;R-LFIXEDWALL;R-LUMONKAIDE;R-VT3;R-VT4';
        String reclamationCodes = reclamationActualCodes+';'+reclamationTestCodes;
        
        String specialProductTerraceCodes = 'PD9750050;PD9780010;PD9750050;PD975004;PD9750043;PD9750042,PD9780052';
        String specialProductBalconyCodes = 'PD9240105;PD9240106;PD9240107:PD9390017';
        
        Id orgId = [SELECT Id FROM Organization].Id;
        Product_Settings__c productSettings = new Product_Settings__c();
        
        productSettings.SetupOwnerId = orgId;
        productSettings.Installable_Products__c = installableProducts;
       	// Main Products aka Product Groups    
        productSettings.Visual_Products__c = visualMainProducts;
        productSettings.Sovelia_Products__c = soveliaMainProducts;
        productSettings.Service_Product_Group__c = servicesMainProducts;
        productSettings.AX_Products__c = legacyMainProducts;
        productSettings.Other_Products__c = otherMainProducts;
        productSettings.Extra_Sales_Product__c = extraSalesMainProducts;
        productSettings.Spare_Part_Product_Group__c = sparePartsMainProducts;
        // Special Handling Product Codes       
        //productSettings.Additional_Cost_Product_Group__c = additionalCostMainProducts;
        productSettings.Main_Product_Codes__c = mainProductCodes;
        productSettings.Reclamation_Product_Codes__c = reclamationCodes;
        productSettings.Special_Terrace_Products__c = specialProductTerraceCodes;
        productSettings.Special_Balcony_Products__c = specialProductBalconyCodes;

        insert productSettings;
        System.debug('--- LumonTestProductSettings - inserted productSettings: '+productSettings );
        System.debug('--- LumonTestProductSettings - inserted Visual Products: '+visualMainProducts );

    }
    @Istest
    public static void setupProductSettingsTest(){
        String testresult;
        try {
            setupProductSettings();            
        	testresult = ('Inserted Product Settings'); 
		} catch (Exception e) {
            //Any other exceptions that occur will go here
            String errorMessage = e.getMessage(); 
            testresult = ('Error - An Exception Occured:'+errorMessage);
        }
        System.debug('--- LumonTestProductSettings - Test Result: '+testresult );
        System.assertNotEquals('Error',testresult,' Expected Product Settings to be Inserted without Error');

    } 
}