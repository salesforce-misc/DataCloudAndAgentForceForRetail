import { LightningElement,api,track,wire } from 'lwc';
import getInstalledPackageDetails from '@salesforce/apex/DataCloudSetupButtonController.getInstalledPackageDetails';
import orgSetupOnButtonClicked from '@salesforce/apex/DataCloudSetupButtonController.orgSetupOnButtonClicked';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class DataCloudSetupButton extends LightningElement {
 
 
@track datafromapex;
@track error; 
@track isToggled = false;
@track isSunSHineToggled = false;
isPackageInstalled;
 
@track disableConnectOrg = true;
@track isCheckboxChecked = false;
@track checkboxClass = ''; 
apexResult = {}; 
 
//SetUp Steps
@track steps =[ 
    {id:1, title: 'Assign Permissions For Standard And Custom Object', description:'(Assign Read Access to Data Cloud Salesforce Connector Permission Set on Retail object , Create an AgentUser, Create a Custom Field, Provide access to contact on Customer 360 Data Platform Integration Permission set )', buttonLabel:'Assign Permissions For Objects', active:true, disable: false},
    {id:2, title: 'Create Commerce Related Sample Data', description:'(Create Sample test data for commerce)', buttonLabel:'Create Commerce Data', active:false,disable: false},
    {id:3, title: 'Create Test Data', description:'(Create Retail Sample data)', buttonLabel:'Create Test Data', active:false,disable: false},
    {id:4, title: 'Create Order and Orderitem', description:'(Create Data for Order and OrderItems)', buttonLabel:'Create order and orderitem', active:false, disable: false},
    {id:5, title: 'Create Buyer Group Member', description:'(Create Buyer Group Member For Commerce)', buttonLabel:'Create Buyer Group Member Data', active:false,disable: false},   
    {id:6, title: 'Create Data For ML', description:'(Create data for ML)', buttonLabel:'Create ML Data', active:false, disable: false},
    
]  
 
connectedCallback(){
    this.fetchInstalledPackageDetails();
}
 
fetchInstalledPackageDetails(){
    getInstalledPackageDetails()
        .then(data =>{
            this.apexResult = data;
            console.log('## apexResult = '+JSON.stringify(this.apexResult));
            this.steps = this.steps.map(step => {  
                console.log('step lable', step.buttonLabel);
                if(this.apexResult[step.buttonLabel] !== undefined){
                    console.log('result value', this.apexResult[step.buttonLabel]);
                    if(this.apexResult[step.buttonLabel] === true){
                        step.disable = false;
                    }else if(this.apexResult[step.buttonLabel] === false){
                        step.disable = true;
                    }
                }   
                console.log('## apexResult = '+JSON.stringify(step));           
                return step;
            });
            /*this.steps = this.steps.map(step => ({                
                ...step,
                disable: this.apexResult[step.buttonLabel] !== undefined ? this.apexResult[step.buttonLabel] : step.disable
            }))*/
        })
        .catch(error => {
            this.error = error;
            console.error('Error Data:', error);
        });
}
 
handleClick(event){
    console.log('## Event Button Id = '+event.target.dataset.id);
    console.log('## Event Button buttonLabel = '+event.target.label);
    console.log('## Event Button this.steps = '+JSON.stringify(this.steps));
    const clickedButtonId = event.target.dataset.id;
    const clickedButtonLabel = event.target.label;
 
    this.steps = this.steps.map(step =>{
        console.log('## clickedButtonId = '+clickedButtonId);
        console.log('## step = '+JSON.stringify(step));
        console.log('## step.id = '+step.id);
        if(String(step.id) == String(clickedButtonId)){
            step.disable = true
            //return { ...step, disable: true};
        }
        return step;
    });
   
    orgSetupOnButtonClicked({ buttonId: clickedButtonId, buttonLabel: clickedButtonLabel})
    .then(() =>{
        if(this.isCheckboxChecked == true)
            {this.isCheckboxChecked= false;}
        else
        {this.isCheckboxChecked= true;}
        console.log('## Apex Method executed succesfully for the Button Id = '+ clickedButtonId);
        const toastMessage = clickedButtonLabel + ' executed successfully';
        this.showToast('Success', toastMessage, 'success');
    })
    .catch(error => {
        this.showToast('Error', 'An error is coming while processinng the request', 'error');
        this.error = error;
        console.error('Error Data:', error);
        console.error('Error Message Body :', error.body);
    })
}
 
showToast(title, message, variant){
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
}
   
}