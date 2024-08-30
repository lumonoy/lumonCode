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
	}
});