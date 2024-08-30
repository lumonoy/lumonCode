import { LightningElement, api } from 'lwc';
import getContent from '@salesforce/apex/LP_ManagedContent.getContent';
import basePath from '@salesforce/community/basePath';
import PORTAL_LANGUAGE from '@salesforce/i18n/lang';
import {NavigationMixin} from "lightning/navigation";
import {showToast} from "c/lpUtils";
import {reduceErrors} from "c/lpUtils";
import {navigateToExternalUrl} from "c/lpUtils";
import {errorLabels} from "c/lpLabels";

export default class LpCmsCallToActionBlock extends NavigationMixin(LightningElement) {
	@api contentId;
	@api height;
	portalLanguage = PORTAL_LANGUAGE;
	ctaText = '';
	title = '';
	cmsItemStyle = '';
	buttonLabel = '';
	buttonUrl = '';
	isRendered = false;
	displayCmsContent = false;
	errorLabels = errorLabels;


	async renderedCallback() {
		if(this.isRendered){
			return;
		}
		this.isRendered = true;
		this.getCmsContent();
	}

	setCmsContentData(data){
		this.title = data?.Title?.value;
		this.ctaText = data?.CTA_Text?.value;
		this.buttonUrl = data?.Button_Url?.value;
		this.buttonLabel = data?.Button_Label?.value;
		const imgUrl = basePath + '/sfsites/c' + data?.Background_Image?.url;
		this.cmsItemStyle = 'background:linear-gradient(0deg, rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.3)),' +
							' url('+imgUrl+') 50% no-repeat; min-height: ' + this.height + 'px;';
		this.displayCmsContent = true;
	}

	async getCmsContent(){
		let portalLang = this.portalLanguage ? this.portalLanguage.replace('-','_') : 'en_US';
		try {
			const data = await getContent({
				contentId: this.contentId,
				page: 0,
				pageSize: 1,
				language: portalLang,
				filterBy: ''
			});
			this.setCmsContentData(data);
		}catch (e){
			console.log('ERROR getCmsContent ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	handleButtonClick(event) {
		event.stopPropagation();
		event.preventDefault();
		navigateToExternalUrl(this, this.buttonUrl);
	}
}