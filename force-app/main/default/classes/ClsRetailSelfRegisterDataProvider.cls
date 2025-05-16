public class ClsRetailSelfRegisterDataProvider {
@future
    public static void Init(Set<Id> UserIds){
       //create personal account
       //fetch contact associated to account
       //update contact on community user
       //create order and order product
       //create asset
        
        try{
                String calulatedMembershipNumber = 'RC-92'+String.valueOf(Math.round((Math.random() * (9000000) + 1000000)));
        
        // Fetch the User record by the given userId
        User communityUser = [SELECT Id,FirstName,LastName,Phone, ContactId FROM User WHERE Id IN:UserIds LIMIT 1];
        system.debug('communityUser:'+communityUser);
        
        
        // If the User has an not null
        if (communityUser != null) {
            
         // fetch the contact
         Contact associatedContact = [Select id,AccountId,name,Account.Membership_Number__pc from Contact where id = :communityUser.ContactId limit 1];
         system.debug('Contact:'+associatedContact);
            
   	    Account acc = new Account(id = associatedContact.AccountId,
                              Membership_Number__pc =calulatedMembershipNumber, BillingStreet ='585 Franklin St',
                              BillingCity ='Mountain View',BillingState ='CA',BillingPostalCode = '94041',BillingCountry ='USA',
                              ShippingStreet ='585 Franklin St',ShippingCity ='Mountain View',ShippingState ='CA',
                              ShippingPostalCode = '94041',ShippingCountry ='USA',Gender__pc = 'Male',Age__pc = 32,Income_Level__pc = '50,00,001 and above',
                               Customer_Satisfaction_CSAT__pc = 10,Net_Promoter_Score_NPS__pc = 9,Customer_Lifetime_Value_CLV__pc = 46000,Engagement_Frequency__pc = '10 days',
                                 Recency_Of_Purchase__pc = '9 Days',Payment_Method__pc = 'Credit Card',Average_Order__pc = 25,Number_of_Complaint__pc = 5,Number_of_Product_Return__pc = 5,
                                 Churn_Score__pc = 25,Location__pc = 'USA',Days_since_the_last_order__pc = 10,Number_of_orders_period__pc = '23 days',Average_time_between_orders__pc = '10 days',
                                 Total_Amount_Spent_LTV__pc = 300000,Total_amount_spent_period__pc = '50000 in 20 days',Average_order_value__pc = 50000,Maximum_order_value__pc = 70000,
                                 Number_of_Unique_Products_Purchased__pc = 30,Most_Frequently_Purchased__pc = 'UltraRunBreeze 3000',Last_Purchased_Product_Categories__pc = 'Walking Shoes',
                                 Average_Quantity_per_Order__pc = 20,Ordered_In_Last_30_Days__pc = True);
            
         update acc;
         system.debug('Inserted Account:'+acc);
         
          // fetch product
          Product2 prod;
            if(Test.isRunningTest()){
                 prod = [Select id,name from Product2 where Name = 'UltraRunBreeze 3000' limit 1];
                 system.debug('prod:'+prod); 
            }else{
                     prod = [Select id,name from Product2 where Name = 'UltraRunBreeze 3000' AND StockKeepingUnit='1050279A1T' limit 1];
        			system.debug('prod:'+prod); 
            }
  
         //create Asset
         String assetName = 'Ast -' +associatedContact.Name;
         Asset ast = new Asset(Name = assetName, Status = 'Installed',Quantity =1,Product2Id = prod.Id,
                              ContactId =associatedContact.Id);
            
         insert ast;
         system.debug('ast:'+ast); 
         
            
         //fetch pricebook
         Pricebook2 outfitterPricebook = [Select id,name from Pricebook2 where name = 'Outfitters Price Book' limit 1];
         system.debug('outfitterPricebook:'+outfitterPricebook);  
                    
         //fetch pricebook
         PricebookEntry outfittersPB = [Select id,UnitPrice,Pricebook2Id,Product2Id from PricebookEntry where Pricebook2Id = :outfitterPricebook.id
                             AND Product2Id =:prod.Id];
        system.debug('outfittersPB:'+outfittersPB); 
            
         //create order
         String ordername = 'Order -' + associatedContact.Name;
         String ordername2 = 'Order -' + associatedContact.Name + '1';
         String ordername3 = 'Order -' + associatedContact.Name + '2';
         Integer randomNumber = Math.floor((Math.random() * 6)).intValue() + 4;
         system.debug('randomNumber:'+randomNumber);
         List<Order> orderInsertion = new List<Order>();
         orderInsertion.add(new Order(Name = ordername,EffectiveDate = Date.today(),Status ='Open',BillToContactId =associatedContact.Id,
                              AccountId = associatedContact.AccountId,Type ='New',Pricebook2Id =outfitterPricebook.Id));
         orderInsertion.add(new Order(Name = ordername2,EffectiveDate = Date.today(),Status ='Draft',BillToContactId =associatedContact.Id,
                              AccountId = associatedContact.AccountId,Type ='New',Pricebook2Id =outfitterPricebook.Id));
         orderInsertion.add(new Order(Name = ordername3,EffectiveDate = Date.today(),Status ='Draft',BillToContactId =associatedContact.Id,
                              AccountId = associatedContact.AccountId,Type ='New',Pricebook2Id =outfitterPricebook.Id));
         
         insert orderInsertion;
         system.debug('Order:'+orderInsertion);
            
         List<Order> ordFetch = [Select id,name,BillToContactId from Order where BillToContactId =:associatedContact.Id];
            system.debug('ordFetch:'+ordFetch);
         List<OrderItem> orderProductInsertion = new List<OrderItem>();
          List<Order> updateOrderStatus = new List<Order>();
         // create order product
            for(Order ord :ordFetch){
                orderProductInsertion.add(new OrderItem(OrderId = ord.Id,Quantity =randomNumber,Product2Id =prod.Id,PricebookEntryId = outfittersPB.Id,
                                              UnitPrice = outfittersPB.UnitPrice));
                system.debug('Ordername:'+ord.Name);
                  if(ord.Name == ordername2){
                    ord.id = ord.id;
                    ord.Status = 'Activated';
                    updateOrderStatus.add(ord);
                }
                if(ord.Name == ordername3){
                     ord.id = ord.id;
                    ord.EffectiveDate = Date.today().addYears(-randomNumber);
                      ord.Status = 'Activated';
                     updateOrderStatus.add(ord);
                }
            }
         insert orderProductInsertion;
          system.debug('Order product:'+orderProductInsertion);
         update updateOrderStatus;
         system.debug('Updated Order:'+updateOrderStatus);

         
        } 
      }catch(Exception e){
            system.debug('exception:'+e.getMessage());
        }
   
    }   
}