import {LightningElement, wire, track} from 'lwc';
import USER_ID from '@salesforce/user/Id';
import USER_CONTACT_ID from '@salesforce/schema/User.ContactId';
import fetchMyAccountDetails from '@salesforce/apex/LP_MainController.fetchMyAccountDetails';
import getVFOrigin from '@salesforce/apex/LP_ChangePasswordCtrl.getVFOrigin';
import updateAccount from '@salesforce/apex/LP_MainController.updateAccount';
import {getRecord} from "lightning/uiRecordApi";
import {showToast, reduceErrors, logoutUser} from "c/lpUtils";
import {myAccountLabels, marketingLabels, errorLabels} from "c/lpLabels";
import {NavigationMixin} from "lightning/navigation";

export default class LpMyAccountDetails extends NavigationMixin(LightningElement){

	activeSectionName = 'general';
	accEmail = '';
	accId = '';

	contactId = null;
	emailOptIn = false;
	smsOptIn = false;
	isRendered = false;

	changePasswordLoading;
	isModalOpened;
	maintenanceTips;
	discountNews;
	emailOptInChanged;
	smsOptInChanged;
	marketingSettingsChanged;

	myAccLabels = myAccountLabels;
	marketingLabels = marketingLabels;
	errorLabels = errorLabels;

	modalHeading = this.myAccLabels.changeMyPassword;
	accFieldLabelPairs = {
		FirstName : myAccountLabels.firstName,
		LastName  : myAccountLabels.lastName,
		PersonEmail : myAccountLabels.email,
		Phone : myAccountLabels.phone
	};
	userId = USER_ID;

	@track accDetailsMap = [];

	@wire(getVFOrigin)
	vfOrigin;

	@wire(getRecord, { recordId: '$userId', fields: [USER_CONTACT_ID]})
	userDetails({error, data}) {
		if(data){
			this.contactId = data.fields.ContactId.value;
			this.fetchMyAccountData();
		}else{
			console.log('ERROR wired userDetails ## ', reduceErrors(error));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	openChangePasswordModal(){
		this.changePasswordLoading = true;
		this.isModalOpened = true;
	}

	handleSetActiveSection(event){
		this.activeSectionName = event.target.dataset.id;
	}

	checkFieldType(field){
		return field.includes('PersonMailing');
	}

	async fetchMyAccountData(){
		try{
			const accData = await fetchMyAccountDetails({contactId : this.contactId});
			if(accData.length === 1){
				this.generateMyAccDetails(accData[0]);
			}
		}catch(e){
			console.log('ERROR fetchMyAccountData ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	generateMyAccDetails(accDetails){
		let address = '';
		this.accId = accDetails.Id;
		for (let key in accDetails) {
			if(accDetails.hasOwnProperty(key)){
				let isAddressField = this.checkFieldType(key);
				if(isAddressField){
					address += accDetails[key] + ', ';
				}
				if(!isAddressField && this.accFieldLabelPairs.hasOwnProperty(key)){
					this.accDetailsMap.push({key:this.accFieldLabelPairs[key], value:accDetails[key]});
				}
				if(key === 'PersonEmail'){
					this.accEmail = accDetails[key];
				}
				if(key === 'Email_Opt_In__pc'){
					this.emailOptIn = accDetails[key];
				}
				if(key === 'SMS_Opt_In__pc'){
					this.smsOptIn = accDetails[key];
				}
				if(key === 'New_products_and_services__pc'){
					this.maintenanceTips = accDetails[key];
				}
				if(key === 'Current_discounts__pc'){
					this.discountNews = accDetails[key];
				}
			}
		}
		this.accDetailsMap.push({key:myAccountLabels.address, value:address.slice(0, -2)});
		this.updateCheckBoxes();
	}

	updateCheckBoxes(){
		if(this.emailOptIn){
			this.template.querySelector('[data-id="yesEmail"]').checked = true;
		}else{
			this.template.querySelector('[data-id="noEmail"]').checked = true;
		}
		if(this.smsOptIn){
			this.template.querySelector('[data-id="yesSms"]').checked = true;
		}else{
			this.template.querySelector('[data-id="noSms"]').checked = true;
		}
	}
	handleModalClose(){
		this.isModalOpened = false;
	}
	renderedCallback() {
		if(this.isRendered){
			return true;
		}
		this.isRendered = true;
		this.updateCheckBoxes();
	}

	handleLogout(event) {
		event.stopPropagation();
		event.preventDefault();
		logoutUser(this);
	}

	handleSaveMarketingSettings(){
		this.updateMarketingFields();
	}

	handleMarketingMessages(event){
		if(event.target.value === 'yesEmail' || event.target.value === 'noEmail'){
			this.emailOptInChanged = true;
		}
		if(event.target.value === 'yesSms' || event.target.value === 'noSms'){
			this.smsOptInChanged = true;
		}
	}

	handleMarketingSetting(event){
		if(event.currentTarget.dataset.id === 'discountNews'){
			this.discountNews = event.target.checked;
		}
		if(event.currentTarget.dataset.id === 'maintenanceTips'){
			this.maintenanceTips = event.target.checked;
		}
		this.marketingSettingsChanged = true;
	}

	updateMarketingFields() {
		if(this.emailOptInChanged || this.smsOptInChanged || this.marketingSettingsChanged){
			this.updateData();
		}else{
			showToast(this, this.marketingLabels.noUpdateTitle, this.marketingLabels.noUpdateMsg, 'warning');
		}
	}

	async updateData(){
		try{
			const emailOptIn = this.template.querySelector('[data-id="yesEmail"]').checked;
			const smsOptIn = this.template.querySelector('[data-id="yesSms"]').checked;
			let account = {
				sobjectType : 'Account',
				Id : this.accId,
			};
			if(this.emailOptInChanged){
				account.Email_Opt_In__pc = emailOptIn;
				account.Email_Opt_In_Date_Time__pc = new Date();
			}
			if(this.smsOptInChanged){
				account.SMS_Opt_In__c = smsOptIn;
				account.SMS_Opt_In_Date_Time__pc = new Date();
			}
			if(!emailOptIn){
				account.PersonHasOptedOutOfEmail = true;
			}
			if(this.marketingSettingsChanged){
				account.New_products_and_services__pc = this.maintenanceTips;
				account.Current_discounts__pc = this.discountNews;
			}
			account.Marketing_Preference__pc = ((this.emailOptInChanged || this.smsOptInChanged) && (emailOptIn || smsOptIn));
			const response = await updateAccount({account  : account});
			if(response.status === 'success'){
				showToast(this, this.marketingLabels.successTitle, this.marketingLabels.successTitle, 'success', 'dismissible');
			}else{
				showToast(this, 'Error' , response.errorMessage, 'error', 'dismissible');
			}
		}catch(e){
			let errorMsgArr = reduceErrors(e);
			console.log('ERROR Saving My Account Fields ## ', errorMsgArr);
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}
}