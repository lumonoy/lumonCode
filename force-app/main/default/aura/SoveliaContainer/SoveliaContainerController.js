/**
 * Created by Konrad Niewiadomski on 14.11.2022.
 */

({
    doInit : function(component, evt, helper) {
        window.addEventListener("message", (event) => {
            console.log('!! event: ' + event.data);
            if (event.data.indexOf('closeSovelia') != -1) {
                var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type : 'success',
					message: 'App will be closed...'
				});
				toastEvent.fire();
				window.setTimeout(
					$A.getCallback(function () {
						var win = window.open("","_self");
						win.close();
					}),
					1000
				);
            }
			if (event.data.substring(0,1) == ':') {
                window.location.href = event.data.substring(1);
            }
		}, false);

		var pageReference = component.get("v.pageReference");
		var recId = pageReference.state.c__recId;
		console.log("recId", recId);
		var action = component.get("c.getRVN");
		action.setParams({"recordId": recId});
		action.setCallback(this, function(resp){
			if(resp.getState() === "SUCCESS") {
				var retVal = resp.getReturnValue();
				if (retVal.errorMessage) {
					console.log(retVal.errorMessage);
				    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type : 'error',
						message: retVal.errorMessage
					});
					toastEvent.fire();
				    return;
    			}

				if (!retVal.rvn) {
				    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type : 'error',
						message: 'RVN not populated correctly!'
					});
					toastEvent.fire();
					return;
    			}
				var isNew = !retVal.configurationProductId;
    			console.log('!!! Params to be sent to blinds: ' + JSON.stringify({
					opportunityId: retVal.opportunityId,
					rvn: retVal.rvn,
					new: isNew
				}));
				component.set("v.canvasParameters", JSON.stringify({
					opportunityId: retVal.opportunityId,
					rvn: retVal.rvn,
					new: isNew
				}));
			} else {
				console.log(JSON.stringify(resp.getError()));
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type : 'error',
					message: 'Error occured! Please contact admin.' + JSON.stringify(resp.getError())
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},

	closePage : function() {
		var win = window.open("","_self");
        win.close();
 	}
});