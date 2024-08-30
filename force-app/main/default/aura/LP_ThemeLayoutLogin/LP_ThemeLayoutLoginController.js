({
	onRender : function(cmp) {
		const utilComponent = cmp.find("util");
		const bgImgUrl = utilComponent.getMainBannerBG('login');
		cmp.set('v.backgroundImageURL', bgImgUrl);
		cmp.set('v.backgroundHeight', (window.innerHeight - 60));
	},
});