import { LightningElement, wire, api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue,getRelatedListRecords } from 'lightning/uiRecordApi';

import CONTENT_VERSION_DATA from '@salesforce/schema/ContentVersion.VersionData';
import CONTENT_DOCUMENT_ID from '@salesforce/schema/ContentDocument.Id';
import CONTENT_DOCUMENT_TITLE from '@salesforce/schema/ContentDocument.Title';
import CONTENT_DOCUMENT_SIZE from '@salesforce/schema/ContentDocument.ContentSize';
import CONTENT_VERSION_ID from '@salesforce/schema/ContentDocument.LatestPublishedVersionId';
import WOLI_REMOTE_FILE from '@salesforce/schema/WorkOrderLineItem.RemoteFile__c';
import WOLI_REMOTE_FOLDER from '@salesforce/schema/WorkOrderLineItem.RemoteFolder__c';


import getLinkedFiles from '@salesforce/apex/InstallationDocumentController.getLinkedFiles';
import getDocuments from '@salesforce/apex/InstallationDocumentController.getDocuments';

import getCurrentVersionByName from '@salesforce/apex/InstallationDocumentController.getCurrentVersionByName';
import getCurrentVersion from '@salesforce/apex/InstallationDocumentController.getCurrentVersion';
import getRemoteContent from '@salesforce/apex/InstallationDocumentController.getRemoteContent';
import getInstallationDocument from '@salesforce/apex/InstallationDocumentController.getInstallationDocument';
import upsertInstallationDocument from '@salesforce/apex/InstallationDocumentController.upsertInstallationDocument';
import fileManagerTitle from "@salesforce/label/c.Title_FileManager";


const BASE64EXP = new RegExp(/^data(.*)base64,/);
const columns = [
  {
    label: "File",
    fieldName: "id",
    type: "filePreview",
    typeAttributes: {
      anchorText: { fieldName: "title" },
      versionId: { fieldName: "currentVersionId" }
    }
  }
];

export default class InstallationDocument extends LightningElement {
    @api label = '';
    @api versionId = '';
    @api fileId = '';
    @api recordId;
    @api url;
    @track title;
    @track base64;
    @track isModalOpen = false;
    @track data;
    @track error;
    @api logoImageURL;
    @api iframeURL;
    @api modalClass = "slds-modal slds-fade-in-open slds-modal_large";
    loading = false;
    _documents;
    documents= [];
    _documents;
    showPreview = false;
    showSpinner = false;
    columns = columns;
    _currentDocId = null;

    @wire(getLinkedFiles, { linkedRecordId: '$recordId' })
    linkedDocuments;

    @wire(getRecord, { recordId: '$recordId', fields: [WOLI_REMOTE_FILE, WOLI_REMOTE_FOLDER] })
    workOrderLineItem;
  
    @wire(getDocuments, { linkedRecordId: '$recordId' })
    getLinkedDocuments(documents) {
      this._documents = documents;
      const { error, data } = documents;
      if (!error && data) {
        this.documents = data;
        console.log('--- getLinkedDocuments - '+this.documents.length+ ' document(s)');
      }
    };

    @wire(getCurrentVersionByName, { linkedFiles: '$recordId', documentTitle :'$documentTitle' })
      currentVersion;

    @wire(getCurrentVersion, { woli: '$workOrderLineItem' })
    getContent(content) {
      this._content = content;
      const { error, data } = content;
      if (!error && data) {
        this.content = data;
        console.log('--- getContent - content '+this.content);
      }
    };

    @wire(getRecord, { recordId: '$documentId', fields: [CONTENT_DOCUMENT_ID,CONTENT_DOCUMENT_TITLE, CONTENT_DOCUMENT_SIZE,CONTENT_VERSION_ID] })
    contentdocument;
  
    @wire(getRecord, { recordId: '$versionId', fields: [CONTENT_VERSION_DATA] })
    contentversion;
  
    get viewerUrl() {
        return PDFJS + "/web/viewer.html";
    }

    get documentId(){
      return getFieldValue(this.contentdocument.data, CONTENT_DOCUMENT_ID);
    }
    get documentTitle(){
      return getFieldValue(this.contentdocument.data, CONTENT_DOCUMENT_TITLE);
    }
    get documentSize(){
      return getFieldValue(this.contentdocument.data, CONTENT_DOCUMENT_SIZE);
    }
    get versionId(){
      return getFieldValue(this.contentdocument.data, CONTENT_VERSION_ID);
    }
    get versionData(){
      let fieldValue = getFieldValue(this.contentversion.data, CONTENT_VERSION_DATA);
      if(fieldValue){
        return atob(fieldValue);
        // to return a JSON object instead of a string, use the line below
        // return JSON.parse( atob(fieldValue) );
      }
        return '';
    }
    get fileName(){
      return getFieldValue(this.workOrderLineItem.data, WOLI_REMOTE_FILE);
    }
    get fileFolder(){
      return getFieldValue(this.workOrderLineItem.data, WOLI_REMOTE_FOLDER);
    }
    get message() {
      return 'No File found. Please specify correct File ID.';
    }
    get fileOrVersionId() {
      return this.versionId || this.fileId;
    }
    get friendsUrl() {
      return 'https://lumon-test-agent.frendsapp.com:9999/getpdf?';
    }
    
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }
  
    async handleMouseOver() {   
      console.log('---handleMouseOver - id: '+this.documentId);
      console.log('---handleMouseOver - title: '+this.documentTitle);
      console.log('---handleMouseOver - size: '+this.documentSize);
      console.log('---handleMouseOver - version: '+this.versionId);
      if (this.documentSize <10) {
        this.showPreview = false;
        let result = await this.getRemoteFile();
        this.showPreview = true;
      } else {
        this.showPreview = true;
      }
    }
    handleMouseClick(event) {
      const eventDetail = event.detail;
      this.showPreview = false;
      console.log('---handleMouseClick - event detail: '+eventDetail);
      navigateToFile;
    }
    handleMouseOut(event) {
      this.showPreview = false;
      openDocument;
    }
    async getContent(){
      const woliId = this.recordId;
      //InstallationDocumentController.getInstallationDocument(Id woliId)
      const data = await getInstallationDocument({ woliId: this.recordId });
      if (data) {
        this.base64 = data;
      }
    }
    async getLinkedFiles(){
      const data = await getLinkedFiles({ linkedRecordId: this.recordId });
      if (data) {
        this.linkeddocuments = data;
      }
      return this.linkeddocuments;
    }
    async upsertInstallationDocument(){
      const data = await upsertInstallationDocument({ currentVersionId, content: this.base64 });
      if (data) {
        this.linkeddocuments = data;
      }
      return this.linkeddocuments;
    }
    async getRemoteFile(){
      const endpointurl = this.frendsUrl+'path='+this.fileFolder+'pdfname='+this.fileName;
      let method = 'GET';
      try{
        console.log('---getRemoteFile - endpointUrl: '+endpointurl);
        const response =  await fetch(endpointurl,{
          method:method,
          headers: {
            'Authorization': 'x-apikey',
            'Accept': 'application/pdf',
            'Content-Type': 'application/pdf',
            'x-apikey' : 'b1061af1-0ab9-44da-9a77-2b260cc62b49',
          },  
        });
        if(response.ok){
          const content = await response.text();
          if (this.documentSize <10) {
            console.log('---getRemoteFile - Response Type : '+response.type());
            console.log('---getRemoteFile - document Id: '+this.documentId);
            console.log('---getRemoteFile - document Title: '+this.documentTitle);
            uploadInstallationPDF({content : content,documentId: this.documentId, documentTitle: this.documentTitle});   
          }    
          return content;
  
        } else {
          alert('Network response not ok');
          throw new Error('Network response not ok');
        }
      }catch(error){
        alert('Error to get Remote File');
        console.error('---getRemoteFile Error: '+error);
      }
    }
    navigateToFile() {
      console.log('---navigateToFile - documentId: '+this.documentId);
      this[NavigationMixin.Navigate]({
        type: 'standard__namedPage',
        attributes: {
            pageName: 'filePreview'
        },
        state : {
            selectedRecordId: this.documentId
        }
      })
    }


    // Title is set document title and base64 is set document data generated by Apex class


    openModal(event) {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;

        // extecute Apex method when the modal is opened
        convert({recordId:this.recordId}).then((result)=>{
            this.title = result.title;
            this.base64 = result.base64;
            this.template.querySelector('iframe').contentWindow.postMessage(this.base64, '*');
        });
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    download(){
        // extecute download pdf file when click download button
        const linkSource = `data:application/pdf;base64,` + this.base64;
        const downloadLink = document.createElement("a");
        downloadLink.href = linkSource;
        downloadLink.download = this.title;
        downloadLink.click();
        downloadLink.remove();
    }

    // the method to show the notification
    showNotification(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
    
    /**
     * show loading spinner while iFrame content loads
     */
    connectedCallback() {
      getLinkedFiles;
  }
  async init() {
    //showSpinner();
    
    //hideSpinner();
  }
  /**
   * create iFrame and add to DOM
   */
  renderedCallback() {
    const spinnerContainer = this.template.querySelector('.slds-spinner_container');
    const containerElem = this.template.querySelector('.iframe-container');
    const iframe = document.createElement('iframe');
  }
}