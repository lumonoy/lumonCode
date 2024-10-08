import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CONTENT_VERSION_DATA from '@salesforce/schema/ContentVersion.VersionData';
import CONTENT_DOCUMENT_ID from '@salesforce/schema/ContentDocument.Id';
import CONTENT_DOCUMENT_TITLE from '@salesforce/schema/ContentDocument.Title';
import CONTENT_DOCUMENT_SIZE from '@salesforce/schema/ContentDocument.ContentSize';
import CONTENT_VERSION_ID from '@salesforce/schema/ContentDocument.LatestPublishedVersionId';

import WOLI_REMOTE_FILE from '@salesforce/schema/WorkOrderLineItem.RemoteFile__c';
import WOLI_REMOTE_FOLDER from '@salesforce/schema/WorkOrderLineItem.RemoteFolder__c';

import uploadNewFileVersion from '@salesforce/apex/FileController.uploadNewFileVersion';

export default class FileDataTableCell extends NavigationMixin(LightningElement) {
  showPreview = false;
  @api label = '';
  @api versionId = '';
  @api fileId = '';
  @api recordId = '';
  versionDetails = [];
  _currentDocId = null;
  
  @wire(getRecord, { recordId: '$recordId', fields: [WOLI_REMOTE_FILE, WOLI_REMOTE_FOLDER] })
  workOrderLineItem;

  @wire(getRecord, { recordId: '$fileId', fields: [CONTENT_DOCUMENT_ID,CONTENT_DOCUMENT_TITLE, CONTENT_DOCUMENT_SIZE,CONTENT_VERSION_ID] })
  contentdocument;

  @wire(getRecord, { recordId: '$versionId', fields: [CONTENT_VERSION_DATA] })
  contentversion;

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
  

  async handleMouseOver() {   
    console.log('--- fileDataTableCell - handleMouseOver - id: '+this.documentId);
    console.log('--- fileDataTableCell - handleMouseOver - title: '+this.documentTitle);
    console.log('--- fileDataTableCell - handleMouseOver - size: '+this.documentSize);
    console.log('--- fileDataTableCell - handleMouseOver - version: '+this.versionId);
    if (this.documentSize <10) {
      this.showPreview = false;
      let result = await this.getRemoteFile();
      this.showPreview = true;
    } else {
      this.showPreview = true;
    }
  }
  

  async getRemoteFile(){
    const endpointurl = this.frendsUrl+'path='+this.fileFolder+'pdfname='+this.fileName;
    let method = 'GET';
    try{
      console.log('--- fileDataTableCell - getRemoteFile - endpointUrl: '+endpointurl);
      const response =  await fetch(endpointurl,{
        method:method,
        headers: {
          'Authorization': 'x-apikey',
          'Accept': 'application/pdf',
          'Content-Type': 'application/json',
          'x-apikey' : 'b1061af1-0ab9-44da-9a77-2b260cc62b49',
        },  
      });
      if(response.ok){
        const content = await response.text();
        if (this.documentSize <10) {
          uploadNewFileVersion({content : content,documentId: this.documentId, documentTitle: this.documentTitle});   
        }    
        return content;
      } else {
        alert('Network response not ok');
        throw new Error('Network response not ok');
      }
    }catch(error){
      alert('Error to get Remote File');
      console.error('--- fileDataTableCell - getRemoteFile Error: '+error);
    }
  }
  async handleMouseClick(event) {
    const eventDetail = event.detail;
    console.log('--- fileDataTableCell - handleMouseClick - event detail: '+eventDetail);
    navigateToFile;
    

}
  handleMouseOut(event) {
    this.showPreview = false;
    openDocument;
  }
  filePreview(event) {
    // Naviagation Service to the show preview
    this[NavigationMixin.Navigate]({
        type: 'standard__namedPage',
        attributes: {
            pageName: 'filePreview'
        },
        state: {
            // assigning ContentDocumentId to show the preview of file
            selectedRecordId: event.currentTarget.dataset.id
        }
    })
}
  navigateToFile() {
    console.log('--- fileDataTableCell - navigateToFile - documentId: '+this.documentId);
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
}