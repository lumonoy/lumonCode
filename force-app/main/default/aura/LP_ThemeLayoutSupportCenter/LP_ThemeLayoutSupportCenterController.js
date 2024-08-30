({
	onRender : function(cmp) {
		const utilComponent = cmp.find("util");
		const bgImgUrl = utilComponent.getMainBannerBG();
		cmp.set('v.backgroundImageURL', bgImgUrl);
	},
	handleMyAccountClick: function(cmp, event){
		event.preventDefault();
		const utilComponent = cmp.find("util");
		utilComponent.navigateToMyAccountPage();
	},
	handleBurgerClick : function(cmp){
		let bodyWrapper = cmp.find("bodyWrapper").getElement();
		bodyWrapper.classList.toggle('toggle-burger');
	},
	handleSetActiveSection: function (cmp, event) {
		event.stopPropagation();
		event.preventDefault();
		let buttons = ['cases', 'faq', 'documentation', 'productDetails'];
		for(let button of buttons){
			$A.util.removeClass(cmp.find(button), "active-button");
		}

		let clickedAccordion = event.currentTarget.dataset.id;
		if(clickedAccordion === 'faq'){
			const faqURL = $A.get("$Label.c.LP_FAQ_Url");

			const utilComponent = cmp.find("util");
			utilComponent.navigateToExternalPage(faqURL);
			return;
		}
		cmp.find("accordion").set('v.activeSectionName', clickedAccordion);
		let accBtn = cmp.find(clickedAccordion);
		$A.util.addClass(accBtn, "active-button");
	},
	handleSectionToggle : function(cmp, event){
		let openSections = event.getParam('openSections');
		if(openSections[0] === 'faq'){
			const faqURL = $A.get("$Label.c.LP_FAQ_Url");
			const utilComponent = cmp.find("util");
			utilComponent.navigateToExternalPage(faqURL);
		}
	}
});