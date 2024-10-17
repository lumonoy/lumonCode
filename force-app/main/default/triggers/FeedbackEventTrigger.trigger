/**
 * @description       : NOT USED for UI Feedback Toast
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/

trigger FeedbackEventTrigger on FeedbackEvent__e (after insert) {
     //System.debug('Feedback Event after Insert: ' + Trigger.new);
}