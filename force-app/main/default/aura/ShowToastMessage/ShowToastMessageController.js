({    invoke : function(component, event, helper) {
	var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": component.get("v.Title"),
        "message": component.get("v.Message"),
        "type": component.get("v.Type")
    });
    toastEvent.fire();
}})