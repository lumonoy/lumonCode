/**
 * Created by Konrad Niewiadomski on 02.12.2022.
 */

({
    doInit : function(component, evt, helper) {
        component.set("v.showSpinner", true);
		var recId = component.get("v.recordId");
		var action = component.get("c.populateOrderJSONFromComponent");
		action.setParams({"recordId": recId});
		action.setCallback(this, function(resp){
			if(resp.getState() === "SUCCESS") {
			    var resp = resp.getReturnValue();
			    component.set("v.showSpinner", false);
			    if (resp == 'success') {
			    	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
						type : 'success',
						message: 'Order submitted!'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
       			} else {
       			    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
						type : 'error',
						message: resp
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
          		}
			} else {
			    component.set("v.showSpinner", false);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type : 'error',
					message: 'Error occured! Please contact admin.'
				});
				toastEvent.fire();
				$A.get("e.force:closeQuickAction").fire();
			}
		});
		$A.enqueueAction(action);
	}
});