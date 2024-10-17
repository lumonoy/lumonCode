/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
public class ConfigurationEvent {
    @AuraEnabled
    public static void publishConfigurationEvent(   String configType, //Blinds,Structure,Pricing,Other
                                                    String configAction, //ConfigAction
                                                    String configId, //Configuration.Id
                                                    String recordId, //Parent Record Id 
                                                    String objectType, //Parent Object Type
                                                    String externalId, //Opportunity.Id
                                                    String documentId, //Link to the File uploaded 
                                                    String contentJSON //Visual Request BODY (Pricing File Content)
                                                    ){
        List<ConfigurationEvent__e> configEvents = new List<ConfigurationEvent__e>();    
        ConfigurationEvent__e  cfgEvt  = new ConfigurationEvent__e ( 
                                                        configType__c = configType, //Blinds,Structure,Pricing,Other
                                                        configAction__c = configAction, //ConfigAction
                                                        configId__c = configId, //Configuration.Id
                                                        recordId__c = recordId,//Parent Record Id 
                                                        objectType__c = objectType,
                                                        pricingJSON__c = contentJSON,
                                                        configJSON__c = contentJSON,
                                                        blindsJSON__c = contentJSON,
                                                        itemJSON__c = contentJSON,
                                                        structureJSON__c = contentJSON,
                                                        visualPlanId__c =externalId
                                                        ); //Parent Object Type
        System.Debug('--- ConfigurationEvent - '+configType+' Configuration Event -  '+configAction+' Action for '+objectType+' with Id '+recordId);       
        System.Debug('--- ConfigurationEvent - '+configType+' Configuration Event - Configuration Plan '+configId+' with Visual Id '+externalId);                                  
        System.Debug('--- ConfigurationEvent - '+configType+' Configuration Event - Content: '+contentJSON);       
        configEvents.add(cfgEvt);
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(configEvents);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
    }
}