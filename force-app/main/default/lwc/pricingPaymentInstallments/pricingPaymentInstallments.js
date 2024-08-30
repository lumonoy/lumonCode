import { LightningElement, api, wire } from 'lwc';
import getComponentData from '@salesforce/apex/PricingPaymentInstallmentsController.getComponentData';
import { reduceErrors, showToast } from 'c/lwcUtils';
import pricingComponentResources from '@salesforce/resourceUrl/PricingComponentResources';
import { getRecord } from 'lightning/uiRecordApi';
import { flattenTree, collapseTree, updateExpandCollapse, evenRound, roundNumber} from 'c/cpqUtils';

export default class PricingPaymentInstallments extends LightningElement {
    @api
    recordId;

    intialized = false;
    processing = false;
    availableColumns = [
        {
            label: 'Number',
            fieldName: 'number',
            type: 'text',
            cellAttributes: {
                values: [],
            },
            editable: false,
        },
        {
            label: 'Type',
            fieldName: 'type',
            type: 'text',
            cellAttributes: {
                values: [],
            },
            editable: false,
        },
        {
            label: 'Description',
            fieldName: 'description',
            type: 'text',
            cellAttributes: {
                values: [],
            },
            editable: false,
        },
        {
            label: 'Excl. VAT',
            fieldName: 'exclVat',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: false,
        },
        {
            label: 'Incl. VAT',
            fieldName: 'inclVat',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: false,
        },
    ];
    columns = [];
    items = null;
    keyField = 'id';
    cssResourcePath;
    opportunity;
    vat = 24; // VAT default


    @wire(getRecord, {
        recordId: '$recordId',
        fields: ['Opportunity.Id', 'Opportunity.Count_Opportunity_Products__c', 'Opportunity.CurrencyIsoCode'],
    })
    async wiredRecord({ data, error }) {
        this.opportunity = data;
        if (data) {
            await this.init();
        } else if (error) {
            showToast(this, 'Could not load the opportuntiy', 'Try to refresh the page', 'error');
        }
    }

    renderedCallback() {
        if (this.intialized) {
            return;
        }
        this.intialized = true;
    }

    recordToItem(item) {
        return {
            id: item.Id,
            recordId: item.Id,
            number: item.Number__c,
            description: item.Description__c,
            type: item.Type__c,
            exclVat: evenRound(item.Amount__c),
            inclVat: evenRound(item.Amount__c*(1+(this.vat/100))),
            dirty: false,
        };
    }

    async init() {
        try {
            this.processing = true;
            this.cssResourcePath = pricingComponentResources + '/datatable.css';
            this.columns = this.availableColumns;
            this.items = [];
            const data = await getComponentData({ recordId: this.recordId });
            if(data.opportunity.Account.VAT__c) {
                this.vat = evenRound(parseFloat(data.opportunity.Account.VAT__c));
            }
            this.items = data.items.map((item) => this.recordToItem(item));
            this.items.sort((a, b) => a.Number__c > b.Number__c);
        } catch (e) {
            showToast(this, 'Error loading payment installments', reduceErrors(e), 'error');
        }
        this.processing = false;
    }

    get showSpinner() {
        return !this.intialized || this.processing;
    }
}