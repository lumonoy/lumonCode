import { LightningElement,api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import upsertInstallationCard from "@salesforce/apex/FileController.upsertInstallationCard";

export default class FilePreviewCell extends NavigationMixin(LightningElement) {
  showPreview = false;
  @api label = "";
  @api versionId = "";
  @api fileId = "";
  _currentDocId = null;
  async navigateToFile(event) {
    alert('--- fileId ---'+this.fileId);
    alert('--- versionId ---'+this.versionId);
    try{
      let result = await this.getData();
      event.preventDefault();
      this[NavigationMixin.Navigate]({
        type: "standard__namedPage",
        attributes: {
          pageName: "filePreview"
        },
        state: {
          recordIds: this.fileId,
          selectedRecordId: this.fileId
        }
      });
    }catch(error){
      console.log('No file returned');
    }
  }
  get message() {
    return 'No File found. Please specify correct File ID.';
  }
  get fileOrVersionId() {
    return this.versionId || this.fileId;
  }

  async handleMouseOver() {
    let result = await this.getData();
    this.showPreview = true;
  }

  async getData(){
    const  endpointurl = 'https://lumon-test-agent.frendsapp.com:9999/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf'
    let method = 'GET';
    try{
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

      if(response.ok){
        const pdf = await response.text();
        console.log('--- fileId ---'+this.fileId);
        console.log('--- pdf ---'+pdf);
        upsertInstallationCard({resp : pdf,fileId: this.fileId});
        //alert(response.json());
        return pdf;
      }else {
        alert('Network response not ok');
        throw new Error('Network response not ok');
      }
    }catch(error){
      console.error(error);
    }
  }

  handleMouseOut() {
    this.showPreview = false;
  }
}