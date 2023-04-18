import { LightningElement, track} from 'lwc';
import getAccountForCombobox from '@salesforce/apex/accountHandler.accountHandlerOnCase';
import contactRelated from '@salesforce/apex/accountHandler.contactRelated';
import deleteContact from '@salesforce/apex/accountHandler.deleteContact';
import getContactData from '@salesforce/apex/accountHandler.getContactData';
const columns = [
    { label: 'Contact Name', fieldName: 'Name' },
    { label: 'Contact Email', fieldName: 'Email', type: 'Email' },
    { label: 'Contact Phone', fieldName: 'Phone', type: 'phone' },
    {
        label: 'Action',
        type: 'button-icon',
        typeAttributes: {
            iconName: 'utility:delete', 
            title: 'Delete', 
            variant: 'border-filled', 
            alternativeText: 'Delete', 
            name: 'delete' 
        } 
    }
]
const Page = 5;
export default class AccountData extends LightningElement {
@track value;
@track opptionArray = [];
@track cardVisible = false;
@track data = [];
@track isLoading = false;
@track currentPage = 1;
@track totalPage = 1;
@track displayUpdateData = [];

columns=columns;


get options(){
    return this.opptionArray;
}

connectedCallback(){
   this.loadAccountOpption();
   //this.loadContactdetails();
}
loadAccountOpption(){
    getAccountForCombobox()
    .then(response=>{
        let arr = [];
        for(var i=0; i<response.length; i++){
            arr.push({ label : response[i].Name, value : response[i].Id})
       //  console.log("arr"+label);
       // console.log("arr"+value);
        }
        
    this.opptionArray = arr;
    //console.log("Rai",JSON.stringify(this.opptionArray));
    })
}

// loadContactdetails(){
//     console.log('Value<<< ',this.value);
   
// }


handleOnChange(event){
    this.isLoading = true;
    console.log("inside the evnt");
     this.cardVisible = true;
                this.value = event.detail.value;
                //window.alert(JSON.stringify(this.value));
                console.log("man "+this.value);
                contactRelated({value : this.value})
                .then(result =>{
                    this.data = result;

                    this.totalPage = Math.ceil(this.data.length/Page);
                    this.isLoading = false;
                    console.log("Data " + JSON.stringify(this.data));
                    this.displayedData();
                })
                .catch(error =>{
                    window.alert("Error : "+ error);
                    
                })

    }
handleRowAction(event){
    const action = event.detail.action;
    console.log("action<<< : "+action.name);
    const row = event.detail.row;
    console.log("row: "+JSON.stringify(row));
    if(action.name == 'delete'){
        console.log("handleRowAction : ")
        this.deleteContact(row.Id);
    }
}

deleteContact(contactId){
    console.log("contactId : "+contactId);
    deleteContact({ contactId: contactId})
    .then(() =>{
        console.log('this is Refrash Part 1'); 
        this.loadContactDetails();
    })
    .catch(error=>{
        // window.alert("DeleteContact Error : "+ error);
        console.log('Error ',error);
    })
}

loadContactDetails(){
    console.log('this is Refrash Part 2');
    getContactData({ value: this.value})
    .then(result =>{
        this.data = result;
        this.totalPage = Math.ceil(this.data.length/Page);
    })
    .catch(error => {
        window.alert("loadContactDetails : "+ error);
    })
    }
handlePrevious(){
    if(this.currentPage >1){
        //this.currentPage--;
        this.currentPage = this.currentPage-1;
        this.displayedData();

    }
}
handleNext(){
    if(this.currentPage< this.totalPage){
        this.currentPage = this.currentPage+1;
        this.displayedData();
    }
}
displayedData(){
    this.displayUpdateData = [];
    console.log('hiii');
    const startIndex = (this.currentPage - 1) * Page;
    console.log("startIndex : " +startIndex);
    const endIndex = startIndex + Page;
    console.log("endIndex : " +endIndex);
    console.log(this.data.slice(startIndex, endIndex));
    this.displayUpdateData =  this.data.slice(startIndex, endIndex);
    console.log("displayUpdateData : " +this.displayUpdateData);
}


}