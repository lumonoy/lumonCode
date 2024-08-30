import { LightningElement, api, wire } from "lwc";
import getComponentData from "@salesforce/apex/PricingSpareComponentsController.getComponentData";
import saveItem from "@salesforce/apex/PricingSpareComponentsController.saveItem";
import deleteAdditionalCost from "@salesforce/apex/PricingSpareComponentsController.deleteItem";
import searchSpareParts from "@salesforce/apex/PricingSpareComponentsController.search";
import findProduct from "@salesforce/apex/PricingSpareComponentsController.findProduct";
import findPrices from "@salesforce/apex/PricingSpareComponentsController.findPrices";
import { reduceErrors, showToast } from "c/lwcUtils";
import pricingComponentResources from "@salesforce/resourceUrl/PricingComponentResources";
import { getRecord, notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { utils } from "c/pricing";
// import findBasePrice from "@salesforce/apex/PricingExtraSalesController.findBasePrice";

export default class PricingSpareComponents extends LightningElement {
    @api
    recordId;

    intialized = false;
    processing = false;
    disabled = false;
    columns = [
        {
            label: "Product Code",
            fieldName: "productId",
            type: "lookup",
            editable: true,
            cellAttributes: {
                values: [],
                nameField: "Description",
                fields: ["Id", "Description"],
                // These are sent back from the customDataTable when search() is called.
                // searchText is always present in the response
                filters: {
                    searchText: null,
                },
                defaultRecord: (item) => ({
                    Product2Id: item.productId,
                    Description: item.name,   
                }),
                search: async (filters) => {
                    const searchWord = filters.searchText.trim();
                    const response = searchWord 
                        ? await searchSpareParts({
                            filters: {
                                text: searchWord,
                                fields: ["Id", "Name", "QuantityUnitOfMeasure"],
                                quote: this.quote,
                            }
                        })
                        : Promise.resolve({ records: [] });
                    this.columns.find(c => c.fieldName === "productId").cellAttributes.values = response.records;
                    this.columns = [...this.columns];
                    this.items = [...this.items];
                }
            },
            disabled: (item) => item.recordId, 
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
            editable: true,
        },
        {
            label: "Sales price",
            fieldName: "salesPrice",
            type: "number",
            class: "slds-text-align_right",
            headerClass: "slds-text-align_right",
            editable: false,
        },
        {
            label: "Sales price incl. VAT",
            fieldName: "salesPriceVAT",
            type: "number",
            class: "slds-text-align_right",
            headerClass: "slds-text-align_right",
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
                        disabled: (item) => !item.productId,
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
    items = null;
    keyField = "id";
    cssResourcePath;
    opportunity;
    vat = 24;
    quote;

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
            productId: item.Product2Id,
            quantity: item.Quantity,
            unit: item.Product2?.QuantityUnitOfMeasure,
            name: item.Product2?.Name,
            salesPrice: item.UnitPrice || 0,
            salesPriceVAT: item.UnitPrice ? item.UnitPrice * (1 + this.vat / 100) : 0,
            dirty: false,
        };
    }

    async init() {
        try {
            this.processing = true;
            this.cssResourcePath = pricingComponentResources + "/datatable.css";
            const data = await getComponentData({ recordId: this.recordId });
            this.opportunity = data.opportunity;
            this.visible = data.visible;
            this.disabled = data.disabled;
            this.quote = data.quote;
            if (data.opportunity.Account.VAT__c) {
                this.vat = utils.evenRound(parseFloat(data.opportunity.Account.VAT__c));
            }

            const productIdColumn = this.columns.find(c => c.fieldName === "productId");
            productIdColumn.cellAttributes.filters.quoteId = data.quote.Id;
            this.columns = [...this.columns];

            if (!this.items || !this.items.length) {
                this.items = data.quoteLineItems.map((item) => this.recordToItem(item));
            } else {
                for (const item of data.quoteLineItems) {
                    if (!this.items.find((o) => item.recordId !== o.recordId)) {
                        this.items.push(this.recordToItem(item));
                    }
                }
                this.items = [...this.items];
            }
        } catch (e) {
            showToast(this, "Product error", reduceErrors(e), "error");
        }
        this.processing = false;
    }

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

    handleAction(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => o.id === eventData.id);
        if (item) {
            if (eventData.action === "delete") {
                this.deleteItem(item);
            } else if (eventData.action === "save") {
                this.saveItem(item);
            }
        }
    }

    async handleLookupChange(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => (o.recordId ? o.recordId === eventData.id : o.id === eventData.id));
        if (item) {
            item.productId = eventData.value?.id;
            item.quantity = 1;
            item.salesPrice = 0;
            item.salesPriceVAT = 0;
            item.unit = null;
            if(eventData.value) {
                await this.handlePriceChange(item, eventData.value.id);
            }
        }
        item.dirty = true;
        this.items = [...this.items];
    }
    
    async handleValueChange(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => (o.recordId ? o.recordId === eventData.id : o.id === eventData.id));
        if (item) {
            if (eventData.fieldName === "quantity") {
                item.quantity = eventData.value;
                this.handlePriceChange(item, item.productId);
                item.dirty = true;
            }
        }
        this.items = [...this.items];
    }
    
    async handlePriceChange(item, productId) {
        this.processing = true;
        try {
            const product = await findProduct({ productId: productId });
            item.productId = product.Id;
            item.unit = product.QuantityUnitOfMeasure;

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
            item.productId = null;
            showToast(this, "Price not found", "Please try again", "warning");
        }
        this.processing = false;
    }

    get showSpinner() {
        return !this.intialized || this.processing;
    }

    get saveDisabled() {
        return !this.intialized || this.processing;
    }

    async saveItem(item) {
        this.processing = true;
        try {
            item.record.Id = item.recordId;
            const record = await saveItem({
                opportunityId: this.recordId,
                quoteLineItem: item.record,
                // quoteLineItem: {
                //     Id: item.recordId,
                //     Product2Id: item.productId,
                //     Quantity: item.quantity,
                //     UnitPrice: item.salesPrice,
                // },
            });
            item.id = record.Id;
            item.recordId = record.Id;
            item.name = record.Product2?.Name;
            item.dirty = false;
            await this.init();
            showToast(this, "Saved", "Product saved", "success");
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
                    opportunityId: this.opportunity.Id,
                    quoteLineItemId: item.recordId,
                });
                showToast(this, "Deleted", "Product deleted", "success");
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