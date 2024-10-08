import { LightningElement,wire,track,api} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { getListInfoByName } from "lightning/uiListsApi";
import { getObjectInfo,getObjectInfos } from 'lightning/uiObjectInfoApi';


import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CASE_OBJECT from '@salesforce/schema/Case';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import QUOTE_OBJECT from '@salesforce/schema/Quote';


export default class DynamicListView extends LightningElement {
    @track value;
    @track allListViews;
    @api progressValue;
    @api recordId;
    @api objectApiName;
    @api pageRef;
    @api listDeveloperName;
    @api listViewId;
    @api listOfTitle;  
    @track objectInfo;
    @track objectInfos;
    error;
    displayColumns;

    @wire(getObjectInfos, { 
        objectApiNames: [ACCOUNT_OBJECT, CASE_OBJECT,CONTACT_OBJECT, OPPORTUNITY_OBJECT,QUOTE_OBJECT]
    })
    objectInfos;
    @wire(getListInfoByName, {
      objectApiName: CASE_OBJECT.objectApiName,
      listViewApiName: '$progressValue' ,
    })

    listInfo({ error, data }) {
      if (data) {
        this.displayColumns = data.displayColumns;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.displayColumns = undefined;
      }
    }



   

    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {      
        console.log(`c__myParam = ${this.currentPageReference.state.c__myParam}`); 
    }
                

    lastView({error,data}) { }
    wiredlistView({error,data}) {
        const recordId = this.recordId;
        const objectType = this.objectApiName;
        const pageRef = this.pageRef;
        let fields = [];
        console.log('--- dynamicListView - recordId: '+recordId);
        console.log('--- dynamicListView - objectType: '+objectType);
        console.log('--- dynamicListView - currentPage: '+pageRef);
        if(data){
            this.allListViews = data.lists;
            var listViewData = [];
        for(var i=0;i<this.allListViews.length;i++){
            listViewData.push({"label" : this.allListViews[i].label, "value" : this.allListViews[i].apiName});
        }
        this.allListViews = listViewData;
        }else if(error){
            console.log('An error has occurred:');
            console.log(error);
        }
    }
    handleChange(event) {
        this.value = event.detail.value;
    
        this.progressValue=event.target.value;
        const selectedEvent = new CustomEvent("progressvaluechange",{
            detail:this.progressValue
        });
    
        this.dispatchEvent(selectedEvent);
    }
    
    
    connectedCallback() {}
    render() {}
    handleNext() {
        console.log('btnclick');
        if(this.listViewId){
            this.handleListViewNavigation(this.listViewId);
        }
        else{
            retrieveSobjectRecords({ query : 'SELECT Id, Name, DeveloperName, SobjectType FROM ListView WHERE DeveloperName = \'' + this.listDeveloperName + '\' AND SobjectType =\'' + this.objectApiName + '\'' })
            .then(result => {
                if(result && result.length > 0){
                    this.handleListViewNavigation(result[0].Id);
                }
                else{
                    this.handleListViewNavigation('Recent');
                }
            })
            .catch(error => {
                console.error(error);
            })
        }
    }
    handleListViewNavigation(filterName) {
        // Navigate to the Accounts object's Recent list view.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'list'
            },
            state: {
                filterName: filterName
            }
        });
    }
}