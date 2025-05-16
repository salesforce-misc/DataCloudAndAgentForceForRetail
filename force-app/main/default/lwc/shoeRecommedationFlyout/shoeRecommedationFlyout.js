import { LightningElement, track,wire,api } from 'lwc';
import  getMetadataRecords from '@salesforce/apex/CustomMetadataController.getMetadataRecords';
import  getPromptResponse from '@salesforce/apex/GetShoeRecommendation.getPromptResponse';
import  createRecords from '@salesforce/apex/CreateSurveyResponse.createRecords';
import { NavigationMixin } from 'lightning/navigation';
//import {createRecord} from 'lightning/uiRecordApi';
import SURVEYRESPONSE_OBJECT from '@salesforce/schema/SurveyResponse__c';
import QUESTION_FIELD from'@salesforce/schema/SurveyResponse__c.Question__c';
import RESPONSE_FIELD from'@salesforce/schema/SurveyResponse__c.Response__c';
import NAME_FIELD from '@salesforce/schema/SurveyResponse__c.Name';
import COOKIEID_FIELD from '@salesforce/schema/SurveyResponse__c.CookieId__c';
 
export default class ShoeRecommedationFlyout extends NavigationMixin (LightningElement) {
    value = '';
    @track formattedData = [];
    RecordArray=[];
    AcookieId;
   // @api messagingsessionid;
    MSessionId;
    @track DisplayRecommendation = false;
    @track displaySurvey= true;
    recommendedResponse;
    @api isModalOpen = false;//making changes
    @api isModalOpenForRecommendations = false;
 
    @api
    get cookieid(){
        return this.AcookieId;
    }
    set cookieid(value){
        this.AcookieId= value;
        console.log('received CookieId',this.AcookieId);
    }
 
 
 
     @api
     get messagingsessionid() {
      return this.MSessionId;
     }
 
     set messagingsessionid(value) {
        console.log('received value',value);
        this.MSessionId = value;
        console.log('received sessionId',this.MSessionId);
 
     }
 
    //fetching custom metadatas through getrecord and formatting the receive data to be nested q:{op1, op2} for radiobutton
    @wire(getMetadataRecords)
    wiredCustomMetadata({ error, data }) {
        if (data) {
            console.log('Custom Metadata Records:', JSON.stringify(data));
            this.formattedData = data.map(record => ({
                question: record.Questions__c,
                optionsFormatted:[
                    {label: record.Option1__c, value: record.Option1__c},
                    {label: record.Option2__c, value: record.Option2__c},
                    {label: record.Option3__c, value: record.Option3__c},
                    {label: record.Option4__c, value: record.Option4__c}
                ].filter(option => option.label) //remove the null option value
 
            })) ;
            console.log('the formatted data', JSON.stringify(this.formattedData));
        }
            else if (error) {
            console.error('Error retrieving custom metadata:', error);
        }
    }
 
    handleOptionChange(event) {
        this.selectedOption= event.detail.value;
        const question = event.target.name;
        const record = {Question__c:question, Response__c:this.selectedOption, MessagingSessionId__c: this.MSessionId, CookieId__c : this.AcookieId, Name:'id-' + Math.random().toString(36).substr(2, 9) };
        console.log('record', JSON.stringify(record));
        console.log('optionchange',this.selectedOption);
        console.log('questionId',question);
        this.RecordArray.push(record);
        console.log('new record selected', JSON.stringify(this.RecordArray));
    }
 
    handleSubmit(){
        console.log('insdie handlesubmit');
        this.isModalOpen=false;
        this.displaySurvey= false; //hinding thequestions
        //this.isModalOpenForRecommendations= true; //rendering the prompttemplate output
        this.CreateSurveyResponse(this.RecordArray);  //SurveyResponse record creation call    
    }
    handleClickRow(){
        this.isModalOpen=false;
        this.displaySurvey= false;
        this.isModalOpenForRecommendations= false;
    }
 
 
    //invocation of prompt template
    Displayshoe(){
        console.log('sessionId',this.MSessionId);
        getPromptResponse({ sessionId: this.MSessionId })
        .then(result => {
            console.log('result for recommend product',JSON.stringify(result));
            this.recommendedResponse = result;
            this.isModalOpenForRecommendations= true;
            this.DisplayRecommendation = true;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.accounts = undefined;
        })
    }
   
 
    CreateSurveyResponse(RecordArray){
        console.log('inside create record');
       
        console.log('recordArray',this.RecordArray);
 
            //calling createsurveyresponse apex
           
    createRecords({ SurveyResponses: this.RecordArray })
    .then(result => {
        console.log('Survey Responses created successfully',result);
        this.Displayshoe();
     })
     .catch(error => {
        console.error('Error creating Survey Responses: ', error);
    });
 
    }
   
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        
    }
    CloseRecommendation(){
        this.isModalOpenForRecommendations= false;
    }
}