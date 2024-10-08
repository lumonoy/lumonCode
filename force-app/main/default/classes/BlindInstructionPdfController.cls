public class BlindInstructionPdfController {
    
    public Static List<ConfigurationWrapper> blindsData {get; set;}
    public Static String workOrderId {get; set;}
    
    public BlindInstructionPdfController(){
        workOrderId = ApexPages.currentPage().getParameters().get('workorderId');
        getBlindData(workOrderId);
    }
    
    public Static List<ConfigurationWrapper> getBlindData(String workOrderId){
        Set<Id> configurationPlanIdSet = new Set<Id>();
        String configurationPlanId;
        List<WorkOrder> workOrderRec = [SELECT Id, Opportunity__c, Configuration_Plan__c,
                                        (SELECT ID, Configuration_Product__c,Configuration_Product__r.Configuration__r.Plan_Type__c,Configuration_Product__r.Configuration__r.Id FROM WorkOrderLineItems 
                                         WHERE Configuration_Product__r.Configuration__r.Plan_Type__c ='Blinds')
                                        FROM WorkOrder  WHERE Id = :workOrderId];
        System.debug('*** workOrderRec ***'+workOrderRec);
        System.debug('*** workOrderRec ***'+workOrderRec[0].WorkOrderLineItems);
        if(workOrderRec.size() >0 && workOrderRec[0].WorkOrderLineItems.size() > 0){
            for(WorkOrderLineItem workLineRec : workOrderRec[0].WorkOrderLineItems){
                configurationPlanIdSet.add(workLineRec.Configuration_Product__r.Configuration__r.Id);
            }
        }
        System.debug('*** configurationPlanIdSet ***'+configurationPlanIdSet);
        Map<Id,Configuration_Product__c> configProdMap = new Map<Id,Configuration_Product__c>([SELECT Id,Name, RVN_Number__c, Product__r.Name, Installer_Message__c, Configuration__c,
                                                                                               Configuration__r.Plan_Type__c, Configuration__r.Name,opportunity__c,
                                                                                               (SELECT Id,NAME FROM Configuration_Sides__r ) 
                                                                                               FROM Configuration_Product__c  WHERE  Configuration__r.Plan_Type__c = 'Blinds'
                                                                                               AND Configuration__r.Id IN :configurationPlanIdSet]);
        
        
        Map<Id,Configuration_Side__c>  configSideRecordMap = new Map<Id,Configuration_Side__c>([SELECT Id,Name,Configuration_Product__c,Configuration_Product__r.Name,Side_Number__c, 
                                                                                                (SELECT Id, Glass_Number__c, Blinds_Type__c, Blinds_Color__c, Blinds_Profile_Color__c, 
                                                                                                 Case_Profile_Color__c, Edge_Profile_Color__c, Height__c, Width__c, Blind_Id__c, Quantity__c  
                                                                                                 FROM  Configuration_Side_Panes__r) 
                                                                                                from Configuration_Side__c  Where 
                                                                                                Configuration_Product__c  IN:configProdMap.keyset()]);
        List<ConfigurationWrapper> conWrapRecList = new List<ConfigurationWrapper>();
        
        for(Configuration_Product__c configProdRec : configProdMap.values()){
            //Adding product to the wrapper
            ConfigurationWrapper conWrapRec = new ConfigurationWrapper();
            
            conWrapRec.configProduct = configProdRec;
            System.debug('*** conWrapRec configProduct ***'+conWrapRec.configProduct);
            if(configProdRec.Configuration_Sides__r.size() > 0){
                List<ConfigurationSidesWrapper> configSideList = new List<ConfigurationSidesWrapper>();
                for(Configuration_Side__c configSideRec : configProdRec.Configuration_Sides__r){
                    if(configSideRecordMap.containsKey(configSideRec.Id)){
                        Configuration_Side__c configSide =configSideRecordMap.get(configSideRec.Id);
                        // adding configuration sides to the wrapper
                        ConfigurationSidesWrapper configsideWrap = new ConfigurationSidesWrapper();
                        configsideWrap.configside = configSideRecordMap.get(configSideRec.Id);
                        // adding config side panes to the wrapper
                        if(configSide.Configuration_Side_Panes__r.size() > 0){
                            configsideWrap.sidePanes = configSide.Configuration_Side_Panes__r;
                        }
                        configSideList.add(configsideWrap);
                    }
                }
                conWrapRec.configSideList = configSideList;
                System.debug('*** conWrapRec ***'+conWrapRec);
                conWrapRecList.add(conWrapRec);
            }
        }
        System.debug('*** conWrapRecList ***'+conWrapRecList);
        blindsData = conWrapRecList;
        return conWrapRecList;
    }
    
    @AuraEnabled
    public static Boolean checkBlindsData(String recordId){
        List<ConfigurationWrapper> blindsData = getBlindData(recordId);
        if(blindsData.size() > 0 ){
            return false;
        }else{
            return true;
        }
    } 
    
    public class ConfigurationWrapper {
        public Configuration_Product__c configProduct{ get; set; }
        public List<ConfigurationSidesWrapper> configSideList { get;set;}
    }
    
    public class ConfigurationSidesWrapper {
        public Configuration_Side__c configside {get; set;}
        public List<Configuration_Side_Pane__c> sidePanes {get; set;}
    }
    
}