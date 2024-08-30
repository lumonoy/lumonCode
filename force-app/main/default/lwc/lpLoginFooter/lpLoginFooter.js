import {LightningElement} from 'lwc';
import {cookieLabels, loginLabels} from "c/lpLabels";
import {navigateToExternalUrl} from "c/lpUtils";
import {NavigationMixin} from "lightning/navigation";

export default class LpLoginFooter extends NavigationMixin(LightningElement) {
	cookieLabels = cookieLabels;
	loginLabels = loginLabels;
	navigateBackToWeb(event) {
		event.stopPropagation();
		event.preventDefault();
		navigateToExternalUrl(this, this.loginLabels.backToWebSiteUrl);
	}
}