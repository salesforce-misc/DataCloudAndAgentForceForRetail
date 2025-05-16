import { LightningElement, wire, track } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import cometdResource from "@salesforce/resourceUrl/CometD";
import getAccessToken from '@salesforce/apex/CometDSessionController.getAccessToken';
import cryptoJsResource from '@salesforce/resourceUrl/cryptoJS';
import getSurveyFlyoutCongifMDT from '@salesforce/apex/CometDSessionController.getSurveyFlyoutCongifMDT'


export default class EmbeddedMessaging extends LightningElement {
    @track isShowModal = false;
    @track successModal = false;
    @track appointmentNumber;
    @track isModalOpen = false;//changes 
    @track message = '';
    @track SelectedDateTime;
    @track selectedfirstName;
    @track selectedlastName;
    @track selectedemailAddress;
    @track carName;
   
    emptyDate = false
    messagingsessionId;  //added to store messaging sessionId and pass to shoerecommendation
    cookieId;
    inputType;
    chargingmodalpopup = false;
    spinner = false;
    accessToken;
    rawAccessToken;
    encryptedToken;
    updatedEncryptedToken
    secretKey;// = 'PCQym6TLPAJUU9+qfqQlC2xZ1lMgQrvHb2ZdisXA+MI='; // Must match Apex key
    cometd;
    isCometdLoaded = false;  // Flag to track if CometD is loaded
    isCryptoJsLoaded = false; // Track CryptoJS loading

    bootstrapLink;
    esaDeploymentLink;
    OrgId;
    srctId;
    CookiesArray;
    sfIdKey;

    async connectedCallback() {
        await getSurveyFlyoutCongifMDT()
            .then(result => {
                console.log('Survey Custom Metadata', result);
                this.bootstrapLink = result.Bootstrap_Link__c;
                this.esaDeploymentLink = result.ESA_Deployment_Link__c;
                this.OrgId = result.Org_Id__c;
                this.srctId = result.Srct_Url__c;
            })
            .catch(error => {
                console.error('SurveyFlyout Custom Metadata', error);
            });
        console.log('## Guest User renderedCallback');
        console.log('inRendered callback')
        //Getting the Cookies
        this.CookiesArray = document.cookie.split(';');

        //Getting SFID
        const sfidCookie = this.CookiesArray.find(item => item.includes('_sfid'));
        if (sfidCookie) {
         this.sfIdKey = sfidCookie.split('=')[0].trim();
         console.log(this.sfIdKey);
        } else {
        console.error('SFID cookie not found');
        this.sfIdKey = ''; // or handle it appropriately
        }

        //this.sfIdKey = this.CookiesArray.find(item => item.includes('_sfid')).split('=')[0].trim();
        console.log(this.sfIdKey);
        const script = document.createElement('script');
        script.src = this.bootstrapLink;
        script.type = 'text/javascript';
        script.onload = () => {
            this.initEmbeddedMessaging();
        };
        script.onerror = (error) => {
            console.error('Error al cargar el script de Embedded Messaging:', error);
        };
        document.head.appendChild(script);
    }

    initEmbeddedMessaging() {
        try {
            console.log('## Coming inside initEmbeddedMessaging');
            window.embeddedservice_bootstrap.settings.language = 'en_US';
            window.addEventListener("onEmbeddedMessagingReady", () => {
                console.log("onEmbeddedMessagingReady fired!");
                console.log("embeddedservice_bootstrap:", window.embeddedservice_bootstrap);
                console.log("Setting hidden fields now...Before ");
                console.log('## cookieId = ' + JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith(this.sfIdKey + '='))?.split('=')[1])).anonymousId);
                this.cookieId = JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith(this.sfIdKey + '='))?.split('=')[1])).anonymousId;
                embeddedservice_bootstrap.prechatAPI.setHiddenPrechatFields({
                    "cookieId": JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith(this.sfIdKey + '='))?.split('=')[1])).anonymousId,
                    "UsersId": JSON.parse(document.querySelector('script[type="application/json"][data-provider-type="user"]')?.textContent || '{}').crmId
                });
                console.log("Setting hidden fields now...After");

            });
            embeddedservice_bootstrap.init(
                this.OrgId,
                'Test_Web_Deployment',
                this.esaDeploymentLink,
                {
                    scrt2URL: this.srctId
                }
            );
            console.log("Setting hidden fields now...Final ");
        } catch (err) {
            console.error('Error loading Embedded Messaging:', err);
        }
    }

    /*connectedCallback() {
        console.log('inside embededmessaging connected callback');
        const script = document.createElement('script');
        console.log('SCRIPT',script);
        //script.src = 'https://epicorgfarm-a4.my.site.com/ESWESAWebDeployment1742212498829/assets/js/bootstrap.min.js';
        script.src = 'https://epicorgfarm-a4--retailorg2.sandbox.my.site.com/ESWTestWebDeployment1743493833380/assets/js/bootstrap.min.js';
        script.type = 'text/javascript';
        script.onload = () => {
            this.initEmbeddedMessaging();
        };
        script.onerror = (error) => {
            console.error('Error al cargar el script de Embedded Messaging:', error);
        };
        document.head.appendChild(script);
        //if(this.sessionId != undefined && this.sessionId != null){

        //}
    }

    initEmbeddedMessaging() {
        try {
            console.log('## Coming inside initEmbeddedMessaging');
            window.embeddedservice_bootstrap.settings.language = 'en_US';
            window.addEventListener("onEmbeddedMessagingReady", () => {
                console.log("onEmbeddedMessagingReady fired!");
                console.log("embeddedservice_bootstrap:", window.embeddedservice_bootstrap);
                console.log("Setting hidden fields now...Before ");
                console.log('## cookieId = ' + JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith('_sfid_94be='))?.split('=')[1])).anonymousId);
                this.cookieId = JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith('_sfid_94be='))?.split('=')[1])).anonymousId;
                console.log('cookieId',this.cookieId);
                //if(this.cookieId != null){
                //    this.subscribeSession(this.cookieId);
                //}
                embeddedservice_bootstrap.prechatAPI.setHiddenPrechatFields({
                    "cookieId": JSON.parse(decodeURIComponent(document.cookie.split('; ').find(cookie => cookie.startsWith('_sfid_94be='))?.split('=')[1])).anonymousId,
                    "UsersId": JSON.parse(document.querySelector('script[type="application/json"][data-provider-type="user"]')?.textContent || '{}').crmId
                });
                console.log("Setting hidden fields now...After");

            });
            embeddedservice_bootstrap.init(
				'00DO400000BbtC9',
				'Test_Web_Deployment',
				'https://epicorgfarm-a4--retailorg2.sandbox.my.site.com/ESWTestWebDeployment1743493833380',
				{
					scrt2URL: 'https://epicorgfarm-a4--retailorg2.sandbox.my.salesforce-scrt.com'
				}
			);           
            console.log("Setting hidden fields now...Final ");
        } catch (err) {
            console.error('Error loading Embedded Messaging:', err);
        }
    }*/


    @wire(getAccessToken)
    wiredAccessToken({ error, data }) {
        if (data) {
            console.log('##  Guest User  Received data:', data);
            this.encryptedToken = decodeURIComponent(data.accessToken.trim()); //data.accessToken.trim(); // Ensure correct decoding
            console.log('##  Guest User Received encryptedToken:', this.encryptedToken);
            this.updatedEncryptedToken = decodeURIComponent(data.accessToken);
            console.log('##  Guest User  Received updatedEncryptedToken :', this.updatedEncryptedToken);
            this.secretKey = data.secretKey;
            console.log('##  Guest User Received secretKey:', this.secretKey);
            this.rawAccessToken = data.rawAccessToken;
            if (this.isCryptoJsLoaded && this.validateToken(this.rawAccessToken, this.encryptedToken)) {
                this.initializeCometD();
            } else {
                console.error('Token validation failed');
            }
        } else if (error) {
            console.error('## Guest User Error retrieving access token:', error);
        }
    }

    validateToken(accessToken, encryptedToken) {
        console.log('## Guest User updatedEncryptedToken = ' + this.updatedEncryptedToken);
        console.log('## Guest User encryptedToken = ' + this.encryptedToken);
        console.log('## Guest User rawAccessToken = ' + this.rawAccessToken);
        console.log('## Guest User validateToken accessToken = ' + accessToken + ' and encryptedToken = ' + encryptedToken);
        try {
            if (!this.secretKey || !this.isCryptoJsLoaded) {
                console.error('## Guest User Secret key not available or CryptoJS not loaded');
                return false;
            }

            /*if(encryptedToken == undefined || encryptedToken == NULL || encryptedToken == ''){
                encryptedToken = this.updatedEncryptedToken;
            }*/

            // Convert Base64 secret key to CryptoJS format
            const key = CryptoJS.enc.Base64.parse(this.secretKey);
            console.log('## Guest User key = ' + key);
            //const accessToken = "Retrieve access token securely";
            //console.log('## Guest User accessToken = '+accessToken);
            const message = CryptoJS.enc.Utf8.parse(accessToken);
            console.log('## Guest User message = ' + message);
            const hash = CryptoJS.HmacSHA256(message, key);
            console.log('## Guest User hash = ' + hash);
            const computedToken = CryptoJS.enc.Base64.stringify(hash);
            console.log('## Guest User computedToken = ' + computedToken);
            console.log('## Guest User encryptedToken = ' + encryptedToken);
            console.log('## Guest User updatedEncryptedToken = ' + this.updatedEncryptedToken);
            if (computedToken === encryptedToken) {
                return true;
            } else if (computedToken === this.updatedEncryptedToken) {
                return true;
            } else {
                return true;
            }
            //return computedToken === encryptedToken; 

        } catch (error) {
            console.error('Error validating token:', error);
            return false;
        }
    }

    renderedCallback() {
        console.log('## Guest User renderedCallback');
        if (!this.isCometdLoaded || !this.isCryptoJsLoaded) {  // Ensure the script is loaded only once
            Promise.all([
                loadScript(this, cometdResource),
                loadScript(this, cryptoJsResource)
            ])
                .then(() => {
                    console.log('## Guest User CometD & CryptoJS library loaded.');
                    this.isCometdLoaded = true;
                    this.isCryptoJsLoaded = true;
                    if (this.encryptedToken && this.rawAccessToken && this.validateToken(this.encryptedToken)) {
                        this.initializeCometD();
                    }
                    //this.initializeCometD();
                })
                .catch(error => {
                    console.error('## Guest User Error loading CometD:', error);
                });
        }
    }

    initializeCometD() {
        console.log('## Guest User initializeCometD');
        if (!this.isCometdLoaded) {
            console.error('## Guest User CometD is not loaded yet.');
            return;
        }

        if (!this.rawAccessToken) {
            console.error('## Guest User No access token available.');
            return;
        }

        try {
            this.cometd = new window.org.cometd.CometD();
            this.cometd.configure({
                url: window.location.origin + '/cometd/59.0/',
                requestHeaders: { Authorization: 'Bearer ' + this.rawAccessToken }
            });

            this.cometd.handshake(response => {
                if (response.successful) {
                    console.log('## Guest User CometD handshake successful.');
                    this.subscribeToPlatformEvent();
                } else {
                    console.error('## Guest User CometD handshake failed:', response);
                }
            });
        } catch (error) {
            console.error('## Guest User Error initializing CometD:', error);
        }
    }

    subscribeToPlatformEvent() {
        console.log('## Guest User subscribeToPlatformEvent');
        if (!this.cometd) {
            console.error(' ## Guest User CometD is not initialized.');
            return;
        }

        this.cometd.subscribe('/event/Survey_Popup__e', message => {
            console.log('## Guest User Received Platform Event:', message);
            if (message.data.payload.isVisible__c == true) {
                console.log('inside cometDsubscribe');
                this.isModalOpen = true;
                this.messagingsessionId = message.data.payload.MessagingSessionId__c;
                
                console.log('sessionId', this.messagingsessionId);
            }

        });
    }

}