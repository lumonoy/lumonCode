/**
 * Created by Konrad Niewiadomski on 21.08.2023.
 */

({
    doInit : function(component, evt, helper) {
		var recId = component.get("v.recordId");
		var pageReference = {
			type: 'standard__component',
			attributes: {
				componentName: 'c__SoveliaContainer'
			},
			state: {
				c__recId: component.get("v.recordId")
			}
		};
		component.set("v.pageReference", pageReference);
		const navService = component.find('navService');
		const pageRef = component.get('v.pageReference');
		const handleUrl = (url) => {
			window.open(url);
			console.log(component.get("v.recordId"))
		};
		const handleError = (error) => {
			console.log(error);
		};
		navService.generateUrl(pageRef).then(handleUrl, handleError);
		$A.get("e.force:closeQuickAction").fire();
//		var action = component.get("c.checkContractStatus");
//		action.setParams({
//			recordId: recId
//		});
//		action.setCallback(this, function (response) {
//			if (response.getState() === "SUCCESS") {
//				var result = response.getReturnValue();
//				if (result) {
//				    var toastEvent = $A.get("e.force:showToast");
//						toastEvent.setParams({
//						type : 'error',
//						message: 'The contract is already signed! Cannot create a new plan.'
//					});
//					toastEvent.fire();
//					$A.get("e.force:closeQuickAction").fire();
//				} else {
//
//    			}
//			}
//		});
//		$A.enqueueAction(action);
	}
});