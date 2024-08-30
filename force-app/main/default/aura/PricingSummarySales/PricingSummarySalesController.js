/**
 * Created by Konrad Niewiadomski on 16.02.2023.
 */

({
	init: function (cmp, event, helper) {
		var recId = cmp.get("v.recordId");
		var action = cmp.get("c.getQuoteLineData");
		action.setParams({"recordId": recId});
		action.setCallback(this, function(resp){
			if(resp.getState() === "SUCCESS") {
				var resp = resp.getReturnValue();
				cmp.set('v.records', resp.products);
				cmp.set("v.summaryPd", resp.summaryProduct);
				cmp.set("v.summaryPdVAT", resp.summaryProductWithVAT);
			} else {
				alert('Error: ' + resp.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	toggleSection : function(component, event, helper) {
		var sectionAuraId = event.target.getAttribute("data-auraId");		
		var fullClassName = sectionAuraId + 'parnt';
		const collapsedDiv = document.getElementsByClassName(fullClassName);
		const expandedDiv = document.getElementsByClassName(fullClassName+'Hide');

		if (collapsedDiv[0].style.display == '') {
		    collapsedDiv[0].style.display = 'none';
		    expandedDiv[0].style.display = '';
  		} else {
  		    collapsedDiv[0].style.display = '';
			expandedDiv[0].style.display = 'none';
			var childRows = document.getElementsByClassName('expanded');
			var childRowsCollapsed = document.getElementsByClassName('collapsed');
			if (childRows) {
			    for (var ex = 0; ex < childRows.length; ex++) {
			        childRows[ex].style.display = 'none';
       			}
   			}
   			if (childRowsCollapsed) {
				for (var co = 0; co < childRowsCollapsed.length; co++) {
					childRowsCollapsed[co].style.display = '';
				}
			}
		}
		var currentVal = event.target.id;
		var lst = document.getElementsByClassName(sectionAuraId);        
		 for(var i = 0; i < lst.length; ++i) {
             if(lst[i].className != sectionAuraId ){
                 lst[i].style.display = 'none';
             }else{
                 if (lst[i].style.display == 'none' ) {
                    lst[i].style.display = '';
                } else {
                    lst[i].style.display = 'none';
                }
             }
		   
		}
	},

	toggleSectionChild : function(component, event, helper) {
		var sectionAuraId = event.target.getAttribute("data-auraId");
		var fullClassName = sectionAuraId + 'child';
		const collapsedDiv = document.getElementsByClassName(fullClassName);
		const expandedDiv = document.getElementsByClassName(fullClassName+'Hide');

		if (collapsedDiv[0].style.display == '') {
			collapsedDiv[0].style.display = 'none';
			expandedDiv[0].style.display = '';
		} else {
			collapsedDiv[0].style.display = '';
			expandedDiv[0].style.display = 'none';
		}

		var lst = document.getElementsByClassName(sectionAuraId);
		for(var i = 0; i < lst.length; ++i) {
			if (lst[i].style.display == 'none') {
				lst[i].style.display = '';
			} else {
				lst[i].style.display = 'none';
			}
		}
	}
});