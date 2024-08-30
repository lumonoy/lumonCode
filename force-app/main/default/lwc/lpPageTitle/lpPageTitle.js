import {api, LightningElement} from 'lwc';
import {bannerTitles} from "c/lpLabels";

export default class LpPageTitle extends LightningElement {
	labels = bannerTitles;
	@api title;
	pageTitle = '';
	pageSubTitle = '';

	connectedCallback() {
		const modifiedTitle = this.title.trim().replaceAll(' ', '_');
		this.pageSubTitle = modifiedTitle === 'Home' ? this.labels.Sub_Title_Home : this.labels.Sub_Title;
		this.pageTitle = this.labels[modifiedTitle];
	}
}