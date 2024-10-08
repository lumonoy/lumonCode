import { LightningElement } from 'lwc';
import preview from "./preview.html";
import LightningDatatable from 'lightning/datatable';

export default class FileDataTable extends LightningDatatable{
     static customTypes = {
    filePreview: {
      template: preview,
      typeAttributes: ["anchorText", "versionId"]
    }
  };
}