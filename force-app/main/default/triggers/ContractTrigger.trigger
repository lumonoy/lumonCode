/**
 * Created by Konrad Niewiadomski on 02.11.2022.
 */

trigger ContractTrigger on Contract (before insert, before update, after insert, after update) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {

		}
	} else if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			ContractTriggerHandler.populateJSON(Trigger.new, null, true);
		} else if (Trigger.isUpdate) {
			ContractTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap, true);
		}
	}
}