/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : Henk Reynders
**/
public class ProcessEventController {
    @AuraEnabled
    public static void publishEvent(ProcessEventData eventData){
        List<ProcessEvent__e> processEvents = new List<ProcessEvent__e>();    
        ProcessEvent__e  processEvent  = new ProcessEvent__e ();        
        processEvent.stage__c = eventData.stage;
        processEvent.activity__c = eventData.activity;
        processEvent.recordId__c = eventData.recordId;
        processEvent.objectType__c = eventData.objectType;
        processEvent.jsonString__c = eventData.jsonString;
        processEvent.documentId__c = eventData.documentId;
        System.Debug('--- ProcessEventController - publishEvent Stage '+eventData.stage);
        System.Debug('--- ProcessEventController - publishEvent Activity '+eventData.activity);                                                                               
        processEvents.add(processEvent);
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(processEvents);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('--- Successfully published Process Event');
            } else {
                for(Database.Error e : sr.getErrors()) {
                    System.debug('--- Failed to publish Process Event with Error: ' +
                                e.getStatusCode() +
                                ' - ' +
                                e.getMessage());
                    throw new CustomException(e.getMessage());
                }
            }       
        }
    }
}