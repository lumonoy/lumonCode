import { LightningElement,api } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import currentUserId from '@salesforce/user/Id';

export default class feedbackEventToastLWC extends LightningElement {
    @api toastKeys;
    @api toastTitle;
    @api toastMessage;
    @api toastVariant;
    @api toastMode;
    @api runInSystemMode;
    @api recordId;
    @api processing = false;
    channelName = '/event/FeedbackEvent__e';
    subscription = {};

    connectedCallback() {
        this.toastKeys = this.toastKeys ? this.toastKeys.split(',').map(key => key.trim()) : '';
        const ci = this;
        const toastCallback = function(response) {
            let toastData = response['data']['payload'];
            if(toastData) {
                toastData = ci.checkForNameSpace(toastData);
            }
            if(
                toastData &&
                toastData['Key__c'] &&
                ci.toastKeys.includes(toastData['Key__c']) &&
                (
                    ci.runInSystemMode ||
                    (toastData['CreatedById'] === currentUserId)
                ) &&
                (
                    toastData['RecordId__c'] && ci.recordId ? toastData['RecordId__c'] === ci.recordId : true
                )
            ) {
                const toastEvent = new ShowToastEvent({
                    title: toastData['Title__c'] ? toastData['Title__c'] : ci.toastTitle,
                    message: toastData['Message__c'] ? toastData['Message__c'] : ci.toastMessage,
                    variant: toastData['Variant__c'] ? toastData['Variant__c'] : ci.toastVariant,
                    mode: toastData['Mode__c'] ? toastData['Mode__c'] : ci.toastMode
                });
                console.log('*** '+this.message);
                this.processing = !this.processing;
                ci.dispatchEvent(toastEvent);
            }
        }
        subscribe(this.channelName, -1, toastCallback).then(response => {
            console.log('*** Subscribed to Feedback Event');
            this.subscription = response;
        });
        onError(error => {
            console.log('*** Error in Feedback Event');
            console.log(error);
        });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('Un-Subscribed from Feedback Event');
            console.log(response);
        });
    }
    checkForNameSpace(oldRecord) {
        let newRecord = {};
        for(let key in oldRecord) {
            if(key.includes('Message__c')) {
                newRecord['Message__c'] = oldRecord[key];
            } else if(key.includes('Variant__c')) {
                newRecord['Variant__c'] = oldRecord[key];
            } else if(key.includes('Mode__c')) {
                newRecord['Mode__c'] = oldRecord[key];
            } else if(key.includes('Title__c')) {
                newRecord['Title__c'] = oldRecord[key];
            } else if(key.includes('Key__c')) {
                newRecord['Key__c'] = oldRecord[key];
            } else if(key.includes('RecordId__c')) {
                newRecord['RecordId__c'] = oldRecord[key];
            } else {
                newRecord[key] = oldRecord[key];
            }
        }
        return newRecord;
    }
}