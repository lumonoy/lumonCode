import { LightningElement, wire, api,track } from "lwc";
import getRelatedFiles from "@salesforce/apex/FileController.getFilesList";
import getInstallationCard from "@salesforce/apex/FileController.getInstallationCard";
import upsertInstallationCard from "@salesforce/apex/FileController.upsertInstallationCard";
import getFileVersionDetails from "@salesforce/apex/FileController.getFileVersionDetails";
import createContentDocLink from "@salesforce/apex/FileController.createContentDocLink";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";


const actions = [
  { label: "Version History", name: "show_details" },
  { label: "File", name: "preview" }
];

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
  },
  { label: "Uploaded by", fieldName: "createdBy", type: "string" },
  { label: "Uploaded Date", fieldName: "createdDate", type: "date" },
  { type: "action", typeAttributes: { rowActions: actions } }
];

const versionColumns = [
    {
        label: "Download",
        fieldName: "id",
        type: "filePreview",
        typeAttributes: {
          anchorText: "Download⇣"
        }
    },
  { label: "Title", fieldName: "title", type: "string" },
  { label: "Reason for Change", fieldName: "reasonForChange", type: "string" },
  { label: "Uploaded by", fieldName: "createdBy", type: "string" },
  { label: "Uploaded Date", fieldName: "createdDate", type: "date" }
];

export default class FileList extends LightningElement {
    @api
    recordId;
    _filesList;
    files = [];
    columns = columns;
    versionColumns = versionColumns;
    versionDetails = [];
    fileUpload = false;
    _currentDocId = null;
    showPreview = false;
    currentPreviewFileId = null;
    showSpinner = false;
    @api acceptedFileFormats;
    @api fileUploaded;
    title;
    @track initialized=false;
    @track newFile=false;
    
    @wire(getRelatedFiles, { recordId: "$recordId" })
    getFilesList(filesList) {
      this._filesList = filesList;
      const { error, data } = filesList;
      if (!error && data) {
        this.files = data;
      }
    } 
  
    closeModal() {
      this.newFile=false;
      this._currentDocId = null;
      this.versionDetails = [];
      this.fileTitle = "";
      refreshApex(this._filesList);
      if(this.dialag) {
        this.dialag.closeModal();
      }
    } 
    async getData(){
      const  endpointurl = 'https://lumon-test-agent.frendsapp.com:9999/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf'
      let method = 'GET';
      try{
        alert('--- getdata ---');
        const response =  await fetch(endpointurl,{
          method:method,
          headers: {
            'Authorization': 'x-apikey',
            'Accept': 'application/pdf',
            'Content-Type': 'application/json',
            'x-apikey' : 'b1061af1-0ab9-44da-9a77-2b260cc62b49',
          },  
        });
        console.log('--- response in console ---',response.ok);
        //console.log('--- response in console 2 ---',response.text());

        if(response.ok){
          console.log('--- response is ok ---');
          const pdf = await response.text();
          console.log('--- pdf in console ---',pdf);
          //alert(EncodingUtil.base64Decode(response).toString());
          //var base64Str = Buffer.from(pdf).toString('base64');
          //alert(base64Str);
          //base64Str = base64.base64Decode(base64Str, filename);
          upsertInstallationCard({resp : pdf,fileId: this._currentDocId});
          //alert(response.json());
          return pdf;
        }else {
          alert('Network response not ok');
          throw new Error('Network response not ok');
        }
      }catch(error){
        console.error(error);
      }
      
      /*
      .then(response => 
          response.json().then(data => ({
              data: data,
              status: response.status
          })
      ).then(res => {
          alert('--- res.status ---'+res.status);
          alert('--- res.data ---'+res.data);
          console.log(res.status, res.data)
      }))*/
    }
  
    handleRowAction(event) {
      const action = event.detail.action.name;
      console.log('--- action ---',action);
      const row = event.detail.row;
      this._currentDocId = row.id;
      var fileName=row.title;
      const  endpointurl = 'https://lumon-test-agent.frendsapp.com:9999/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf'
      alert(action);
      if (action === "show_details") {
        this.fileUpload = false;
        this.title=`File History - ${fileName}`;
        console.log('-- fileName ---'+fileName);
        this.showVersionDetails(fileName);
      }else if (action === "preview"){
        //let endpointurl = 'https://lumon-test-agent.frendsapp.com:9999/getpdf%3Fpath=%5C123%5C456%5C%26pdfname%3Dasennuskortti.pdf';
        //let endpointurl = 'callout:testPDF/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf';
        //withCredentials: true,
        //credentials: 'include',
        //this.showInstallationCard();
        
        let method = 'GET';
        var myHeaders = new Headers();
        myHeaders.append("x-api-key", "b1061af1-0ab9-44da-9a77-2b260cc62b49");
        var requestOptions = {
          method: 'GET',
          headers: myHeaders,
          redirect: 'follow'
        };
        this.getData();
        /*
        fetch(endpointurl,{
          method:method,
          
          headers: {
            'Authorization': 'x-apikey',
            'Content-Type': 'application/json',
            'x-apikey' : 'b1061af1-0ab9-44da-9a77-2b260cc62b49',
          },
        })
          .then((response) => {
            if(response.ok){
              alert(response.text());
              alert(this._currentDocId);
              console.log('--- this._currentDocId ---'+this._currentDocId);
              console.log('--- response.body ---'+response.json);
              upsertInstallationCard({resp : response.json,fileId: this._currentDocId});
              return response;
            }else {
              alert('Network response not ok');
              throw new Error('Network response not ok');
            }
            
          })
          .then((data) => {
            alert('data ok');
            console.log('--- data ---'+data);
            alert(response.json);
          })
          .catch((error) => {
            alert('Error calling fetch api');
            console.log('--- error when calling fetch api ---',error)
          });*/
      }
    } 
    
    
    get dialag()
    {
        return this.template.querySelector('c-dialog');
    }
    showVersionDetails() {
      getFileVersionDetails({ fileId: this._currentDocId })
        .then((result) => {
          this.versionDetails = result;
          if(this.dialag) {
              this.dialag.openmodal();
          }
        })
        .catch((err) => {
          console.error(JSON.stringify(err));
        });
    }
    showInstallationCard(){
      //console.log('--- show Installation card ---'+this.fileName);
      getInstallationCard({fileId: this._currentDocId})
      .then((result) => {
        console.log('--- retrieved file ---');
        if(this.dialag) {
            this.dialag.openmodal();
        }
      })
      .catch((err) => {
        console.error(JSON.stringify(err));
      });
    }
    
    createContentLink(cvId) {
     createContentDocLink({
        contentVersionId: cvId,
        recordId: this.recordId
      })
        .then((cId) => {
          this.closeModal();
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "success",
              message: `File uploaded successfully ${cId}`
            })
          );
        })
        .catch((err) => {
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "error",
              message: "An error occurred"
            })
          );
        });
    }
}