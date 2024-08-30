({
	handleMyAccountClick: function(cmp, event){
		event.preventDefault();
		const utilComponent = cmp.find("util");
		utilComponent.navigateToMyAccountPage();
	},
	handleBurgerClick : function(cmp){
		let bodyWrapper = cmp.find("bodyWrapper").getElement();
		bodyWrapper.classList.toggle('toggle-burger');
	},
});