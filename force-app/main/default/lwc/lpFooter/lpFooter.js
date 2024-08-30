import {LightningElement, track} from 'lwc';
import PORTAL_LANGUAGE from '@salesforce/i18n/lang';
import fetchFooterData from '@salesforce/apex/LP_Footer.fetchFooterData';
import {NavigationMixin} from "lightning/navigation";
import {footerLabels, errorLabels} from "c/lpLabels";
import {showToast} from "c/lpUtils";
import {navigateToExternalUrl} from "c/lpUtils";
import {reduceErrors} from "c/lpUtils";

export default class LpFooter extends NavigationMixin(LightningElement) {

	footerLabels = footerLabels;
	errorLabels = errorLabels;
	@track mainFooterSections = [];
	footerSocials = [];
	footerPolicyLink = '';
	footerPolicyLabel = '';
	displaySocialSection = false;
	isRendered = false;

	get currentYear(){
		return new Date().getFullYear();
	}

	get portalLanguage() {
		return PORTAL_LANGUAGE;
	}

	renderedCallback() {
		if(this.isRendered){
			return;
		}
		this.isRendered = true;
		this.getFooterData();
	}

	async getFooterData() {
		try {
			const footerData = JSON.parse(await fetchFooterData({portalLanguage: this.portalLanguage}));
			this.assignFooterSectionLabels(footerData);
			this.displaySocialSection = this.footerSocials[0]?.footerLinks.length > 0;
		} catch (e) {
			console.log('ERROR getFooterData ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	assignFooterSectionLabels(footerData){
		for (let fData of footerData) {
			if (fData?.isMainSection) {
				if (fData?.name.toUpperCase() === 'RESIDENTIAL') {
					fData.labelSection = this.footerLabels.residential;
				}
				if (fData?.name.toUpperCase() === 'COMPANY') {
					fData.labelSection = this.footerLabels.company;
				}
				this.mainFooterSections.push(fData);
			}
			if (fData?.name.toUpperCase() === 'SOCIAL') {
				fData.labelSection = this.footerLabels.followUs;
				this.footerSocials.push(fData);
			}
			if (fData?.name.toUpperCase() === 'PRIVACY' && fData?.footerLinks.length > 0) {
				this.footerPolicyLink = fData.footerLinks[0].url;
				this.footerPolicyLabel = fData.footerLinks[0].label;
			}
		}
	}

	handlePolicyLinkClick(event) {
		event.stopPropagation();
		event.preventDefault();
		navigateToExternalUrl(this, this.footerPolicyLink);
	}
}