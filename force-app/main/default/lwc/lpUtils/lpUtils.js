import {LightningElement, api} from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DEFAULT_BANNER from '@salesforce/resourceUrl/LP_Banner_Default';
import SUPPORT_CENTER_BANNER from '@salesforce/resourceUrl/LP_Banner_Support_Center';
import MY_ORDERS_BANNER from '@salesforce/resourceUrl/LP_Banner_My_Orders';
import LOGIN_BANNER from '@salesforce/resourceUrl/LP_Banner_Login';
import {NavigationMixin} from "lightning/navigation";
import LOCALE from '@salesforce/i18n/locale';
import estimatedDateStr from '@salesforce/label/c.LP_Order_Path_Estimated';

export default class LpUtils extends NavigationMixin(LightningElement) {

	@api getMainBannerBG(pageName){
		let banner;
		switch (pageName) {
			case 'SupportCenter':
				banner = SUPPORT_CENTER_BANNER;
				break;
			case 'myOrders':
				banner = MY_ORDERS_BANNER;
				break;
			case 'login':
				banner = LOGIN_BANNER;
				break;
			default:
				banner = DEFAULT_BANNER;
		}
		return banner;
	}

	@api navigateToMyAccountPage(){
		this.navigateToPage('comm__namedPage', 'my-account');
	}

	@api navigateToExternalPage(link){
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__webPage',
			attributes: {
				url: link
			},
		}).then(url => {
			window.open(url, "_blank");
		});
	}

	navigateToPage(type, name) {
		this[NavigationMixin.Navigate]({
			type: type,
			attributes: {
				pageName: name
			},
		})
	}
}

export function navigateToExternalUrl(context, link){
	context[NavigationMixin.GenerateUrl]({
		type: 'standard__webPage',
		attributes: {
			url: link
		},
	}).then(url => {
		window.open(url, "_blank");
	});
}

export function navigateToOrderDetailPage(context, pageName, recordId){
	context[NavigationMixin.Navigate]({
		type: 'comm__namedPage',
		attributes: {
			pageName: pageName
		},
		state:{
			orderId : recordId
		}
	})
}

export function navigateToCMSContentPage(context, contentType, contentKey) {
	context[NavigationMixin.Navigate]({
		type: 'standard__managedContentPage',
		attributes: {
			'contentTypeName': contentType,
			'contentKey': contentKey
		},
	})
}

export function logoutUser(context){
	context[NavigationMixin.Navigate]({
		type: 'comm__loginPage',
		attributes: {
			actionName: 'logout'
		}
	});
}

export function showToast(context, title, message, variant = "success", mode = "dismissible") {
	context.dispatchEvent(
		new ShowToastEvent({
			title,
			message,
			variant,
			mode
		})
	);
}
export function formatDateForUI(dateSTR){
	const parsedDateStr = parseFormattedDateStr(dateSTR);
	const formattedDate = formatDateToUserLocale(parsedDateStr);
	if(formattedDate === ''){
		return '';
	}
	return dateSTR.toLowerCase().includes('est') ? estimatedDateStr + ' ' + formattedDate : formattedDate;
}

function parseFormattedDateStr(baseDateSTR){
	let parsedDateStr = null;
	if(baseDateSTR.toLowerCase().includes('est :')){
		let baseDateArr = baseDateSTR.split(' ');
		if(baseDateArr.length >= 3){
			parsedDateStr = baseDateArr[2];
		}
	}
	return parsedDateStr ? parsedDateStr : baseDateSTR;
}
function formatDateToUserLocale(dateSTR) {
	const date = new Date(dateSTR);
	if(isNaN(date.getTime())){
		return '';
	}
	const options = {
		weekday : "long",
		year    : "numeric",
		month   : "short",
		day     : "numeric",
	};
	return new Intl.DateTimeFormat(LOCALE, options).format(date);
}

export function reduceErrors(errors) {
	if (!Array.isArray(errors)) {
		errors = [errors];
	}
	return (
		errors
			// Remove null/undefined items
			.filter((error) => !!error)
			// Extract an error message
			.map((error) => {
				// UI API read errors
				if (Array.isArray(error.body)) {
					return error.body.map((e) => e.message);
				}
				// Page level errors
				else if (
					error?.body?.pageErrors &&
					error.body.pageErrors.length > 0
				) {
					return error.body.pageErrors.map((e) => e.message);
				}
				// Field level errors
				else if (
					error?.body?.fieldErrors &&
					Object.keys(error.body.fieldErrors).length > 0
				) {
					const fieldErrors = [];
					Object.values(error.body.fieldErrors).forEach(
						(errorArray) => {
							fieldErrors.push(
								...errorArray.map((e) => e.message)
							);
						}
					);
					return fieldErrors;
				}
				// UI API DML page level errors
				else if (
					error?.body?.output?.errors &&
					error.body.output.errors.length > 0
				) {
					return error.body.output.errors.map((e) => e.message);
				}
				// UI API DML field level errors
				else if (
					error?.body?.output?.fieldErrors &&
					Object.keys(error.body.output.fieldErrors).length > 0
				) {
					const fieldErrors = [];
					Object.values(error.body.output.fieldErrors).forEach(
						(errorArray) => {
							fieldErrors.push(
								...errorArray.map((e) => e.message)
							);
						}
					);
					return fieldErrors;
				}
				// UI API DML, Apex and network errors
				else if (error.body && typeof error.body.message === 'string') {
					return error.body.message;
				}
				// JS errors
				else if (typeof error.message === 'string') {
					return error.message;
				}
				// Unknown error shape so try HTTP status text
				return error.statusText;
			})
			// Flatten
			.reduce((prev, curr) => prev.concat(curr), [])
			// Remove empty strings
			.filter((message) => !!message)
	);
}