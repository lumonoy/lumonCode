/**
 * Created by Henk Reynders on 29.01.2023.
 */
// Trigger for catching Configuration  Events.
trigger ConfigurationEventTrigger on ConfigurationEvent__e (after insert) {
            System.debug('Configuration Event after Insert: ' + Trigger.new);
            ConfigurationEventTriggerHandler.processConfiguration(Trigger.new);
}