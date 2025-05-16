import {LightningElement , api, wire, track} from 'lwc';
import getRecentProducts from '@salesforce/apex/RecentPurchaseController.getRecentProducts';
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

export default class RecentPurchaseHistory extends LightningElement {

    @api recordId;;
    @track products;
    @track error;
    @track isLoading = true;

      /* @wire(getRecentProducts, { accountId: '$recordId' })
    wiredProducts({ error, data }) {
     console.log('Account ID:', this.recordId);
        console.log('Data',data);
        this.isLoading = false;
        if (data) {
            this.products = data;
            console.log('Products:',this.products);
            this.error = null;
        } else if (error) {
            this.error = error.body.message;
            this.products = null;
        }
    }*/

        @wire(getRecentProducts, { accountId: '$recordId' })
        wiredProducts({ error, data }) {
            console.log('Account ID:', this.recordId);
            this.isLoading = false;
    
            if (data) {
                this.products = data.map(item => {
                    const resolvedUrl = IMAGE_MAP[item.imageUrl] || DefaultImage;
    
                    console.log('Product:', item.productName);
                    console.log('Static Resource Name:', item.imageUrl);
                    console.log('Resolved Image URL:', resolvedUrl);
    
                    return {
                        ...item,
                        imageUrl: resolvedUrl
                    };
                });
    
                this.error = null;
            } else if (error) {
                console.error('Error fetching recent products:', error);
                this.error = error.body?.message || 'Unknown error';
                this.products = null;
            }
        }
}