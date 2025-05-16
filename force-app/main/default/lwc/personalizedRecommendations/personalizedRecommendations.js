import { LightningElement, api, wire, track } from 'lwc';
import getProducts from '@salesforce/apex/GetPersonalizedNames.getProducts';
import sendRecommendationEmail from '@salesforce/apex/GetPersonalizedNames.sendRecommendationEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import UltraRunBreeze from '@salesforce/resourceUrl/UltraRunBreeze';
import MenChilkatNylonBoots from '@salesforce/resourceUrl/MenChilkatNylonBoots';
import FurnaceSleepingBags from '@salesforce/resourceUrl/FurnaceSleepingBags';
import Northstar from '@salesforce/resourceUrl/Northstar';
import HomesteadRoomy from '@salesforce/resourceUrl/HomesteadRoomy';
import Triarch from '@salesforce/resourceUrl/Triarch';
import Stormbreak from '@salesforce/resourceUrl/Stormbreak';
import Talus4 from '@salesforce/resourceUrl/Talus4';
import NewBalanceFresh from '@salesforce/resourceUrl/NewBalanceFresh';
import AeroCushionElite from '@salesforce/resourceUrl/AeroCushionElite';
import HomesteadShelter from '@salesforce/resourceUrl/HomesteadShelter';
import HomesteadDomey3Tent from '@salesforce/resourceUrl/HomesteadDomey3Tent';
import MenSafienMidGtxHikingShoes from '@salesforce/resourceUrl/MenSafienMidGtxHikingShoes';
import DuramoSpeedShoes from '@salesforce/resourceUrl/DuramoSpeedShoes';


const IMAGE_MAP = {
    UltraRunBreeze: UltraRunBreeze,
    MenChilkatNylonBoots: MenChilkatNylonBoots,
    FurnaceSleepingBags :FurnaceSleepingBags,
    Northstar : Northstar,
    HomesteadRoomy : HomesteadRoomy,
    Triarch : Triarch,
    Stormbreak : Stormbreak,
    Talus4 : Talus4 ,
    NewBalanceFresh : NewBalanceFresh,
    AeroCushionElite : AeroCushionElite ,
    HomesteadShelter : HomesteadShelter,
    HomesteadDomey3Tent : HomesteadDomey3Tent,
    MenSafienMidGtxHikingShoes : MenSafienMidGtxHikingShoes,
    DuramoSpeedShoes : DuramoSpeedShoes
};



export default class PersonalizedRecommendations extends LightningElement {
    @api productIds; 
    @api recordId;  
    @track productList = [];

    // Fetch products from Apex method
  /*  @wire(getProducts, { productIds: '$cleanedIds' })
    wiredProducts({ error, data }) {
        if (data) {
            this.productList = data.map(product => ({
                id: product.id,
                name: product.name,
                //imageUrl: product.imageUrl,
                description: product.description,
                imageUrl: IMAGE_MAP[product.imageUrl] || DuramoSpeedShoes
            }));
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }*/

    @wire(getProducts, { productIds: '$cleanedIds' })
     wiredProducts({ error, data }) {
     if (data) {
        this.productList = data.map(product => {
            const resolvedUrl = IMAGE_MAP[product.imageUrl] || DuramoSpeedShoes;

            console.log('Product:', product.name);
            console.log('Original Static Resource Name:', product.imageUrl);
            console.log('Resolved Image URL:', resolvedUrl);

            return {
                id: product.id,
                name: product.name,
                description: product.description,
                imageUrl: resolvedUrl
            };
        });
    } else if (error) {
        console.error('Error fetching products:', error);
    }
}

    get cleanedIds() {
        return this.extractIds(this.productIds);
    }

    extractIds(data) {
        const idRegex = /ssot__Id__c:([a-zA-Z0-9]+)/g;
        const ids = [];
        let match;
        while ((match = idRegex.exec(data)) !== null) {
            ids.push(match[1]);
        }
        return ids;
    }

    handleRecommendClick(event) {
        const productId = event.target.dataset.id;
        const productName = event.target.dataset.name;
        const productDescription = event.target.dataset.description;

        console.log('Product ID:', productId);
        console.log('Product Name:', productName);
        console.log('Product Description:', productDescription);
        console.log('ACcount Id:',this.recordId);

        sendRecommendationEmail({
            accountId: this.recordId,  
            productId,
            productName,
            productDescription
        })
        .then(() => {
            console.log('Recommendation sent successfully');

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: `Recommendation for ${productName} sent successfully!`,
                    variant: 'success',
                })
            );
        })
        .catch(error => {
            console.error('Error sending recommendation:', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'There was an error sending the recommendation.',
                    variant: 'error',
                })
            );
        });
    }
}