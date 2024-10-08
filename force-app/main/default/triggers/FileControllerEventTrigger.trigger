trigger FileControllerEventTrigger on FileControllerEvent__e (after insert) {
    System.debug('--- FileControllerEventTrigger - Event after Insert');
    FileControllerEventTriggerHandler.executeAction(Trigger.new);
}