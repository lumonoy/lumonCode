import {LightningElement, api} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class LpFooterLink extends NavigationMixin(LightningElement) {
	@api link;
	@api linkClass;

	get isSocialLink() {
		return this.link?.socialIcon !== null
	}

	handleFooterLinkClick(event) {
		event.stopPropagation();
		event.preventDefault();
		this.navigateToExternalUrl(this.link.url);
	}

	navigateToExternalUrl(link) {
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__webPage',
			attributes: {
				url: link
			},
		}).then(url => {
			window.open(url, "_blank");
		});
	}
}