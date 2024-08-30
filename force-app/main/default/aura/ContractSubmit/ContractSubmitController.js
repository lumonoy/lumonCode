/**
 * Created by Konrad Niewiadomski on 02.12.2022.
 */

({
    doInit : function(component, evt, helper) {
		var recId = component.get("v.recordId");

		var action = component.get("c.submitContract");
		action.setParams({"recordId": recId});
		action.setCallback(this, function(resp){
			if(resp.getState() === "SUCCESS") {
			    var resp = resp.getReturnValue();
                let respData = JSON.parse(resp);
                //let msg = respData["message"];
                console.log('*** msg ***'+respData);
				var toastEvent = $A.get("e.force:showToast");
				  toastEvent.setParams({
					  type : 'success',
					  message: 'Contract submitted!'
				  });
				  toastEvent.fire();
				  $A.get("e.force:closeQuickAction").fire();
			} else {
                  var errorResp = resp.getReturnValue();
                  let errorRespData = JSON.parse(errorResp);
                  //let errormsg = errorRespData["message"];
                  console.log('*** errormsg ***'+errorResp);
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