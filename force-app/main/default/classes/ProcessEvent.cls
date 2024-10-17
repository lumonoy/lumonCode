/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-26-2024
 * @last modified by  : Henk Reynders
**/
public class ProcessEvent {
    @AuraEnabled
    public static void publishProcessEvent(String stage, String activity,
                                            String recordId, String objectType,
                                            String jsonString, String documentId){
        List<ProcessStepEvent__e> processEvents = new List<ProcessStepEvent__e>();    
        ProcessStepEvent__e  stepEvt  = new ProcessStepEvent__e ( 
                                                        ProcessStage__c = stage, 
                                                        ProcessActivity__c = activity, 
                                                        recordId__c = recordId,//Parent Record Id 
                                                        objectType__c = objectType,
                                                        JsonString__c = jsonString,
                                                        documentId__c = documentId);
        System.Debug('--- ProcessEvent - Stage '+stage);
        System.Debug('--- ProcessEvent - Activity '+activity);                                  
        System.Debug('--- ProcessEvent - Record: '+recordId);     
        System.Debug('--- ProcessEvent - Object: '+objectType);                                              
        processEvents.add(stepEvt);
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(processEvents);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('--- ProcessStep - Successfully published Process Event');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('--- ProcessStep - Failed to publish Process Event with Error: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
    }
}