import { LightningElement, track, api } from 'lwc';
export default class AccountContact extends LightningElement {
    @track indexNumber = 1;
    
    @track contList = [
        {  LastName: '', Email: '', Phone: '', serialNumber : this.indexNumber},
        
    ];
    @api recordId;

    get disAbled()
    {
        return this.contList.length>1 ? false : true;
    }

    change(event)
    {
        if(event.target.name === 'LastName')
        {
            this.contList[event.target.accessKey] = event.target.value;
        }
        if(event.target.name === 'Email')
        {
            this.contList[event.target.accessKey] = event.target.value;
        }
        if(event.target.name === 'Phone')
        {
            this.contList[event.target.accessKey] = event.target.value;
        }
    }

    handleAdd(event) {
        this.indexNumber++;
        console.log('inside add');
        let obj = [{  LastName: '', Email: '', Phone: '' }];
        if(this.contList.length>1)
        {
            obj.index = this.contList[this.contList.length-1].index+1;
        }
        else
        {
            obj.index = 1;
        }
        obj.serialNumber = this.indexNumber;
        this.contList.push(obj); 
        this.indexNumber = 1;
        this.contList.forEach(element =>
            {
                element.serialNumber = this.indexNumber;
                this.indexNumber++;
            })
    }

    handleDelete(event) {
        this.indexNumber = 1;
        var row = event.target.dataset.index;
        console.log('Row deleted: ' + row);
        if(this.contList.length>1)
        {
            this.contList.splice(row, 1);
            console.log(this.contList);
            this.contList.forEach(element =>
                {
                    element.serialNumber = this.indexNumber;
                    this.indexNumber++;
                });
        }        
        console.log('Delete recordId:', recordId);
    }
//handleSave(){

  //      .this

  //  }

}

