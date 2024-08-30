/**
 * Created by Konrad Niewiadomski on 21.10.2022.
 */

({
    doInit : function(component, evt, helper) {
		if (component.get("v.recordId")) {
			console.log('*** recordId '+component.get("v.recordId"));
		} else {
			var pageRef = component.get("v.pageReference");
			alert(JSON.stringify(pageRef));
			var state = pageRef.state; // state holds any query params
			var base64Context = state.inContextOfRef;
			// For some reason, the string starts with "1.", if somebody knows why,
			// this solution could be better generalized.
			if (base64Context.startsWith("1\.")) {
				base64Context = base64Context.substring(2);
			}
			var addressableContext = JSON.parse(window.atob(base64Context));
			console.log('*** recordId from url '+addressableContext.attributes.recordId);
			component.set("v.recordId", addressableContext.attributes.recordId);		
		}
		var recId = component.get("v.recordId");
		var action = component.get("c.checkContractStatus");
		action.setParams({
			recordId: recId
		});
		action.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {
				var result = response.getReturnValue();
				if (result) {
				    var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
						type : 'error',
						message: 'Contract is already signed! Cannot create new plan.'
					});
					toastEvent.fire();
					$A.get("e.force:closeQuickAction").fire();
				} else {
				    var pageReference = {
						type: 'standard__component',
						attributes: {
							componentName: 'c__VisualApp'
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
    			}
			}
		});
		$A.enqueueAction(action);
	}
});