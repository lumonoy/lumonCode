import { LightningElement, api, wire } from 'lwc';
import getComponentData from '@salesforce/apex/PricingServicesController.getComponentData';
import saveItem from '@salesforce/apex/PricingServicesController.saveItem';
import deleteItem from '@salesforce/apex/PricingServicesController.deleteItem';
import { reduceErrors, showToast } from 'c/lwcUtils';
import pricingComponentResources from '@salesforce/resourceUrl/PricingComponentResources';
import { getRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import findProduct from '@salesforce/apex/PricingServicesController.findProduct';
import findPrices from '@salesforce/apex/PricingServicesController.findPrices';
import { utils } from 'c/pricing';

import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';

export default class PricingServices extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api flexipageRegionWidth;
    title = 'Services';
    addLabel = 'Add';
    addIcon = 'utility:add';
    tableClass = 'custom-table';
    intialized = false;
    processing = false;
    availableColumns = [
        {
            label: 'Cost type',
            fieldName: 'costType',
            type: 'picklist',
            cellAttributes: {
                values: [],
            },
            editable: true,
            disabled: (item) => item.recordId,
        },
        {
            label: 'Parameter name',
            fieldName: 'productId',
            type: 'picklist',
            cellAttributes: {
                dependentField: 'costType',
                dependentValues: {},
                values: [],
            },
            editable: true,
            disabled: (item) => !item.costType || item.recordId,
        },
        {
            label: 'Unit',
            fieldName: 'unit',
            type: 'text',
            editable: false,
        },
        {
            label: 'Amount',
            fieldName: 'quantity',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: true,
        },
        {
            label: 'Sales price',
            fieldName: 'salesPrice',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: false,
        },
        {
            label: 'Sales price incl. VAT',
            fieldName: 'salesPriceVAT',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: false,
        },
        {
            label: 'Actions',
            fieldName: 'actions',
            type: 'actions',
            cellAttributes: {
                values: [
                    {
                        label: (item) => (item.recordId ? 'Save' : 'Create'),
                        name: 'save',
                        disabled: (item) => this.disabled || !item.costType || !item.productId || !item.dirty,
                        class: (item) =>
                            'slds-button slds-button_neutral slds-var-m-right_x-small' +
                            (item.dirty ? ' slds-button_brand' : ''),
                    },
                    {
                        label: 'Delete',
                        name: 'delete',
                        class: 'slds-button slds-button_neutral',
                    },
                ],
            },
        },
    ];
    columns = [];
    items = null;
    keyField = 'id';
    cssResourcePath;
    opportunity;
    vat = 24; //Default Value
    disabled = false;
    eventQueue = [];

    /*objectInfos = {};
    @wire(getObjectInfos, { objectApiNames: [OPPORTUNITY_OBJECT, CASE_OBJECT] })
    wiredObjectInfos(response) {
        this.objectInfos = response; 
    }*/
    
    get fields() {
        const recordId = this.recordId;
        const objectType = this.objectApiName;
        let fields = [];
        console.log('--- pricingServices - Record: '+recordId);
        console.log('--- pricingServices - Object: '+objectType);
        //const objectInfo = this.objectInfos.data.results.find(result => result.result.keyPrefix === recordId.substring(0, 3)).result;
        //this.objectApiName = objectInfo.apiName;
        if (objectType === 'Opportunity') {
            fields = [
                'Opportunity.Id',
                'Opportunity.Order_type__c',
                'Opportunity.Count_Opportunity_Products__c',
                'Opportunity.CurrencyIsoCode',
                'Opportunity.StageName'
            ];
        } else if (objectType  === 'Case') {
            fields =  [
                'Case.Id',
                'Case.Type',
                'Case.Reclamation__c',
                'Case.Reclamation__r.CurrencyIsoCode',
                'Case.Reclamation__r.StageName'
            ];
        }
        console.log('--- pricingServices - Fields: '+fields);
        return fields;
    }
    
    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    async wiredRecord({ data, error }) {
        if (data) {
            this.currentRecordData = { data };
            await this.init();
        } else if (error) {
            showToast(this, 'Could not load the opportunity', reduceErrors(error), 'error');
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
            costType: item.Product2?.Cost_Type__c,
            //productGroup: item.Product2?.Product_Group__c,
            product: item.Product2Id,
            quantity: item.Quantity,
            unit: item.Product2?.QuantityUnitOfMeasure,
            salesPrice: item.UnitPrice ? item.UnitPrice * item.Quantity : 0,
            salesPriceVAT: item.UnitPrice ? item.UnitPrice * item.Quantity * (1 + this.vat / 100) : 0,
            dirty: false,
            record: item,
        };
    }
    // Initialize the Component by getting Opportunity and QuoteLineData
    async init() {
        try {
            this.processing = true;
            this.cssResourcePath = pricingComponentResources + '/datatable.css';
            const data = await getComponentData({ recordId: this.recordId });
            this.opportunity = data.opportunity;
            this.disabled = data.disabled;
            if (data.opportunity.Account.VAT__c) {
                this.vat = utils.evenRound(parseFloat(data.opportunity.Account.VAT__c));
            }
            const picklistFieldMapping = {
                costType: 'Cost_Type__c',
            };
            this.columns = this.availableColumns.map((column) => {
                if (column.type === 'picklist') {
                    if(column.cellAttributes.dependentField) {
                        column.cellAttributes.dependentValues = data.picklistDependencies[picklistFieldMapping[column.cellAttributes.dependentField]];
                    } else {
                        column.cellAttributes.values = data.picklistValues[picklistFieldMapping[column.fieldName]];
                    }
                }
                return column;
            });

            if (!this.items || !this.items.length) {
                // Get QuoteLines and convert to items
                this.items = data.quoteLineItems.map((item) => this.recordToItem(item));
            } else {
                this.items = this.items.filter((item) => !item.recordId);
                for (const item of data.quoteLineItems) {
                    if (!this.items.find((o) => item.recordId === o.recordId)) {
                        this.items.push(this.recordToItem(item));
                    }
                }
                this.items = [...this.items];
            }
        } catch (e) {
            showToast(this, 'Services sales error', reduceErrors(e), 'error');
        }
        this.processing = false;
    }
    // Method to set some attributes to Item to be displayed in the Component
    // item.record continues to hold the QuoteLineItem Record

    // On Click of Add Button add a new Item Row
    handleAddItem() {
        let randomId = null;
        while (!randomId || this.items.find((i) => randomId === i.id)) {
            randomId = Math.random() + '';
        }
        this.items = [
            ...this.items,
            {
                ...this.recordToItem({}),
                id: randomId,
                recordId: null,
                dirty: true,
            },
        ];
        console.log('--- pricingServices - Item: '+this.items);
    }
    // On Click of Save or Delete Button or change of a Value call relevant Method
    async handleActionValueChange(event) {
        this.processing = true;
        await this.handleValueChange(event);
        await this.handleAction(event);
        this.processing = false;
    }
    // On Click of Save or Delete Button initiate relevant Action
    async handleAction(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => o.id === eventData.id);
        if (item) {
            if (eventData.action === 'delete') {
                console.log('--- pricingServices - Delete Item: '+item);
                await this.delete(item);
            } else if (eventData.action === 'save') {
                // this.eventQueue.push(async () => { await this.save(item) });
                console.log('--- pricingServices - Save Item: '+item);
                await this.save(item);
            }
        }
    }
    // On Update of a Value update the Item  
    async handleValueChange(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => (o.recordId ? o.recordId === eventData.id : o.id === eventData.id));
        if (item) {
            item[eventData.fieldName] = eventData.value;
            // When selecting the cost Type (= Service Type) set initial values to item
            if (eventData.fieldName === 'costType') {
                item.productId = null;
                item.quantity = 1;
                item.unit = null;
                item.salesPrice = 0;
                item.salesPriceVAT = 0;
                const column = this.columns.find((col) => col.fieldName === 'productId');
                if (column) {
                    column.cellAttributes.values = column.cellAttributes.dependentValues[item.costType];
                    this.columns = [...this.columns];
                }
            } else if (['productId', 'quantity'].includes(eventData.fieldName)) {
                this.processing = true;
                // Get the Product2 records and it's Attributes
                const product = await findProduct({ productId: item.productId });
                console.log('--- pricingServices - Product: '+product);
                //Id, Name Product_Group__c, Cost_Type__c, ProductCode, Sales_Code__c, QuantityUnitOfMeasure
                // Set the item attributes to show
                item.productId = product.Id;
                item.unit = product.QuantityUnitOfMeasure;
                this.processing = false;
                if(eventData.fieldName !== 'quantity') {
                    item.quantity = 1;
                } 
                try {
                    // Get Prices for the item
                    const quoteLineItem = await findPrices({
                                                            opportunityId: this.opportunity.Id, 
                                                            productId: item.productId, 
                                                            quantity: item.quantity
                    });
                    console.log('--- pricingServices - QuoteLine: '+quoteLineItem);
                    item.record = quoteLineItem;
                    console.log('--- pricingServices - item: '+item)
                    const itemWithPrices = this.recordToItem(quoteLineItem);
                    item.salesPrice = itemWithPrices.salesPrice;
                    item.salesPriceVAT = itemWithPrices.salesPriceVAT;
                    console.log('--- pricingServices - item with prices: '+item)
                } catch(e) {
                    showToast(this, 'Error', 'Prices were not found', 'error');
                }
                this.processing = false;
            } 
            item.dirty = true;
        }
        this.items = [...this.items];
    }

    get showSpinner() {
        return !this.intialized || this.processing;
    }

    get saveDisabled() {
        return !this.intialized || this.processing;
    }

    async save(item) {
        this.processing = true;
        try {
            item.record.Id = item.recordId; //QuoteLineItem Id
            console.log('--- pricingServices - Save Item: '+item);
            const itemToUpsert = await saveItem({
                                                    opportunityId: this.opportunity.Id,
                                                    quoteLineItem: item.record,
                                                });
            console.log('--- pricingServices - Updated Item: '+ itemToUpsert);
            item.id = itemToUpsert.Id;
            item.recordId = itemToUpsert.Id;
            item.dirty = false;
            console.log('--- pricingServices - Init:');
            await this.init();
            showToast(this, 'Saved', 'Services Item Saved', 'success');
        } catch (e) {
            showToast(this, 'We hit a snag', reduceErrors(e), 'error', 'sticky');
        }
        // Refresh the Component
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }

    async delete(item) {
        this.processing = true;
        try {
            console.log('--- pricingServices - Delete Item: '+item);
            if (item.recordId) {
                await deleteItem({
                    opportunityId: this.opportunity.Id,
                    quoteLineItemId: item.recordId,
                });
                showToast(this, 'Deleted', 'Services Product Deleted', 'success');
            }
            this.items = this.items.filter((o) => o.id !== item.id);
        } catch (e) {
            showToast(this, 'We hit a snag', reduceErrors(e), 'error', 'sticky');
        }
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }
}