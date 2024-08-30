// Trigger for catching Feedback Events.
trigger FeedbackEventTrigger on FeedbackEvent__e (after insert) {
     System.debug('Feedback Event after Insert: ' + Trigger.new);
}