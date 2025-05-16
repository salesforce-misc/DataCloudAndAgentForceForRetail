import { LightningElement, track ,wire} from 'lwc';
import getProductDetail from '@salesforce/apex/Product_OrderController.getProductDetail';
import getMostRecentPurchase from '@salesforce/apex/Product_OrderController.getMostRecentPurchase';
import { loadScript } from "lightning/platformResourceLoader";
import CometD from "@salesforce/resourceUrl/CometD";
import fetchSessionId from '@salesforce/apex/CometDSessionController.fetchSessionId';

export default class ShoeComparisonFlyout extends LightningElement {
@track isModalOpen = false;
@track datas = [];
ChosenShoe;
RecentOrder;
product1;
product2;
@track weatherCondition;
sessionId;
cometDLib;
ProductId;
ContactId;

connectedCallback() {
console.log('## Page URL List Comparison = ' + window.location.href);
}

// Fetch session ID and initialize CometD
@track mostRecentPurchasedShoeId;
@track SelectedShoeId;

@wire(fetchSessionId)
wiredSessionId({ error, data }) {
console.log('comparison flyout', data, error);
if (data) {
this.sessionId = data;
this.error = undefined;
console.log('sessionid ->' + this.sessionId);

loadScript(this, CometD).then(() => {
let cometDLib = new window.org.cometd.CometD();
cometDLib.configure({
url: window.location.protocol + '//' + window.location.hostname + '/cometd/40.0/',
requestHeaders: {
Authorization: 'OAuth ' + this.sessionId
},
appendMessageTypeToURL: false,
logLevel: 'debug'
});
cometDLib.websocketEnabled = false;
var lwcThisContext = this;
cometDLib.handshake(function (status) {
console.log('Status of comparison flyout', JSON.stringify(status));
if (status.successful) {
var subsrip = cometDLib.subscribe('/event/ShoeComparisonPopup__e', function (message) {
console.log('message 00->' + JSON.stringify(message));
setTimeout(() => {
lwcThisContext.ProductId = message.data.payload.ProductId__c;
lwcThisContext.ContactId = message.data.payload.ContactId__c;

lwcThisContext.fetchProductDetails();
lwcThisContext.fetchRecentOrder();

lwcThisContext.isModalOpen = true;
}, 500);
});
} else {
console.error('Error in handshaking comparison flyout:', JSON.stringify(status));
}
});
});
} else if (error) {
console.log('Error occurred in loading script');
console.log(JSON.stringify(error));
this.sessionId = undefined;
}
}

fetchProductDetails() {
getProductDetail({ ProductId: this.ProductId })
.then((data) => {
if (data) {
this.product1 = JSON.parse(data);
this.ChosenShoe = this.product1.Name;
this.formatData();
}
})
.catch((error) => {
console.error('Error fetching product details', error);
});
}

fetchRecentOrder() {
getMostRecentPurchase({ ContactId: this.ContactId })
.then((data) => {
if (data) {
this.product2 = JSON.parse(data);
this.RecentOrder = this.product2.Name;
this.formatData();
}
})
.catch((error) => {
console.error('Error fetching recent order', error);
});
}

formatData() {
if (this.product1 && this.product2) {
this.datas = [
{
id: '1',
attribute: 'Category',
product1: this.product1.Category,
product2: this.product2.Category
},
{
id: '2',
attribute: 'Weight',
product1: this.product1.Weight,
product2: this.product2.Weight
},
{
id: '3',
attribute: 'Ventilation',
product1: this.product1.Ventilation,
product2: this.product2.Ventilation
},
{
id: '4',
attribute: 'Star',
product1: this.generateStars(this.product1.Stars),
product2: this.generateStars(this.product2.Stars)
},
{
id: '5',
attribute: 'Unit Price',
product1: this.product1.Price,
product2: this.product2.Price
}
];
console.log('the formatted data', JSON.stringify(this.datas));
}
}

openModal() {
this.isModalOpen = true;
}

closeModal() {
this.isModalOpen = false;
}

handleCloseModal() {
this.isModalOpen = false;
}

generateStars(starcountString) {
let starCountNumber = parseFloat(starcountString);
let stars = '';
for (let i = 0; i < starCountNumber; i++) {
stars += '★';
}
return stars;
}
}