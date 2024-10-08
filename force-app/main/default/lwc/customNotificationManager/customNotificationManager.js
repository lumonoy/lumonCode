import { LightningElement, api, track } from 'lwc';
import notifyUsers from '@salesforce/apex/CustomNotificationController.notifyUsers';
import getNotificationList from '@salesforce/apex/CustomNotificationController.getNotificationList';

export default class CustomNotificationManager extends LightningElement {
    @track notificationOptions = [];
    showNotificationTypePicklist = false; 

    //fired on load of the component
    connectedCallback(){
        this.notificationJson.targetId = this.recordId;
        //get all the notification type
        getNotificationList()
        .then((result) => {
            result.forEach(element => {
                this.notificationOptions.push({label: element.CustomNotifTypeName, value: element.Id});
            });
            this.showNotificationTypePicklist = true;
        })
        .catch((error) => {
            console.log(error);
        });
    }

    //handler for button click
    handleClick(){
        //send the custom notification
        console.log('--- customNotificationManager new entry '+this.notificationJson);
        notifyUsers({           
            notificationEntry : this.notificationJson
        })
        .then((result) => {
            console.log('--- customNotificationManager success '+result);
        })
        .catch((error) => {
            console.log('--- customNotificationManager fail '+error);
        });
    }

    //property to hold the input parameter values
    @track notificationJson = {
        title: null,
        body: null,
        customNotificationType: null,
        targetId : null
    };

    //hanlder for title input
    handleTitle(event){
        this.notificationJson.title = event.detail.value;
    }

    //hanlder for body input
    handleBody(event){
        this.notificationJson.body = event.detail.value;
    }

    //hanlder for notification type picklist
    handleNotificationTypeChange(event){
        this.notificationJson.customNotificationType = event.detail.value;
    }
}