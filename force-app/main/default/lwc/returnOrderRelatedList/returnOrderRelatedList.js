import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import getReturnOrderRecords from "@salesforce/apex/clsReturnOrderRelatedListController.getReturnOrderRecords";
import getReturnOrderProductRecords from "@salesforce/apex/clsReturnOrderRelatedListController.getReturnOrderProductRecords";
const FIELDS = ["Account.Membership_Number__pc"];
const columns = [
    { label: 'OrderNumber', fieldName: 'ssot__Id__c', sortable: true },
    { label: 'Ordered Date', fieldName: 'ssot__ReturnSubmittedDate__c', type: 'date', sortable: true },
    { label: 'Status', fieldName: 'ssot__ReturnOrderStatus__c' },
    { label: 'Type', fieldName: 'Return_Order_Type__c' }
    ];
    const columnProducts = [
        { label: 'OrderNumber', fieldName: 'ssot__ReturnOrderId__c', sortable: true },
        { label: 'ProductName', fieldName: 'productName', sortable: true },
        { label: 'Description', fieldName: 'ssot__Description__c' },
        { label: 'Quantity', fieldName: 'ssot__ReturnedQuantityCount__c' },
        { label: 'Amount', fieldName: 'ssot__TotalAmount__c', type:'currency' }
        ];
export default class ReturnOrderRelatedList extends LightningElement {
    @api recordId;
    externalId;
    transactions
    columns = columns;
    columnProducts = columnProducts;
    itemNumber;
    itemNumberProduct;
    defaultSortDirection = 'asc';
    defaultSortDirectionProd = 'asc';
    sortDirection = 'asc';
    sortDirectionProd = 'asc';
    sortedBy;
    sortedByProd;
    sortedByLabel;
    sortedByLabelProd;
    products ;


    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    wiredContact({ data, error }) { // Destructure the result
        console.log('Record Id From API',this.recordId);
        if (data) {
            console.log('Inside Membership wire data');
            console.log('MembershipNumber',data)
            this.externalId = data.fields.Membership_Number__pc.value;
            this.error = undefined; // Clear previous errors
        } else if (error) {
            this.error = error;
            this.contactData = undefined; // Clear previous data
        }
    }

    @wire(getReturnOrderRecords, { ExternalId: '$externalId' })
    wiredReturnOrderData({ error, data }) {
        if (data) {
            console.log('data is ', data)
            // Extracting data from the response
            this.transactions = data;
            this.itemNumber = data.length
            //console.log('First return order object:', data[0].ssot__Id__c);
            const returnOrderIds = data.map(order => order.ssot__Id__c);
            console.log('Return Order Ids', returnOrderIds);
            const returnOrderIdsCheck = data
            .map(order => order.ssot__Id__c)
            .filter(id => typeof id === 'string' && id); // clean list of strings

        console.log('Return Order IDs:', returnOrderIdsCheck);

            getReturnOrderProductRecords({ returnOrderIds })
                .then(productData => {
                    console.log('PRODUCT DATA',productData);
                    this.products = productData.map(item =>{
                        return{
                        ...item.returnOrderProduct,
                        productName: item.product?.ssot__Name__c
                        }
                    })
                    this.itemNumberProduct = productData.length;
                    console.log('Fetched Product',this.products);
                })
                .catch(productError => {
                    console.error('Error fetching products', productError);
                });


        } else if (error) {
            console.log('Error is')
            this.error = error.body.message;
            this.loyaltyData = undefined;
            this.itemNumber=0
        } else {
            this.itemNumber=0
            console.log(' Nothing here')
        }
    }
    
    getFriendlyLabel(fieldName) {
        const fieldMap = {
            ssot__Id__c: 'OrderNumber',
            ssot__ReturnSubmittedDate__c: 'Ordered Date'
            //totalprice__c: 'Total Price'
            
        };
    
        return fieldMap[fieldName] || fieldName;  // Return the field name if not found in the map
    }
    getProductData(fieldName) {
        const fieldMap = {
            ssot__ReturnOrderId__c : 'OrderNumber',
            productName: 'productName'
            
            
    };
    
        return fieldMap[fieldName] || fieldName;  // Return the field name if not found in the map
    }
    onHandleSort(event) {
     
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.transactions];
        console.log(event.detail);

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.transactions = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
        this.sortedByLabel=this.getFriendlyLabel(this.sortedBy)

    }
    onHandleSortProduct(event) {
     
        const { fieldName: sortedByProd, sortDirectionProd } = event.detail;
        const cloneData = [...this.products];
        console.log(event.detail);

        cloneData.sort(this.sortBy(sortedByProd,sortDirectionProd === 'asc' ? 1 : -1));
        this.products = cloneData;
        this.sortDirectionProd = sortDirectionProd;
        this.sortedByProd = sortedByProd;
        this.sortedByLabelProd=this.getProductData(this.sortedByProd)

    }
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };
              

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
}