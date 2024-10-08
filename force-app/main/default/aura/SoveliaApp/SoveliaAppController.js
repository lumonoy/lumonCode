({
	doInit : function(component, evt, helper) {
        window.addEventListener("message", (event) => {
            console.log('--- SoveliaApp -  event: ' + event.data);
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
		}, false);

        var pageReference = component.get("v.pageReference");
		console.log('--- SoveliaApp -  pageReference: ' + pageReference);
		var recId = pageReference.state.c__recId;

		var action;
		if (recId.startsWith("006")) {
			action = component.get("c.getStartupParams");
  		} else {
			action = component.get("c.getStartupParamsFromConfiguration");
    	}
		action.setParams({"recordId": recId});
		action.setCallback(this, function(resp){
			if(resp.getState() === "SUCCESS") {
				var resp = resp.getReturnValue();
                console.log('--- SoveliaApp -  parameters: ' + resp);
				component.set("v.canvasParameters", resp);
//				window.postMessage('test mess');
			} else {
				  var toastEvent = $A.get("e.force:showToast");
				  toastEvent.setParams({
					  type : 'error',
					  message: 'Error occured! Please contact admin.'
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
})