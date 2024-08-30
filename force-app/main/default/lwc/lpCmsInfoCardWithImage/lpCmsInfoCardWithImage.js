import { LightningElement, api } from 'lwc';
import getContent from '@salesforce/apex/LP_ManagedContent.getContent';
import basePath from '@salesforce/community/basePath';
import PORTAL_LANGUAGE from '@salesforce/i18n/lang';
import {NavigationMixin} from "lightning/navigation";
import {showToast} from "c/lpUtils";
import {reduceErrors} from "c/lpUtils";
import {navigateToExternalUrl} from "c/lpUtils";
import {errorLabels} from "c/lpLabels";


export default class LpCmsInfoCardWithImage extends NavigationMixin(LightningElement) {
	@api imgPosition;
	@api contentId;
	imgUrl;
	infoText;
	title;
	buttonLabel;
	buttonUrl;
	isRendered;
	errorLabels = errorLabels;

	get contentLayout() {
		return this.imgPosition.trim().toLowerCase() === 'left' ?
			'flex-direction:row;' :
			'flex-direction: row-reverse;';
	}

	get portalLanguage() {
		return PORTAL_LANGUAGE;
	}

	renderedCallback() {
		if (this.isRendered) {
			return;
		}
		this.isRendered = true;
		this.getCmsContent();
	}

	async getCmsContent() {
		try {
			const data = await getContent({
				contentId: this.contentId,
				page: 0,
				pageSize: 1,
				language: this.portalLanguage.trim().replace('-', '_'), // TODO check language why replace used
				filterBy: ''
			});
			this.title = data.Title.value;
			this.infoText = data.Text_Content.value;
			this.buttonUrl = data.Button_Url.value;
			this.buttonLabel = data.Button_Label.value;
			this.imgUrl = basePath + '/sfsites/c' + data.Image.url;
		} catch (e) {
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