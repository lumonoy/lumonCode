import {api, LightningElement} from 'lwc';
import {orderProgress} from "c/lpLabels";
import {formatDateForUI} from "c/lpUtils";

export default class LpMyOrderProgress extends LightningElement {
	progressLabels = orderProgress;
	isDelivered = false;
	orderProgressData = [];
	orderProgressBar = 0;
	progressBarStyle = '';

	@api get orderProgressDates(){
		return this.orderProgressData;
	}

	set orderProgressDates(datesSTR){
		this.orderProgressData = this.generateOrderProgressDates(datesSTR);
		this.setProgressBarStyle();
	}

	connectedCallback() {
		window.addEventListener('resize', this.setProgressBarStyle.bind(this));
	}

	disconnectedCallback() {
		window.removeEventListener('resize', this.setProgressBarStyle);
	}

	setProgressBarStyle(){
		let windowWidth =  window.innerWidth;
		let widthOrHeight = windowWidth <= 767 ? 'height: ' : 'width: ';
		this.progressBarStyle = widthOrHeight + this.orderProgressBar + '%';
	}

	createProgressMap(){
		const progressMap = new Map();
		progressMap.set('orderDate', {label : this.progressLabels.orderOrdered, value : null, cssClass : 'icon-checked'});
		progressMap.set('deliveryDate', {label : this.progressLabels.orderDelivery, value : null, cssClass : 'icon-checked is-active'});
		progressMap.set('installDate', {label : this.progressLabels.orderInstallationStart, value : null, cssClass : 'icon-checked is-disabled'});
		return progressMap;
	}

	generateOrderProgressDates(datesStr){
		let datesParsed = JSON.parse(datesStr);
		const orderProgressDatesMap = this.createProgressMap();
		for (const dateKey in datesParsed){
			if(orderProgressDatesMap.has(dateKey) && datesParsed[dateKey]) {
                orderProgressDatesMap.get(dateKey).value = formatDateForUI(datesParsed[dateKey]);
				orderProgressDatesMap.get(dateKey).cssClass = this.generateCssClass(dateKey, datesParsed[dateKey]);
			}
		}
		this.orderProgressBar = this.calculateProgress([...orderProgressDatesMap.values()]);
		return [...orderProgressDatesMap.values()];
	}
	generateCssClass(dateFieldApi, dateFieldValue){
		const isPastOrToday = this.isPastDateOrToday(dateFieldValue);
		if(dateFieldApi === 'orderDate' && dateFieldValue){
			return 'icon-checked is-done';
		}
		if(dateFieldApi === 'deliveryDate' && dateFieldValue) {
			this.isDelivered = isPastOrToday;
			return this.setProgressStateCss(isPastOrToday);
		}
		if(dateFieldApi === 'installDate' && dateFieldValue) {
			return !!this.isDelivered ? 'icon-checked is-disabled' : this.setProgressStateCss(isPastOrToday);
		}
		return 'icon-checked is-disabled'
	}

	isPastDateOrToday(dateSTR) {
		const today = new Date();
		const dateToCheck = new Date(dateSTR);
		return dateToCheck <= today;
	}

	setProgressStateCss(isTodayOrBeforeDate){
		return isTodayOrBeforeDate ? 'icon-checked is-done' : 'icon-checked is-active';
	}

	calculateProgress(orderProgress){
		let progressCount = 0;
		for(let oP of orderProgress){
			if(oP.cssClass.includes('is-done')){
				progressCount++;
			}
		}
		if(progressCount === 1){
			return 50;
		}
		if(progressCount === 2 || progressCount === 3){
			return 100;
		}
		return progressCount;
	}
}