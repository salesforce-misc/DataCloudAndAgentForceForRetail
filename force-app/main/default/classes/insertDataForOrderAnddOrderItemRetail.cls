public class insertDataForOrderAnddOrderItemRetail {
 @AuraEnabled
    public static void generateOrderAndOrderItemRetail() {
     try {
         
          //fetch contact
             Map<String, Contact> contactMap2 = new Map<String, Contact>();
            List<Contact> contactList = [SELECT Id, AccountId,Name FROM Contact WHERE Email IN ('dmacintosh@yopmail.com','msmith@yopmail.com','ngrace@yopmail.com','kwells@yopmail.com')];
            if(contactList != null && contactList.size() > 0){
                  for (Contact contact :contactList ) {
                contactMap2.put(contact.Name, contact);
          	  } 
            }
             system.debug('contactMap2:'+contactMap2); 
         
         //fetch product
            Map<String,Product2> productNameMap = new Map<String,Product2>();
            List<Product2> productList = [SELECT Id, Name FROM Product2 WHERE Name IN ('Men Chilkat Nylon Boots','Men Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags',
                                          'Homestead Domey 3 Tent','Homestead Roomy','Homestead Shelter','UltraRunBreeze','Northstar','Talus4')];
            system.debug('productList:'+productList);
          
            if(productList != null && productList.size() > 0){
                	    for (Product2 Prod : productList) {
                            	productNameMap.put(Prod.Name, Prod);
           				 }
            }
			system.debug('productNameMap:'+productNameMap);
         
         
         //fetch pricebook
         Pricebook2 OutfittersPriceBookData = [SELECT Id,IsStandard,Name FROM Pricebook2 where Name = 'Outfitters Price Book' LIMIT 1];
               system.debug('OutfittersPriceBookData:'+OutfittersPriceBookData);   
         
         //fetch pricebookentry
         List<PricebookEntry> retailpricebookEntriesList1 = [Select id,Product2.Name,UnitPrice,Pricebook2Id,Product2Id from PricebookEntry where Pricebook2Id =:OutfittersPriceBookData.Id 
                                                            AND Product2.Name IN ('Men Chilkat Nylon Boots','Men Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags',
                                          					'Homestead Domey 3 Tent','Homestead Roomy','Homestead Shelter','Northstar 4','UltraRunBreeze','Talus4')];
             system.debug('retailpricebookEntriesList1:'+retailpricebookEntriesList1);
            Map<String,PricebookEntry> priceboolRefMap = new Map<String,PricebookEntry>();
            for(PricebookEntry pbe : retailpricebookEntriesList1){
             priceboolRefMap.put(pbe.Product2.Name,pbe);
            }
              system.debug('priceboolRefMap:'+priceboolRefMap); 
         
            //create order
			 String [] orderFLS = new String [] {'Name','Status','AccountId','EffectiveDate','BillToContactId','Pricebook2Id','CurrencyIsoCode','Type'};
            Map<String,Schema.SObjectField> ord = Schema.SObjectType.Order.fields.getMap();
            system.debug('ord'+ord);
            for (String fieldToCheck : orderFLS) {
                if(ord.get(fieldToCheck)!= null){
                    if (!ord.get(fieldToCheck).getDescribe().isCreateable() && (!ord.get(fieldToCheck).getDescribe().isupdateable())) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                                   'Insufficient access')); 
                    }
                }  
            }
            
           List<Order> Orders = new List<Order>();
            
            Orders.add(new Order(Name = 'Men Chilkat Nylon Boots', AccountId = contactMap2.get('Duncan Macintosh').AccountId,EffectiveDate = Date.today(),
                                 Status ='Draft', CurrencyIsoCode = 'USD', BillToContactId = contactMap2.get('Duncan Macintosh').Id,Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Men Safien Mid Gtx Hiking Shoes', AccountId = contactMap2.get('Duncan Macintosh').AccountId,
                                 EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Duncan Macintosh').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Duramo Speed Shoes', AccountId = contactMap2.get('Duncan Macintosh').AccountId,
                                 EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD',  Type = 'New', BillToContactId = contactMap2.get('Duncan Macintosh').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Furnace Sleeping Bags', AccountId = contactMap2.get('Duncan Macintosh').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Duncan Macintosh').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Homestead Domey 3 Tent', AccountId = contactMap2.get('Duncan Macintosh').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Duncan Macintosh').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Homestead Roomy', AccountId = contactMap2.get('Mark Smith').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Mark Smith').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Homestead Shelter', AccountId = contactMap2.get('Mark Smith').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Mark Smith').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
             Orders.add(new Order(Name = 'Northstar', AccountId = contactMap2.get('Mark Smith').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Mark Smith').Id,
                                  Pricebook2Id = OutfittersPriceBookData.Id));
            
             Orders.add(new Order(Name = 'Talus4', AccountId = contactMap2.get('Mark Smith').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Mark Smith').Id,
                                  Pricebook2Id = OutfittersPriceBookData.Id));
            
             Orders.add(new Order(Name = 'Men Chilkat Nylon Boots Order1', AccountId = contactMap2.get('Nicole Grace').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Nicole Grace').Id,
                                  Pricebook2Id = OutfittersPriceBookData.Id));
            
             Orders.add(new Order(Name = 'Men Safien Mid Gtx Hiking Shoes Order1', AccountId = contactMap2.get('Nicole Grace').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Nicole Grace').Id,
                                  Pricebook2Id = OutfittersPriceBookData.Id));
            
             Orders.add(new Order(Name = 'Duramo Speed Shoes Order1', AccountId = contactMap2.get('Nicole Grace').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Nicole Grace').Id,
                                  Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Furnace Sleeping Bags Order1', AccountId = contactMap2.get('Nicole Grace').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Nicole Grace').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            Orders.add(new Order(Name = 'Homestead Domey 3 Tent Order1', AccountId = contactMap2.get('Karen Wells').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Karen Wells').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
         	Orders.add(new Order(Name = 'Homestead Roomy Order1', AccountId = contactMap2.get('Karen Wells').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Karen Wells').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
         	
         	Orders.add(new Order(Name = 'Homestead Shelter Order1', AccountId = contactMap2.get('Karen Wells').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Karen Wells').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
         	
         	Orders.add(new Order(Name = 'Northstar Order1', AccountId = contactMap2.get('Karen Wells').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Karen Wells').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
         Orders.add(new Order(Name = 'UltraRunBreeze Order1', AccountId = contactMap2.get('Karen Wells').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Karen Wells').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
         Orders.add(new Order(Name = 'UltraRunBreeze Order2', AccountId = contactMap2.get('Mark Smith').AccountId,
                              EffectiveDate = Date.today(),Status ='Draft', CurrencyIsoCode = 'USD', Type = 'New', BillToContactId = contactMap2.get('Mark Smith').Id,
                                 Pricebook2Id = OutfittersPriceBookData.Id));
            
            if(Orders != null && Orders.size() > 0){
                  insert Orders;
                system.debug('Orders:'+Orders);
            }
          
            Map<String,Order> OrderMap = new Map<String,Order>();
            List<Order> orderList = [Select id,name from Order where Name in ('Men Chilkat Nylon Boots','Men Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags',
                                          					'Homestead Domey 3 Tent','Homestead Roomy','Men Chilkat Nylon Boots Order1','Men Safien Mid Gtx Hiking Shoes Order1','Duramo Speed Shoes Order1','Furnace Sleeping Bags Order1',
                                          					'Homestead Domey 3 Tent Order1','Homestead Roomy Order1','Homestead Shelter Order1','Northstar Order1','UltraRunBreeze Order1','UltraRunBreeze Order2','Talus4 Order1')];
            if(orderList != null && orderList.size() > 0){
                for(Order order : orderList){
                       OrderMap.put(order.Name,order);
                }
            }
            system.debug('OrderMap:'+OrderMap); 
     
         //create order product
             String [] orderProdcutFLS = new String [] {'Product2Id','Quantity','OrderId','PricebookEntryId','UnitPrice'};
            Map<String,Schema.SObjectField> ordProduct = Schema.SObjectType.OrderItem.fields.getMap();
            system.debug('ordProduct'+ordProduct);
            for (String fieldToCheck : orderProdcutFLS) {
                if(ordProduct.get(fieldToCheck)!= null){
                    if (!ordProduct.get(fieldToCheck).getDescribe().isCreateable() && (!ordProduct.get(fieldToCheck).getDescribe().isupdateable())) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                                   'Insufficient access')); 
                    }
                }  
            }
            
              List<OrderItem> OrderItems = new List<OrderItem>();
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Men Chilkat Nylon Boots').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Men Chilkat Nylon Boots').Id, PricebookEntryId = priceboolRefMap.get('Men Chilkat Nylon Boots').Id, UnitPrice =  priceboolRefMap.get('Men Chilkat Nylon Boots').UnitPrice));
            
         	 system.debug('Product2Id orderitem:'+productNameMap.get('Men Chilkat Nylon Boots').Id);
         system.debug('pricebook orderitem:'+priceboolRefMap.get('Men Chilkat Nylon Boots').Id);
          system.debug('order:'+OrderMap.get('Men Chilkat Nylon Boots').Id);
            system.debug('unit price:'+priceboolRefMap.get('Men Chilkat Nylon Boots').UnitPrice);
         
             OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Men Safien Mid Gtx Hiking Shoes').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Men Safien Mid Gtx Hiking Shoes').Id,PricebookEntryId =priceboolRefMap.get('Men Safien Mid Gtx Hiking Shoes').Id,
                                         UnitPrice =  priceboolRefMap.get('Men Safien Mid Gtx Hiking Shoes').UnitPrice));
         
           	 system.debug('Product2Id orderitem1:'+productNameMap.get('Men Safien Mid Gtx Hiking Shoes').Id);
         system.debug('pricebook orderitem1:'+priceboolRefMap.get('Men Safien Mid Gtx Hiking Shoes').Id);
          system.debug('order2:'+OrderMap.get('Men Safien Mid Gtx Hiking Shoes').Id);
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Duramo Speed Shoes').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Duramo Speed Shoes').Id,PricebookEntryId = priceboolRefMap.get('Duramo Speed Shoes').Id,
                                         UnitPrice =  priceboolRefMap.get('Duramo Speed Shoes').UnitPrice));
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Furnace Sleeping Bags').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Furnace Sleeping Bags').Id,PricebookEntryId =priceboolRefMap.get('Furnace Sleeping Bags').Id,
                                         UnitPrice =  priceboolRefMap.get('Furnace Sleeping Bags').UnitPrice)); 
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Domey 3 Tent').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Domey 3 Tent').Id,PricebookEntryId =priceboolRefMap.get('Homestead Domey 3 Tent').Id,
                                        UnitPrice =  priceboolRefMap.get('Homestead Domey 3 Tent').UnitPrice));
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Roomy').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Roomy').Id,PricebookEntryId =priceboolRefMap.get('Homestead Roomy').Id,
                                        UnitPrice =  priceboolRefMap.get('Homestead Roomy').UnitPrice));
         
         /*OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Shelter').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Shelter').Id,PricebookEntryId =priceboolRefMap.get('Homestead Shelter').Id,
                                          UnitPrice =  priceboolRefMap.get('Homestead Shelter').UnitPrice));
         
         system.debug('Product2Id orderitem1:'+productNameMap.get('Homestead Shelter').Id);
         system.debug('pricebook orderitem1:'+priceboolRefMap.get('Homestead Shelter').Id);
          system.debug('order2:'+OrderMap.get('Homestead Shelter').Id);
            
           OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Northstar').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Northstar').Id,PricebookEntryId =priceboolRefMap.get('Northstar').Id,
                                        UnitPrice =  priceboolRefMap.get('Northstar').UnitPrice));
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Talus4').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Talus4').Id,PricebookEntryId =priceboolRefMap.get('Talus4').Id,
                                         UnitPrice =  priceboolRefMap.get('Talus4').UnitPrice));
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Men Chilkat Nylon Boots Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Men Chilkat Nylon Boots Order1').Id,PricebookEntryId =priceboolRefMap.get('Men Chilkat Nylon Boots Order1').Id,
                                        UnitPrice =  priceboolRefMap.get('Men Chilkat Nylon Boots Order1').UnitPrice));
            
          OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Men Safien Mid Gtx Hiking Shoes Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Men Safien Mid Gtx Hiking Shoes Order1').Id,PricebookEntryId =priceboolRefMap.get('Men Safien Mid Gtx Hiking Shoes Order1').Id,
                                      UnitPrice =  priceboolRefMap.get('Men Safien Mid Gtx Hiking Shoes Order1').UnitPrice));
            
           OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Duramo Speed Shoes Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Duramo Speed Shoes Order1').Id,PricebookEntryId =priceboolRefMap.get('Duramo Speed Shoes Order1').Id,
                                        UnitPrice =  priceboolRefMap.get('Duramo Speed Shoes Order1').UnitPrice));
            
            OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Furnace Sleeping Bags Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Furnace Sleeping Bags Order1').Id,PricebookEntryId =priceboolRefMap.get('Furnace Sleeping Bags Order1').Id,
                                        UnitPrice =  priceboolRefMap.get('Furnace Sleeping Bags Order1').UnitPrice));
            
          OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Domey 3 Tent Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Domey 3 Tent Order1').Id,PricebookEntryId =priceboolRefMap.get('Homestead Domey 3 Tent Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('Homestead Domey 3 Tent Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Roomy Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Roomy Order1').Id,PricebookEntryId =priceboolRefMap.get('Homestead Roomy Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('Homestead Roomy Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Homestead Shelter Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Homestead Shelter Order1').Id,PricebookEntryId =priceboolRefMap.get('Homestead Shelter Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('Homestead Shelter Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Northstar Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Northstar Order1').Id,PricebookEntryId =priceboolRefMap.get('Northstar Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('Northstar Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('Talus4 Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('Talus4 Order1').Id,PricebookEntryId =priceboolRefMap.get('Talus4 Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('Talus4 Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('UltraRunBreeze Order1').Id,Quantity = 2,
                                         OrderId = OrderMap.get('UltraRunBreeze Order1').Id,PricebookEntryId =priceboolRefMap.get('UltraRunBreeze Order1').Id,
                                          UnitPrice =  priceboolRefMap.get('UltraRunBreeze Order1').UnitPrice));
         
         OrderItems.add(new OrderItem(Product2Id =  productNameMap.get('UltraRunBreeze Order2').Id,Quantity = 2,
                                         OrderId = OrderMap.get('UltraRunBreeze Order2').Id,PricebookEntryId =priceboolRefMap.get('UltraRunBreeze Order2').Id,
                                          UnitPrice =  priceboolRefMap.get('UltraRunBreeze Order2').UnitPrice));
         
          system.debug('order:'+OrderMap.get('UltraRunBreeze Order2').Id);
            system.debug('unit price:'+priceboolRefMap.get('UltraRunBreeze Order2').UnitPrice);
             */
            if(OrderItems != null && OrderItems.size() > 0){
                insert OrderItems;
            }
		   system.debug('OrderItems:'+OrderItems);       
            
     }catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw e;
        }
	}
}