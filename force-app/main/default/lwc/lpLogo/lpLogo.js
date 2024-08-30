import { LightningElement } from 'lwc';
import MAIN_LOGO from '@salesforce/resourceUrl/LP_MainLogo';
import {NavigationMixin} from "lightning/navigation";

export default class LpLogo extends NavigationMixin(LightningElement) {
	logo = MAIN_LOGO;
	handleClick(event) {
		event.stopPropagation();
		event.preventDefault();
		this[NavigationMixin.Navigate]({
			type: 'comm__namedPage',
			attributes: {
				pageName: 'home'
			}
		});
	}
}