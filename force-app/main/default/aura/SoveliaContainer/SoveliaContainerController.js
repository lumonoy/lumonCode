/**
 * Created by Konrad Niewiadomski on 14.11.2022.
 */

({
    doInit : function(component, evt, helper) {
        window.addEventListener("message", (event) => {
            console.log('--- SoveliaContainer - Event: ' + event.data);
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
					console.error('--- SoveliaContainer - Error: '+retVal.errorMessage);
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
					console.error('--- SoveliaContainer - Error: Missing RVN');
					toastEvent.setParams({
						type : 'error',
						message: 'RVN not populated correctly!'
					});
					toastEvent.fire();
					return;
    			}
				var isNew = !retVal.configurationProductId;
    			console.info('--- SoveliaContainer - Canvas Params to be sent to Sovelia: ' + JSON.stringify({
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
				console.error('--- SoveliaContainer - Error: '+SON.stringify(resp.getError())); 
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
		console.log('--- SoveliaContainer - Closing Tab'); 
		var win = window.open("","_self");
        win.close();
 	}
	    
});