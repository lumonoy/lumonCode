import {LightningElement, track, api} from 'lwc';
import { registerListener, unregisterAllListeners } from 'c/lpPubSub';
import {formatDateForUI} from "c/lpUtils";
import {navigateToCMSContentPage} from "c/lpUtils";
import {installationLabels} from "c/lpLabels";
import {NavigationMixin} from "lightning/navigation";
import LOCALE from "@salesforce/i18n/locale";
import bgImg from '@salesforce/resourceUrl/LP_Upcoming_Installation';

export default class LpUpcomingInstallation extends NavigationMixin(LightningElement) {

	orderId;
	installationLabels = installationLabels;

	@api contentKey;
	@track upcomingInstallation = {
		date : '',
		time : '',
        comment : '',
	};

	get bgStyle(){
		return 'background-image:url("'+bgImg+'");'
	}

	connectedCallback(){
		registerListener('selectedOrder', this.displaySelectedOrder, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	displaySelectedOrder(orderDataSTR){
		this.setInstallationData(orderDataSTR);
	}

	setInstallationData(orderDataSTR){
        const orderData = JSON.parse(orderDataSTR);
		let uIData = JSON.parse(orderData?.installationDataSTR);
		if(uIData?.iDate){
			this.upcomingInstallation.date = formatDateForUI(uIData.iDate);
			const dateTime = new Date(uIData.iDate);
			this.upcomingInstallation.time = isNaN(dateTime.getTime()) ? '' : dateTime.toLocaleTimeString(LOCALE, {timeStyle: 'short'});
		}
        this.upcomingInstallation.comment = uIData?.iComment;
    }

	handleInstallationPreparationClick(event){
		event.stopPropagation();
		event.preventDefault();
		navigateToCMSContentPage(this, 'Documentation', this.contentKey);
	}
}