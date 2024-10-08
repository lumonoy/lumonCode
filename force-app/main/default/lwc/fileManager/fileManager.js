import { LightningElement, wire, api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import CONTENT_VERSION_DATA from '@salesforce/schema/ContentVersion.VersionData';
import CONTENT_DOCUMENT_ID from '@salesforce/schema/ContentDocument.Id';
import CONTENT_DOCUMENT_TITLE from '@salesforce/schema/ContentDocument.Title';
import CONTENT_DOCUMENT_SIZE from '@salesforce/schema/ContentDocument.ContentSize';
import CONTENT_VERSION_ID from '@salesforce/schema/ContentDocument.LatestPublishedVersionId';
import WOLI_REMOTE_FILE from '@salesforce/schema/WorkOrderLineItem.RemoteFile__c';
import WOLI_REMOTE_FOLDER from '@salesforce/schema/WorkOrderLineItem.RemoteFolder__c';

import getRelatedFiles from '@salesforce/apex/FileController.getRelatedFiles';
import getFileDetails from '@salesforce/apex/FileController.getFileDetails';
import getFileContent from '@salesforce/apex/FileController.getFileContent';
import uploadNewFileVersion from '@salesforce/apex/FileController.uploadNewFileVersion';
import createContentDocLink from '@salesforce/apex/FileController.createContentDocLink';
import fileManagerTitle from "@salesforce/label/c.Title_FileManager";

const BASE64EXP = new RegExp(/^data(.*)base64,/);
const columns = [
  {
    label: "File",
    fieldName: "id",
    type: "filePreview",
    typeAttributes: {
      anchorText: { fieldName: "title" },
      versionId: { fieldName: "latestVersionId" }
    }
  }
];

export default class FileManager extends NavigationMixin(LightningElement) {
  @api label = '';
  @api versionId = '';
  @api fileId = '';
  @api recordId = '';
  relatedfiles = [];
  _relatedfiles;
  showPreview = false;
  showSpinner = false;
  columns = columns;
  _currentDocId = null;

  @wire(getRelatedFiles, { recordId: "$recordId" })
    getRelatedFiles(relatedfiles) {
      this._relatedfiles = relatedfiles;
      const { error, data } = relatedfiles;
      if (!error && data) {
        
        this.relatedfiles = data;
        console.log('--- fileManager - Related Files: '+this.relatedfiles );
      } else if (error) {
        console.log('--- fileManager - Related Files Error: '+error);
      }
    } 
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
    console.log('--- fileManager - handleMouseOver - id: '+this.documentId);
    console.log('--- fileManager - handleMouseOver - title: '+this.documentTitle);
    console.log('--- fileManager - handleMouseOver - size: '+this.documentSize);
    console.log('--- fileManager - handleMouseOver - version: '+this.versionId);
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
    console.log('--- fileManager - handleMouseClick - event detail: '+eventDetail);
    navigateToFile;
  }
  handleMouseOut(event) {
    this.showPreview = false;
    openDocument;
  }

  async getRemoteFile(){
    const endpointurl = this.frendsUrl+'path='+this.fileFolder+'pdfname='+this.fileName;
    let method = 'GET';
    try{
      console.log('--- fileManager - getRemoteFile - endpointUrl: '+endpointurl);
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
          console.log('--- fileManager - getRemoteFile - Response Type : '+response.type());
          console.log('--- fileManager - getRemoteFile - document Id: '+this.documentId);
          console.log('--- fileManager - getRemoteFile - document Title: '+this.documentTitle);
          uploadNewFileVersion({content : content,documentId: this.documentId, documentTitle: this.documentTitle});   
        }    
        return content;

      } else {
        alert('Network response not ok');
        throw new Error('Network response not ok');
      }
    }catch(error){
      alert('Error to get Remote File');
      console.error('--- fileManager - getRemoteFile Error: '+error);
    }
  }
  navigateToFile() {
    console.log('--- fileManager - navigateToFile - documentId: '+this.documentId);
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