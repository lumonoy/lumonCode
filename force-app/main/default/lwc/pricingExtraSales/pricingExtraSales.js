import { LightningElement, api, wire } from "lwc";
import getComponentData from "@salesforce/apex/PricingExtraSalesController.getComponentData";
import saveItem from "@salesforce/apex/PricingExtraSalesController.saveItem";
import deleteAdditionalCost from "@salesforce/apex/PricingExtraSalesController.deleteItem";
import { reduceErrors, showToast } from "c/lwcUtils";
import pricingComponentResources from "@salesforce/resourceUrl/PricingComponentResources";
import { getRecord, notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import findProduct from "@salesforce/apex/PricingExtraSalesController.findProduct";
import findPrices from "@salesforce/apex/PricingExtraSalesController.findPrices";
import { utils } from "c/pricing";

export default class PricingExtraSales extends LightningElement {
    @api
    recordId;

    intialized = false;
    processing = false;
    availableColumns = [
        {
            label: "Cost type",
            fieldName: "costType",
            type: "picklist",
            cellAttributes: {
                values: [],
            },
            editable: true,
            disabled: (item) => item.recordId,
        },
        {
            label: "Parameter name",
            fieldName: "productId",
            type: "picklist",
            cellAttributes: {
                dependentField: "costType",
                dependentValues: {},
                values: [],
            },
            editable: true,
            disabled: (item) => !item.costType || item.recordId,
        },
        {
            label: "Unit",
            fieldName: "unit",
            type: "text",
            editable: false,
        },
        {
            label: "Amount",
            fieldName: "quantity",
            type: "number",
            headerClass: "slds-text-align_right",
            class: "slds-text-align_right",
            editable: true,
        },
        {
            label: "Sales price",
            fieldName: "salesPrice",
            type: "number",
            headerClass: "slds-text-align_right",
            class: "slds-text-align_right",
            editable: false,
        },
        {
            label: "Sales price incl. VAT",
            fieldName: "salesPriceVAT",
            type: "number",
            headerClass: "slds-text-align_right",
            class: "slds-text-align_right",
            editable: false,
        },
        {
            label: "Actions",
            fieldName: "actions",
            type: "actions",
            cellAttributes: {
                values: [
                    {
                        label: (item) => (item.recordId ? "Save" : "Create"),
                        name: "save",
                        disabled: (item) => this.disabled || !item.costType || !item.productId || !item.dirty,
                        class: (item) =>
                            "slds-button slds-button_neutral slds-var-m-right_x-small" +
                            (item.dirty ? " slds-button_brand" : ""),
                    },
                    {
                        label: "Delete",
                        name: "delete",
                        class: "slds-button slds-button_neutral",
                    },
                ],
            },
        },
    ];
    columns = [];
    items = null;
    keyField = "id";
    cssResourcePath;
    opportunity;
    vat = 24;
    disabled = false;
    eventQueue = [];

    @wire(getRecord, {
        recordId: "$recordId",
        fields: ["Opportunity.Id", "Opportunity.Count_Opportunity_Products__c", "Opportunity.CurrencyIsoCode"],
    })
    async wiredRecord({ data, error }) {
        this.opportunity = data;
        if (data) {
            await this.init();
        } else if (error) {
            showToast(this, "Could not load the opportunity", "Try to refresh the page", "error");
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
            productId: item.Product2Id,
            quantity: item.Quantity,
            unit: item.Product2?.QuantityUnitOfMeasure,
            salesPrice: item.UnitPrice ? item.UnitPrice * item.Quantity : 0,
            salesPriceVAT: item.UnitPrice ? item.UnitPrice * item.Quantity * (1 + this.vat / 100) : 0,
            dirty: false,
            record: item,
        };
    }

    async init() {
        try {
            this.processing = true;
            this.cssResourcePath = pricingComponentResources + "/datatable.css";
            const data = await getComponentData({ recordId: this.recordId });
            this.disabled = data.disabled;
            if (data.opportunity.Account.VAT__c) {
                this.vat = utils.evenRound(parseFloat(data.opportunity.Account.VAT__c));
            }
            const picklistFieldMapping = {
                costType: "Cost_Type__c",
            };
            this.columns = this.availableColumns.map((column) => {
                if (column.type === "picklist") {
                    if(column.cellAttributes.dependentField) {
                        column.cellAttributes.dependentValues = data.picklistDependencies[picklistFieldMapping[column.cellAttributes.dependentField]];
                    } else {
                        column.cellAttributes.values = data.picklistValues[picklistFieldMapping[column.fieldName]];
                    }
                }
                return column;
            });

            if (!this.items || !this.items.length) {
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
            showToast(this, "Extra sales error", reduceErrors(e), "error");
        }
        this.processing = false;
    }
    
    // async processQueue() {
    //     while(this.eventQueue.length) {
    //         console.log("process event queue");
    //         // eslint-disable-next-line no-await-in-loop
    //         await (this.eventQueue.pop())();
    //     }
    // }

    handleAddItem() {
        let randomId = null;
        while (!randomId || this.items.find((i) => randomId === i.id)) {
            randomId = Math.random() + "";
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
    }

    async handleAction(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => o.id === eventData.id);
        if (item) {
            if (eventData.action === "delete") {
                // this.eventQueue.push(async () => { await this.deleteItem(item) });
                await this.deleteItem(item);
            } else if (eventData.action === "save") {
                // this.eventQueue.push(async () => { await this.save(item) });
                await this.save(item);
            }
        }
        // this.processQueue();
    }

    // handleValueChange(event) {
    //     this.eventQueue.push(async () => { await this.valueChange(event) });
    //     this.processQueue();
    // }
    
    async handleActionValueChange(event) {
        this.processing = true;
        await this.handleValueChange(event);
        await this.handleAction(event);
        this.processing = false;
    }
    
    async handleValueChange(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => (o.recordId ? o.recordId === eventData.id : o.id === eventData.id));
        if (item) {
            item[eventData.fieldName] = eventData.value;
            if (eventData.fieldName === "costType") {
                item.productId = null;
                item.quantity = 1;
                item.unit = null;
                item.salesPrice = 0;
                item.salesPriceVAT = 0;
                const column = this.columns.find((col) => col.fieldName === "productId");
                if (column) {
                    column.cellAttributes.values = column.cellAttributes.dependentValues[item.costType];
                    this.columns = [...this.columns];
                }
            } else if (["productId", "quantity"].includes(eventData.fieldName)) {
                this.processing = true;
                try {
                    const product = await findProduct({ productId: item.productId });
                    item.productId = product.Id;
                    item.unit = product.QuantityUnitOfMeasure;
                    if(eventData.fieldName !== "quantity") {
                        item.quantity = 1;
                    }

                    const quoteLineItem = await findPrices({
                        opportunityId: this.recordId, productId: item.productId, quantity: item.quantity
                    });
                    quoteLineItem.Product2Id = product.Id;
                    quoteLineItem.Product2 = product;
                    item.record = quoteLineItem;
                    const itemWithPrices = this.recordToItem(quoteLineItem);
                    item.salesPrice = itemWithPrices.salesPrice;
                    item.salesPriceVAT = itemWithPrices.salesPriceVAT;
                } catch(e) {
                    showToast(this, "Something went wrong", "Please try again", "error");
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
            item.record.Id = item.recordId;
            const updatedItem = await saveItem({
                opportunityId: this.recordId,
                quoteLineItem: item.record,
            })
            item.id = updatedItem.Id;
            item.recordId = updatedItem.Id;
            item.dirty = false;
            await this.init();
            showToast(this, "Saved", "Extra sales saved", "success");
        } catch (e) {
            showToast(this, "We hit a snag", reduceErrors(e), "error", "sticky");
        }
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }

    async deleteItem(item) {
        this.processing = true;
        try {
            if (item.recordId) {
                await deleteAdditionalCost({
                    opportunityId: this.recordId,
                    quoteLineItemId: item.recordId,
                });
                showToast(this, "Deleted", "Extra sales deleted", "success");
            }
            this.items = this.items.filter((o) => o.id !== item.id);
        } catch (e) {
            showToast(this, "We hit a snag", reduceErrors(e), "error", "sticky");
        }
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }
}