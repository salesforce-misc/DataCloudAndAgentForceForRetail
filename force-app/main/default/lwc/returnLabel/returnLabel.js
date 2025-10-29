import { LightningElement,api,wire,track } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import CometD from "@salesforce/resourceUrl/CometD";
import fetchSessionId from '@salesforce/apex/CometDSessionController.fetchSessionId';
import getSurveyFlyoutCongifMDT from '@salesforce/apex/CometDSessionController.getSurveyFlyoutCongifMDT';
export default class ReturnLabel extends LightningElement {
    @track isShowModal ;
    contactId  ;
   // productId;
   sessionId;
   cometDLib;
    returnLabelUrl;
    
    connectedCallback() {
        console.log('## Page URL List returnlabel = '+window.location.href);
        this.fetchConfig();
      }
    
    @wire( fetchSessionId )
    wiredSessionId( { error, data } ) {
        console.log('returnlabel flyout',data,error)
        if ( data ) {
            this.sessionId = data;
            this.error = undefined;
            console.log('sessionid returnlabel ->'+this.sessionId);
            
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
                    console.log( 'Status of returnlabel',  JSON.stringify(   status     )
                    );
                    if ( status.successful ) {
                        var subsrip = cometDLib.subscribe('/event/returnLabelEvent__e', function( message ) {
                          console.log('message 00 returnlabel->'+JSON.stringify(message));
                          console.log('Subscrip returnlabel',subsrip);
                            console.log('modalpopup flyout',lwcThisContext.modalpopup );
                          setTimeout(function(){
                           lwcThisContext.isShowModal = true;
                           lwcThisContext.contactId = message.data.payload.contactId__c;
                         
                           console.log('CONTACT ID', lwcThisContext.contactId);
                          
                          
                         }, 10000);
                         
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


    fetchConfig() {
        getSurveyFlyoutCongifMDT()
            .then((result) => {
                if (result) {
                    this.returnLabelUrl = result.returnLabelVFPageUrl__c;
                    console.log('Return Label VF URL: ', this.returnLabelUrl);
                }
            })
            .catch((error) => {
                console.error('Error fetching config:', error);
            });
    }

    handleOnClickDownload(){
        const contact = this.contactId;
        //String sitePrefix = URL.getSalesforceBaseUrl().toExternalForm();
        const ulrvf = window.location.origin;
        console.log('VF PAGE URL',ulrvf);
        //const vfpageURL = `${window.location.origin}/apex/ReturnLabelPage?contactId=${this.contactId}`;
        const vfpageURL = `https://epicorgfarm-a4--retailorg2--c.sandbox.vf.force.com/apex/ReturnLabelPage?contactId=${this.contactId}`;
        
        
        const baseURL = ulrvf.replace('.my.site.com', '.vf.force.com'); 
        const VFMainPage = this.returnLabelUrl + `/apex/ReturnLabelPage?contactId=${this.contactId}`;
        console.log('CONTACT ID',contact);
        //console.log('VF PAGE URL',vfpageURL);
        console.log('VF MAIN PAGE URL',VFMainPage);
        window.open(VFMainPage, '_blank');
    }
}