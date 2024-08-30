/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public class FeedbackEvent {
    @AuraEnabled
    public static Void PublishFeedbackEvent(String key, //Toast Message ID
                                            String recordId, //Eg Opportunity.Id
                                            String title, // Toast Title
                                            String message, //Message Body
                                            String mode, // dismissable, pester or sticky
											String variant //info , success, warning or error.
                                           ){
		List<FeedbackEvent__e> feedbackEvents = new List<FeedbackEvent__e>();
		feedbackEvents.add(new FeedbackEvent__e(recordId__c=recordId, 
                                               Key__c=key, 
                                               Title__c=title,
                                               Message__c=message,
                                               Mode__c=mode,
                                               Variant__c=variant)); 
        System.debug('--- FeedbackEvent - Preparing published event.');  

        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(feedbackEvents);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('--- FeedbackEvent - Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('--- FeedbackEvent - Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
    }
}