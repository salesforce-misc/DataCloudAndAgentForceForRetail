import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue} from 'lightning/uiRecordApi';
import getAccountDetails from '@salesforce/apex/GetAccounts.getAccountDetails';


import LIFETIME_VALUE from '@salesforce/schema/Contact.LifetimeValue__c';

const fields = [ 
    LIFETIME_VALUE
    ];

export default class CustomerMetrics extends LightningElement {

        @api recordId;
          
          @wire(getAccountDetails, { accountId: '$recordId' })
          account;

          get hasData() {
            return this.account?.data !== undefined;
           }
        
          get error() {
                return this.account?.error;
            }
        
          get name() {
                return this.account?.data?.Name;
            }

            get lifetimeValue() {
                const value = this.account?.data?.Contacts?.[0]?.LifetimeValue__c;
                return (value || value === 0) ? (Math.round(value * 100) / 100) : '';
            }
            
          
            get averagePurchase() {
                const value = this.account?.data?.Contacts?.[0]?.AveragePurchaseValue__c;
                return (value || value === 0) ? (Math.round(value * 100) / 100) : '';
            }

            get propensityToChurn() {
                const value = this.account?.data?.Contacts?.[0]?.Propensity_To_Churn__c;
                return (value || value === 0) ? (Math.round(value * 100) / 100) : '';
            }
    
     
       /* @wire(getRecord, { recordId: '$recordId', fields })
        contact;
    
        get hasData() {
            return this.contact?.data !== undefined;
        }
    
        get error() {
            return this.contact?.error;
        }

        get lifetimeValue() {
                const value = getFieldValue(this.contact.data, LIFETIME_VALUE);
                return value ? value.toLocaleString() : '';
        }*/
            
}