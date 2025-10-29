import { LightningElement,track,wire } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import CometD from "@salesforce/resourceUrl/CometD";
import fetchSessionId from '@salesforce/apex/CometDSessionController.fetchSessionId';
import weatherBasedProduct from '@salesforce/apex/weatherBasedProduct.recommendProducts';
const columns = [
    { 
        label:'Name',
        fieldName: 'productLink',
        type:'url',
        typeAttributes: {
            label: { 
                fieldName: 'productName'
            },
            target : '_self'
        }
    }
];
export default class WeatherProdRecommendation extends LightningElement {
    @track isShowModal = false;
    @track productRecommendations = [];
    @track weatherCondition;
    sessionId;
    cometDLib;

    connectedCallback() {
        console.log('## Page URL List WeatherShoeRecommendationFlyout = '+window.location.href);
      }
    
    @wire( fetchSessionId )
    wiredSessionId( { error, data } ) {
        console.log('data flyout',data,error)
        if ( data ) {
            this.sessionId = data;
            this.error = undefined;
            console.log('sessionid ->'+this.sessionId);
            
            loadScript( this, CometD )
            .then( () => {
                let cometDLib = new window.org.cometd.CometD();
                cometDLib.configure( {
                    url: window.location.protocol + 
                        '//' + window.location.hostname
                        + '/cometd/40.0/',
                    requestHeaders: { 
                        Authorization: 'OAuth ' + 
                        this.sessionId 
                    },
                    appendMessageTypeToURL : false,
                    logLevel: 'debug'
                } );
                cometDLib.websocketEnabled = false;
                var lwcThisContext = this;
                cometDLib.handshake( function( status ) {      
                    console.log( 'Status of flyout',  JSON.stringify(   status     )
                    );
                    if ( status.successful ) {
                        var subsrip = cometDLib.subscribe('/event/WeatherBasedShoeFlyout__e', function( message ) {
                          console.log('message 00->'+JSON.stringify(message));
                          console.log('Subscrip flyout',subsrip);
                            console.log('modalpopup flyout',lwcThisContext.modalpopup );
                          setTimeout(function(){
                           lwcThisContext.isShowModal = true;
                           lwcThisContext.weatherCondition = message.data.payload.WeatherCondition__c;
                           console.log('Weather Condition', lwcThisContext.weatherCondition);
                           lwcThisContext.getRecommendations();
                         }, 5000);
                         
                         lwcThisContext.isShowModal = false;
                        });
                        //cometDLib.unsubscribe(subsrip);
                    } else {
                        console.error(
                            'Error in handshaking flyout:', 
                            JSON.stringify(
                                status
                            )
                        );
                    }

                } );
                
            } );

        } else if ( error ) {
            console.log('Error occurred in loading script');
            console.log(JSON.stringify(error) );
            this.sessionId = undefined;
        }
    }
    //Product Details
    getRecommendations() {
        weatherBasedProduct({ weatherCondition: this.weatherCondition })
            .then(result => {
                if (Object.keys(result).length === 0) {
                    console.log('empty product -->');
                }
                else{
                const rows = JSON.parse(JSON.stringify(result));
                this.productRecommendations = rows.map(row => { 
                    return {
                        Id: row['ssot__Id__c'],
                        Name: row['ssot__Name__c'],
                        Description: row['ssot__Description__c'],
                        prodLink: "/outfitters/product/" + row['ssot__Id__c']
                    };
                })
                console.log('Product Recommendations:', this.productRecommendations);
            }
            })
            .catch(error => {
                console.error('Error fetching product recommendations:', error);
            });
    }
}