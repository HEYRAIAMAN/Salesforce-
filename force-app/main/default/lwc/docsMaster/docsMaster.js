import { LightningElement, api, track } from 'lwc';
import docMasterRecord from '@salesforce/apex/DocMaster.docMasterRecord'
import docUpload from '@salesforce/apex/DocMaster.docUpload'

export default class DocMaster extends LightningElement {
    @api recordId;
    @track data=[];
    @track indexnumber = 1;
    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    connectedCallback(){
        this.loadRelatedDocsMaster();
    }

    loadRelatedDocsMaster(){
     //  console.log('insideClassCAll'+this.recordId);
        docMasterRecord({recordId :  this.recordId})
        .then(results=>{
            this.data=results;
            this.isError=false;
           console.log('inside'+this.recordId);
        })
        .catch(error=>{
            this.isError = true;
            this.errorErrorMessage=error.body.message;
        });
    }

    handleUploadFinished(event){
       // console.log('On Finish');
        var docId;
        var uploadedFiles = event.detail.files;
        uploadedFiles.forEach(element => {
           docId = element.contentVersionId;  
        });
//console.log('file : '+JSON.stringify(uploadedFiles));
        docUpload({ uploadedFiles: docId, recordId: this.recordId })
        .then(result => {
    
            console.log('Document uploaded successfully:', result);
        })
         .catch(error => {
            
            console.error('Error uploading document:', error);
        
         });
    }
  
    }