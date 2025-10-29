public with sharing class GenerateCommerceCloudDataRetail {
  @AuraEnabled
    public static void generateCommerceCloudRetailData() {
        try {
            //Fetch Product Catgolue
           ProductCatalog prodCatalog = [SELECT Id, Name FROM ProductCatalog WHERE Name ='Outfitters Catalog'];
            system.debug('prodCatalog:'+prodCatalog);
            
            //Get Product Category
           List<ProductCategory> prodCategory =[SELECT Id, Name, Catalog.Name,CatalogId FROM ProductCategory Where CatalogId =:prodCatalog.Id order by Name desc];
			 system.debug('prodCategory:'+prodCategory);
            
            //Create Product
            String [] Product2FLS = new String [] {'Name','IsActive','ProductCode','StockKeepingUnit','Description','Recall_flag__c','Type','ManagedContentName__c','NumberOfQuantityInstallments','NumberOfRevenueInstallments','Product_Catalog__c','Total_Quantity__c','type'};
            Map<String,Schema.SObjectField> prd1 = Schema.SObjectType.Product2.fields.getMap();
            system.debug('prd1:'+prd1);
            for (String fieldToCheck : Product2FLS) {
                if(prd1.get(fieldToCheck)!= null){
                    if (!prd1.get(fieldToCheck).getDescribe().isCreateable() && (!prd1.get(fieldToCheck).getDescribe().isupdateable())) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                                   'Insufficient access')); 
                    }
                }  
            }
            
            List<Product2> Products= new List<Product2>();
            
            //Base products creation
   			Products.add(new Product2(Name = 'Men Chilkat Nylon Boots',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050400AD3', Recall_flag__c = FALSE, ManagedContentName__c = 'MenChilkatNylonBoots', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Mens Chilkat Nylon Boots are perfect for winter conditions, featuring a waterproof ballistic nylon upper and 200 g Heatseeker Eco insulation to keep your feet warm and dry. The TNF Winter Grip rubber outsole with IcePick temperature-sensitive lugs ensures excellent traction on icy surfaces. A compression-molded EVA midsole provides long-lasting cushioning and support, making these boots ideal for cold and wet weather.'));
			Products.add(new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050041AC7', Recall_flag__c = FALSE, ManagedContentName__c = 'MenSafienMidGtxHikingShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Men’s Safien Mid GTX Hiking Shoes are designed for versatile trail performance, featuring a Gore-Tex membrane for waterproof protection and breathability. The shock-absorbing midsole cushions your feet over long distances, while the high-traction outsole grips various surfaces. TPU coating and a mudguard offer added protection in wet conditions, and a molded toe cap safeguards against stubs'));
			Products.add(new Product2(Name = 'Duramo Speed Shoes',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050013AFI', Recall_flag__c = FALSE, ManagedContentName__c = 'DuramoSpeedShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Duramo Speed Shoes are designed for runners seeking a lightweight and breathable option and mostly used in marathon. They feature a mesh upper for excellent ventilation and a Lightstrike midsole for responsive cushioning. The durable Adiwear outsole provides reliable traction on various surfaces. These shoes are ideal for daily runs and dynamic movements, offering a stable yet featherlight ride. They are best suited for warm and dry weather conditions due to their breathability'));
			Products.add(new Product2(Name = 'Furnace Sleeping Bags',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050406ADA', Recall_flag__c = FALSE, ManagedContentName__c = 'FurnaceSleepingBags', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Furnace Sleeping Bag is designed for 3-season backpacking, offering warmth and comfort in various conditions. It features 600-fill ProDown insulation, which is water-resistant and dries faster than traditional down. The bag includes an anti-compression layer of Heatseeker Eco synthetic insulation on the bottom to eliminate cold spots. With a temperature rating of 20°F (-7°C), it provides reliable warmth in cooler weather. The roomy design and fitted hood enhance comfort, making it ideal for outdoor adventures'));
			Products.add(new Product2(Name = 'Homestead Domey 3 Tent',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050112AFI', Recall_flag__c = TRUE, ManagedContentName__c = 'HomesteadDomey3Tent', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Homestead Domey 3 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
			Products.add(new Product2(Name = 'UltraRunBreeze',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050279A1T', Recall_flag__c = FALSE, ManagedContentName__c = 'UltraRunBreeze', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The UltraRun Breeze 3000 is designed for long-distance running and mostly used in marathon, offering advanced cushioning to reduce joint strain, excellent arch support, and a high-traction rubber outsole for superior grip on various surfaces. It is suitable for a range of weather conditions: the breathable mesh upper keeps your feet cool and dry in hot weather, while the durable materials provide protection and support in colder conditions. This makes it a versatile choice for runners in different climate'));
			Products.add(new Product2(Name = 'Homestead Roomy',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050112GEY', Recall_flag__c = FALSE, ManagedContentName__c = 'HomesteadRoomy', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='This is typical two-person tent, with abundant headroom and a comfortable layout. Featuring an easy-pitch design, it includes thoughtful accessories like a gear loft, pole bag, phone holder, tablet-viewing system, and side “nightstand” pockets for organized storage. The large doors can fit a queen-size inflatable mattress, and the internal dry lines keep your gear dry.'));
			Products.add(new Product2(Name = 'Homestead Shelter',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050112BUY', Recall_flag__c = FALSE, ManagedContentName__c = 'HomesteadShelter', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='This Homestead Shelter tent has an easy-pitch design, large doors that can accommodate a queen-size inflatable mattress, and thoughtful accessories like a gear loft, pole bag, phone holder, tablet-viewing system, and side “nightstand” pockets for convenient storage. Additional features include internal dry lines, a Velcro lantern hang loop for lighting, and T entertainment compatibility (sold separately), making it the perfect choice.'));
			Products.add(new Product2(Name = 'Northstar',IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050112ABC', Recall_flag__c = FALSE, ManagedContentName__c = 'Northstar', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = 56, 
							Description='The Expedition Base Camp Northstar4 tent is designed for rugged outdoor enthusiasts, offering unmatched durability and strength. Its true geodesic dome design ensures maximum stability in extreme conditions, while the full stand-up height at the peak provides ample headroom. A large poled vestibule allows for dry entry and convenient gear storage, keeping your essentials protected from the elements. The tent features ample vents that are all accessible from inside, ensuring optimal airflow and ventilation. It also comes with a large duffel-style stuffsack, making it easy to pack and transport'));
			Products.add(new Product2(Name = 'Talus4', IsActive = TRUE, Type = 'Base', StockKeepingUnit='R1050112ASD', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            
            //Child Products creation
            Products.add(new Product2(Name = 'UltraRunBreeze',IsActive = TRUE,  StockKeepingUnit='R1050279A1T7', Recall_flag__c = FALSE, ManagedContentName__c = 'UltraRunBreeze', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The UltraRun Breeze 3000 is designed for long-distance running and mostly used in marathon, offering advanced cushioning to reduce joint strain, excellent arch support, and a high-traction rubber outsole for superior grip on various surfaces. It is suitable for a range of weather conditions: the breathable mesh upper keeps your feet cool and dry in hot weather, while the durable materials provide protection and support in colder conditions. This makes it a versatile choice for runners in different climate'));
            Products.add(new Product2(Name = 'UltraRunBreeze',IsActive = TRUE,  StockKeepingUnit='R1050279A1T8', Recall_flag__c = FALSE, ManagedContentName__c = 'UltraRunBreeze', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The UltraRun Breeze 3000 is designed for long-distance running and mostly used in marathon, offering advanced cushioning to reduce joint strain, excellent arch support, and a high-traction rubber outsole for superior grip on various surfaces. It is suitable for a range of weather conditions: the breathable mesh upper keeps your feet cool and dry in hot weather, while the durable materials provide protection and support in colder conditions. This makes it a versatile choice for runners in different climate'));
            Products.add(new Product2(Name = 'UltraRunBreeze',IsActive = TRUE,  StockKeepingUnit='R1050279A1T9', Recall_flag__c = FALSE, ManagedContentName__c = 'UltraRunBreeze', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The UltraRun Breeze 3000 is designed for long-distance running and mostly used in marathon, offering advanced cushioning to reduce joint strain, excellent arch support, and a high-traction rubber outsole for superior grip on various surfaces. It is suitable for a range of weather conditions: the breathable mesh upper keeps your feet cool and dry in hot weather, while the durable materials provide protection and support in colder conditions. This makes it a versatile choice for runners in different climate'));
            
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD0', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD1', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD2', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD3', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD4', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD5', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            Products.add(new Product2(Name = 'Talus4', IsActive = TRUE,  StockKeepingUnit='R1050112ASD6', Recall_flag__c = FALSE, ManagedContentName__c = 'Talus4', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Talus 4 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
            
            Products.add(new Product2(Name = 'Northstar',IsActive = TRUE,  StockKeepingUnit='R1050112ABC1', Recall_flag__c = FALSE, ManagedContentName__c = 'Northstar', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = 56, 
							Description='The Expedition Base Camp Northstar4 tent is designed for rugged outdoor enthusiasts, offering unmatched durability and strength. Its true geodesic dome design ensures maximum stability in extreme conditions, while the full stand-up height at the peak provides ample headroom. A large poled vestibule allows for dry entry and convenient gear storage, keeping your essentials protected from the elements. The tent features ample vents that are all accessible from inside, ensuring optimal airflow and ventilation. It also comes with a large duffel-style stuffsack, making it easy to pack and transport'));
            
            Products.add(new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes',IsActive = TRUE,  StockKeepingUnit='R1050041AC71', Recall_flag__c = FALSE, ManagedContentName__c = 'MenSafienMidGtxHikingShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Men’s Safien Mid GTX Hiking Shoes are designed for versatile trail performance, featuring a Gore-Tex membrane for waterproof protection and breathability. The shock-absorbing midsole cushions your feet over long distances, while the high-traction outsole grips various surfaces. TPU coating and a mudguard offer added protection in wet conditions, and a molded toe cap safeguards against stubs'));
            Products.add(new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes',IsActive = TRUE,  StockKeepingUnit='R1050041AC72', Recall_flag__c = FALSE, ManagedContentName__c = 'MenSafienMidGtxHikingShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Men’s Safien Mid GTX Hiking Shoes are designed for versatile trail performance, featuring a Gore-Tex membrane for waterproof protection and breathability. The shock-absorbing midsole cushions your feet over long distances, while the high-traction outsole grips various surfaces. TPU coating and a mudguard offer added protection in wet conditions, and a molded toe cap safeguards against stubs'));
            Products.add(new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes',IsActive = TRUE,  StockKeepingUnit='R1050041AC73', Recall_flag__c = FALSE, ManagedContentName__c = 'MenSafienMidGtxHikingShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Men’s Safien Mid GTX Hiking Shoes are designed for versatile trail performance, featuring a Gore-Tex membrane for waterproof protection and breathability. The shock-absorbing midsole cushions your feet over long distances, while the high-traction outsole grips various surfaces. TPU coating and a mudguard offer added protection in wet conditions, and a molded toe cap safeguards against stubs'));
            Products.add(new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes',IsActive = TRUE,  StockKeepingUnit='R1050041AC74', Recall_flag__c = FALSE, ManagedContentName__c = 'MenSafienMidGtxHikingShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Men’s Safien Mid GTX Hiking Shoes are designed for versatile trail performance, featuring a Gore-Tex membrane for waterproof protection and breathability. The shock-absorbing midsole cushions your feet over long distances, while the high-traction outsole grips various surfaces. TPU coating and a mudguard offer added protection in wet conditions, and a molded toe cap safeguards against stubs'));
            
            
			Products.add(new Product2(Name = 'Men Chilkat Nylon Boots',IsActive = TRUE,  StockKeepingUnit='R1050400AD31', Recall_flag__c = FALSE, ManagedContentName__c = 'MenChilkatNylonBoots', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Mens Chilkat Nylon Boots are perfect for winter conditions, featuring a waterproof ballistic nylon upper and 200 g Heatseeker Eco insulation to keep your feet warm and dry. The TNF Winter Grip rubber outsole with IcePick temperature-sensitive lugs ensures excellent traction on icy surfaces. A compression-molded EVA midsole provides long-lasting cushioning and support, making these boots ideal for cold and wet weather.'));
            Products.add(new Product2(Name = 'Men Chilkat Nylon Boots',IsActive = TRUE,  StockKeepingUnit='R1050400AD32', Recall_flag__c = FALSE, ManagedContentName__c = 'MenChilkatNylonBoots', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Mens Chilkat Nylon Boots are perfect for winter conditions, featuring a waterproof ballistic nylon upper and 200 g Heatseeker Eco insulation to keep your feet warm and dry. The TNF Winter Grip rubber outsole with IcePick temperature-sensitive lugs ensures excellent traction on icy surfaces. A compression-molded EVA midsole provides long-lasting cushioning and support, making these boots ideal for cold and wet weather.'));
            
            
			Products.add(new Product2(Name = 'Homestead Shelter',IsActive = TRUE,  StockKeepingUnit='R1050112BUY1', Recall_flag__c = FALSE, ManagedContentName__c = 'HomesteadShelter', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='This Homestead Shelter tent has an easy-pitch design, large doors that can accommodate a queen-size inflatable mattress, and thoughtful accessories like a gear loft, pole bag, phone holder, tablet-viewing system, and side “nightstand” pockets for convenient storage. Additional features include internal dry lines, a Velcro lantern hang loop for lighting, and T entertainment compatibility (sold separately), making it the perfect choice.'));
			
            Products.add(new Product2(Name = 'Homestead Roomy',IsActive = TRUE,  StockKeepingUnit='R1050112GEY1', Recall_flag__c = FALSE, ManagedContentName__c = 'HomesteadRoomy', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='This is typical two-person tent, with abundant headroom and a comfortable layout. Featuring an easy-pitch design, it includes thoughtful accessories like a gear loft, pole bag, phone holder, tablet-viewing system, and side “nightstand” pockets for organized storage. The large doors can fit a queen-size inflatable mattress, and the internal dry lines keep your gear dry.'));
            
            Products.add(new Product2(Name = 'Homestead Domey 3 Tent',IsActive = TRUE,  StockKeepingUnit='R1050112AFI1', Recall_flag__c = TRUE, ManagedContentName__c = 'HomesteadDomey3Tent', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Homestead Domey 3 tent is designed for camping enthusiasts, offering a spacious and comfortable shelter for up to three people. It features a large dome design with three full doors for easy access and a mesh skylight for stargazing. The single-wall construction is fully waterproof, making it suitable for various weather conditions. Additionally, it includes a duffel bag stuff sack for easy transport and packing.'));
			
            Products.add(new Product2(Name = 'Furnace Sleeping Bags',IsActive = TRUE,  StockKeepingUnit='R1050406ADA1', Recall_flag__c = FALSE, ManagedContentName__c = 'FurnaceSleepingBags', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Furnace Sleeping Bag is designed for 3-season backpacking, offering warmth and comfort in various conditions. It features 600-fill ProDown insulation, which is water-resistant and dries faster than traditional down. The bag includes an anti-compression layer of Heatseeker Eco synthetic insulation on the bottom to eliminate cold spots. With a temperature rating of 20°F (-7°C), it provides reliable warmth in cooler weather. The roomy design and fitted hood enhance comfort, making it ideal for outdoor adventures'));
			Products.add(new Product2(Name = 'Furnace Sleeping Bags',IsActive = TRUE,  StockKeepingUnit='R1050406ADA2', Recall_flag__c = FALSE, ManagedContentName__c = 'FurnaceSleepingBags', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL,
							Description='The Furnace Sleeping Bag is designed for 3-season backpacking, offering warmth and comfort in various conditions. It features 600-fill ProDown insulation, which is water-resistant and dries faster than traditional down. The bag includes an anti-compression layer of Heatseeker Eco synthetic insulation on the bottom to eliminate cold spots. With a temperature rating of 20°F (-7°C), it provides reliable warmth in cooler weather. The roomy design and fitted hood enhance comfort, making it ideal for outdoor adventures'));
			
			Products.add(new Product2(Name = 'Duramo Speed Shoes',IsActive = TRUE,  StockKeepingUnit='R1050013AFI1', Recall_flag__c = FALSE, ManagedContentName__c = 'DuramoSpeedShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Duramo Speed Shoes are designed for runners seeking a lightweight and breathable option and mostly used in marathon. They feature a mesh upper for excellent ventilation and a Lightstrike midsole for responsive cushioning. The durable Adiwear outsole provides reliable traction on various surfaces. These shoes are ideal for daily runs and dynamic movements, offering a stable yet featherlight ride. They are best suited for warm and dry weather conditions due to their breathability'));
			Products.add(new Product2(Name = 'Duramo Speed Shoes',IsActive = TRUE,  StockKeepingUnit='R1050013AFI2', Recall_flag__c = FALSE, ManagedContentName__c = 'DuramoSpeedShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Duramo Speed Shoes are designed for runners seeking a lightweight and breathable option and mostly used in marathon. They feature a mesh upper for excellent ventilation and a Lightstrike midsole for responsive cushioning. The durable Adiwear outsole provides reliable traction on various surfaces. These shoes are ideal for daily runs and dynamic movements, offering a stable yet featherlight ride. They are best suited for warm and dry weather conditions due to their breathability'));
			Products.add(new Product2(Name = 'Duramo Speed Shoes',IsActive = TRUE,  StockKeepingUnit='R1050013AFI3', Recall_flag__c = FALSE, ManagedContentName__c = 'DuramoSpeedShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Duramo Speed Shoes are designed for runners seeking a lightweight and breathable option and mostly used in marathon. They feature a mesh upper for excellent ventilation and a Lightstrike midsole for responsive cushioning. The durable Adiwear outsole provides reliable traction on various surfaces. These shoes are ideal for daily runs and dynamic movements, offering a stable yet featherlight ride. They are best suited for warm and dry weather conditions due to their breathability'));
			Products.add(new Product2(Name = 'Duramo Speed Shoes',IsActive = TRUE,  StockKeepingUnit='R1050013AFI4', Recall_flag__c = FALSE, ManagedContentName__c = 'DuramoSpeedShoes', NumberOfQuantityInstallments = NULL, NumberOfRevenueInstallments = NULL, Product_Catalog__c = 'Premium', Total_Quantity__c = NULL, 
							Description='The Duramo Speed Shoes are designed for runners seeking a lightweight and breathable option and mostly used in marathon. They feature a mesh upper for excellent ventilation and a Lightstrike midsole for responsive cushioning. The durable Adiwear outsole provides reliable traction on various surfaces. These shoes are ideal for daily runs and dynamic movements, offering a stable yet featherlight ride. They are best suited for warm and dry weather conditions due to their breathability'));
								  
            if(Products != null && Products.Size() > 0){
                 Insert Products; //36 products
                  system.debug('Products:'+Products);
            }
                 
            Map<String, Product2> ProductMap = new Map<String, Product2>();
            Map<String,Product2> productNameMap1 = new Map<String,Product2>();
            Map<Id,Product2> ProdcutPriceEntryMap = new Map<Id,Product2>();
            List<Product2> productList = [SELECT Id, Name, StockKeepingUnit,Type FROM Product2 WHERE Name IN ('Men Chilkat Nylon Boots','Men Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags',
                                          'Homestead Domey 3 Tent','Homestead Roomy','Homestead Shelter','UltraRunBreeze','Northstar','Talus4')];
            if(productList != null && productList.size() > 0){
                	    for (Product2 Prod : productList) {
                            if(Prod.Type == 'Base' && Prod.Type != NULL){
                                    ProductMap.put(Prod.Name, Prod);
                                system.debug('productMap'+ ProductMap);
                            } else{
                                productNameMap1.put(Prod.StockKeepingUnit, Prod);
                                system.debug('productNameMap'+ productNameMap1);
                            }
                            ProdcutPriceEntryMap.put(Prod.Id,Prod);
           				 }
            }
            system.debug('ProductMap:'+ProductMap);
            
             
            //fetch Product Attribute Set
            ProductAttributeSet PASShoe = [SELECT DeveloperName,Id,MasterLabel FROM ProductAttributeSet where DeveloperName = 'Shoe_Variations' Limit 1]; //, 'Tent & Sleeping Bags'
         	system.debug('PASShoe:'+PASShoe);
            
              ProductAttributeSet PASTent = [SELECT DeveloperName,Id,MasterLabel FROM ProductAttributeSet where DeveloperName ='Tent_Sleeping_Bags' Limit 1];
         	system.debug('PASTent:'+PASTent);
            
            //ProductAttributeSetProduct creation
            List <ProductAttributeSetProduct> PASP = new List<ProductAttributeSetProduct>();

			PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Men Chilkat Nylon Boots').Id, ProductAttributeSetId = PASShoe.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductAttributeSetId = PASShoe.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Duramo Speed Shoes').Id, ProductAttributeSetId = PASShoe.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Furnace Sleeping Bags').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Homestead Domey 3 Tent').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Homestead Roomy').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Homestead Shelter').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('UltraRunBreeze').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Northstar').Id, ProductAttributeSetId = PASTent.Id));
            PASP.add(new ProductAttributeSetProduct(ProductId = ProductMap.get('Talus4').Id, ProductAttributeSetId = PASTent.Id));
            
            if(PASP != NULL && PASP.size() > 0){
            Insert PASP;
                system.debug('Product Attr Set Prodcut:'+PASP);
            }

            
            //Product Attribute creation
            List<ProductAttribute> ProAttribute = new List<ProductAttribute>();
    
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('UltraRunBreeze').Id, ProductId = productNameMap1.get('R1050279A1T7').Id, Sequence = 2, Star__c ='3',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '8'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('UltraRunBreeze').Id, ProductId = productNameMap1.get('R1050279A1T8').Id, Sequence = 3, Star__c ='3',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '9'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('UltraRunBreeze').Id, ProductId = productNameMap1.get('R1050279A1T9').Id, Sequence = 1, Star__c ='3',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '7'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD0').Id, Sequence = 6,Durability__c = 'High Durability', Size__c = 'Right Hand'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD1').Id, Sequence = 4,  Durability__c = 'High Durability', Size__c = 'One Size'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD2').Id, Sequence = 3, Durability__c = 'High Durability', Size__c = '10'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD3').Id, Sequence = 2, Durability__c = 'High Durability', Size__c = '9'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD4').Id, Sequence = 1, Durability__c = 'High Durability', Size__c = '8'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD5').Id, Sequence = 0, Durability__c = 'High Durability', Size__c = 'Left Hand'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Talus4').Id, ProductId = productNameMap1.get('R1050112ASD6').Id, Sequence = 5, Durability__c = 'High Durability', Size__c = '7'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Northstar').Id, ProductId = productNameMap1.get('R1050112ABC1').Id, Sequence = 2, Durability__c = 'High Durability', Size__c = 'One Size'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductId = productNameMap1.get('R1050041AC71').Id, Sequence = 1, Star__c ='5',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '7'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductId = productNameMap1.get('R1050041AC72').Id, Sequence = 2, Star__c ='5',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '8'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductId = productNameMap1.get('R1050041AC73').Id, Sequence = 3, Star__c ='5',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '9'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductId = productNameMap1.get('R1050041AC74').Id, Sequence = 4, Star__c ='5',Weight__c='0.5 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Casual', Size__c = '10'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Chilkat Nylon Boots').Id, ProductId = productNameMap1.get('R1050400AD31').Id, Sequence = 1, Star__c ='4',Weight__c='1 kg', Ventilation__c = 'Moderate Ventilation', Durability__c = 'Medium Durability', Category__c = 'Outdoor' ));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Men Chilkat Nylon Boots').Id, ProductId = productNameMap1.get('R1050400AD32').Id, Sequence = 3, Star__c ='5',Weight__c='0.8 kg', Ventilation__c = 'High Ventilation', Durability__c = 'High Durability', Category__c = 'Outdoor' ));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Homestead Shelter').Id, ProductId = productNameMap1.get('R1050112BUY1').Id, Sequence = 3, Durability__c = 'High Durability', Size__c = 'One Size'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Homestead Roomy').Id, ProductId = productNameMap1.get('R1050112GEY1').Id, Sequence = 1,  Durability__c = 'High Durability', Size__c = 'One Size'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Homestead Domey 3 Tent').Id, ProductId = productNameMap1.get('R1050112AFI1').Id, Sequence = 1, Durability__c = 'High Durability', Size__c = 'One Size'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Furnace Sleeping Bags').Id, ProductId = productNameMap1.get('R1050406ADA1').Id, Sequence = 1, Durability__c = 'High Durability', Size__c = 'Right Hand'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Furnace Sleeping Bags').Id, ProductId = productNameMap1.get('R1050406ADA2').Id, Sequence = 2, Durability__c = 'High Durability', Size__c = 'Left Hand'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Duramo Speed Shoes').Id, ProductId = productNameMap1.get('R1050013AFI1').Id, Sequence = 1, Star__c ='4',Weight__c='0.8 kg', Ventilation__c = 'Ultra Ventilated', Durability__c = 'High Durability', Category__c = 'Sports', Size__c = '7'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Duramo Speed Shoes').Id, ProductId = productNameMap1.get('R1050013AFI2').Id, Sequence = 2, Star__c ='4',Weight__c='0.8 kg', Ventilation__c = 'Ultra Ventilated', Durability__c = 'High Durability', Category__c = 'Sports', Size__c = '8'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Duramo Speed Shoes').Id, ProductId = productNameMap1.get('R1050013AFI3').Id, Sequence = 3, Star__c ='4',Weight__c='0.8 kg', Ventilation__c = 'Ultra Ventilated', Durability__c = 'High Durability', Category__c = 'Sports', Size__c = '9'));
            ProAttribute.add(new ProductAttribute(VariantParentId = ProductMap.get('Duramo Speed Shoes').Id, ProductId = productNameMap1.get('R1050013AFI4').Id, Sequence = 4, Star__c ='4',Weight__c='0.5 kg', Ventilation__c = 'Ultra Ventilated', Durability__c = 'High Durability', Category__c = 'Casual' ));
           
            if(ProAttribute != NULL && ProAttribute.size() > 0){
                 system.debug('Before ProAttribute'+ProAttribute);
                     Insert ProAttribute;
                       system.debug('After insrted ProAttribute'+ProAttribute);                    
              }
          
                                
            // Fetch Price Book
            Pricebook2 stdPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
            system.debug('stdPriceBook:'+stdPriceBook);
            
             Pricebook2 RetailPriceBook = [SELECT Id,IsStandard,Name FROM Pricebook2 where Name = 'Outfitters Price Book' LIMIT 1];
               system.debug('RetailPriceBook:'+RetailPriceBook);            
            
               // Create Standard Price Book Entry
            List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
            
            List<PricebookEntry> stdExistedPriceBookDef = [Select id,Product2.Name,UnitPrice,Pricebook2Id,Product2Id from PricebookEntry where Pricebook2Id =:stdPriceBook.Id AND Product2Id IN : ProductMap.KeySet() ];
             system.debug('stdExistedPriceBookDef:'+stdExistedPriceBookDef); 
                
              for (Id prdId : ProdcutPriceEntryMap.KeySet()) {
                  system.debug('inside first prodcut loop');
                           if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD3' && ProductMap.ContainsKey(prdId) && stdPriceBook.Id != null ) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id =ProdcutPriceEntryMap.get(prdId).Id ,UnitPrice = 340,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                    system.debug('Inside if first pricebook loop');                                                                                                                                                                              
                   	  		 }
                 			 system.debug('productName---->'+prdId);
                			 if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD31' && ProductMap.ContainsKey(prdId) && stdPriceBook.Id != null ) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 200,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                    system.debug('Inside if second pricebook loop');                                                                                                                                                                              
                   	  		 } 
                  			if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD32' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 200,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                    system.debug('Inside if thrid pricebook loop');                                                                                                                                                                             
                   	  		 } 
                             if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC7' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {	
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                pricebookEntries.add(pricebookEntry);
                                  system.debug('Inside if fourth pricebook ');   
                   	  		 }
                      		if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC71' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                pricebookEntries.add(pricebookEntry);
                                  system.debug('Inside if five pricebook ');   
                   	  		 }
                 			 if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC72' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                pricebookEntries.add(pricebookEntry);
                                  system.debug('Inside if six pricebook ');   
                   	  		 }
                  		if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC73' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {               
                  				PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 237,IsActive = true);
                                pricebookEntries.add(pricebookEntry);
                                  system.debug('Inside if seven pricebook ');   
                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC74'  && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 237,IsActive = true);
                                pricebookEntries.add(pricebookEntry);
                                  system.debug('Inside if eight pricebook ');   
                   	  		 }
                      
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) { 
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 325,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                 system.debug('Inside if nine pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI1' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 326,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                 system.debug('Inside if ten pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI2' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {          
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                 system.debug('Inside if eleven pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI3'  && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {         
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                 system.debug('Inside if 12 pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI4'  && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {         
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                                 system.debug('Inside if 13 pricebook ');   

                   	  		 }
                      
                          if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 179,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 14 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA1' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 180,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 15 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA2' && ProdcutPriceEntryMap.ContainsKey(prdId) && stdPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 181,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 16 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112AFI' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 249,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 17 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112AFI1'  && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {          
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 248,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 18 pricebook ');   

                   	  		 }
                  
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112GEY' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 300,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 19 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112GEY1'  && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id =ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 300,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 20 pricebook ');   

                   	  		 }
                  
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112BUY' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 330,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 21 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112BUY1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 330,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 22 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ABC' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 350,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 23 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ABC1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 351,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 24 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 130,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 25 pricebook ');   
                  }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T8' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 139,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 26 pricebook ');
                   }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T7' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {    
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 140,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 27 pricebook ');

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T9' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {    
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 141,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 28 pricebook ');

                   	  		 }
                      
                      
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 399,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 29 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD0' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id, Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 398,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 30 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 396,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 31 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD2' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 397,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 32 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD3' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 395,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 33 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD4' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 392,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 34 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD5' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 391,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 35 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD6' && ProdcutPriceEntryMap.ContainsKey(prdId)  && stdPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = stdPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 393,IsActive = true);
                                 pricebookEntries.add(pricebookEntry);
                              system.debug('Inside if 36 pricebook ');   

                   	  		 }                     
                }
            
             system.debug('pricebookEntries:'+pricebookEntries);
            if(pricebookEntries != null && pricebookEntries.size() > 0 && stdExistedPriceBookDef.Size() == 0) { 
                system.debug('Inside Pricebook entry Insertion loop');
                Insert pricebookEntries;  
                system.debug('pricebookEntries:'+pricebookEntries);
            }
            
            List<PricebookEntry> retailPBEntryList = new List<PricebookEntry>();
            
            List<PricebookEntry> retailpricebookEntriesList = [Select id,Product2.Name,UnitPrice,Pricebook2Id,Product2Id from PricebookEntry where Pricebook2Id =:RetailPriceBook.Id 
                                                            AND Product2Id IN : ProductMap.KeySet() ];
            system.debug('retailpricebookEntriesList:'+retailpricebookEntriesList);
            
            for (Id prdId : ProdcutPriceEntryMap.KeySet()) {
                  system.debug('inside retail pricebook entry loop');
                           if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD3' && ProductMap.ContainsKey(prdId) && RetailPriceBook.Id != null ) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id =ProdcutPriceEntryMap.get(prdId).Id ,UnitPrice = 340,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                    system.debug('Inside if first pricebook loop');                                                                                                                                                                              
                   	  		 }
                 			 system.debug('productName---->'+prdId);
                			 if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD31' && ProductMap.ContainsKey(prdId) && RetailPriceBook.Id != null ) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 200,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                    system.debug('Inside if second pricebook loop');                                                                                                                                                                              
                   	  		 } 
                  			if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050400AD32' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {
                               PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 200,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                    system.debug('Inside if thrid pricebook loop');                                                                                                                                                                             
                   	  		 } 
                             if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC7' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {	
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                retailPBEntryList.add(pricebookEntry);
                                  system.debug('Inside if fourth pricebook ');   
                   	  		 }
                      		if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC71' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                retailPBEntryList.add(pricebookEntry);
                                  system.debug('Inside if five pricebook ');   
                   	  		 }
                 			 if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC72' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 234,IsActive = true);
                                retailPBEntryList.add(pricebookEntry);
                                  system.debug('Inside if six pricebook ');   
                   	  		 }
                  		if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC73' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {               
                  				PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 237,IsActive = true);
                                retailPBEntryList.add(pricebookEntry);
                                  system.debug('Inside if seven pricebook ');   
                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050041AC74'  && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 237,IsActive = true);
                                retailPBEntryList.add(pricebookEntry);
                                  system.debug('Inside if eight pricebook ');   
                   	  		 }
                      
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) { 
                                 PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 325,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                 system.debug('Inside if nine pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI1' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 326,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                 system.debug('Inside if ten pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI2' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {          
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                 system.debug('Inside if eleven pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI3'  && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {         
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                 system.debug('Inside if 12 pricebook ');   

                   	  		 }
                      if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050013AFI4'  && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {         
                      PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 327,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                                 system.debug('Inside if 13 pricebook ');   

                   	  		 }
                      
                          if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 179,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 14 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA1' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 180,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 15 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050406ADA2' && ProdcutPriceEntryMap.ContainsKey(prdId) && RetailPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 181,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 16 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112AFI' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 249,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 17 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112AFI1'  && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {          
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 248,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 18 pricebook ');   

                   	  		 }
                  
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112GEY' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 300,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 19 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112GEY1'  && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id =ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 300,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 20 pricebook ');   

                   	  		 }
                  
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112BUY' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 330,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 21 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112BUY1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 330,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 22 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ABC' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 350,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 23 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ABC1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {  
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 351,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 24 pricebook ');   

                   	  		 }
                  
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 130,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 25 pricebook ');   
                  }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T8' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 139,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 26 pricebook ');
                   }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T7' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {    
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 140,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 27 pricebook ');

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050279A1T9' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {    
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 141,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 28 pricebook ');

                   	  		 }
                      
                      
                  if( ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                              PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 399,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 29 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD0' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id, Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 398,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 30 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD1' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 396,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 31 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD2' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 397,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 32 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD3' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) {
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 395,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 33 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD4' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 392,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 34 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD5' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 391,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 35 pricebook ');   

                   	  		 }
                  if(ProdcutPriceEntryMap.get(prdId).StockKeepingUnit == 'R1050112ASD6' && ProdcutPriceEntryMap.ContainsKey(prdId)  && RetailPriceBook.Id != null) { 
                  PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = RetailPriceBook.Id,Product2Id = ProdcutPriceEntryMap.get(prdId).Id,UnitPrice = 393,IsActive = true);
                                 retailPBEntryList.add(pricebookEntry);
                              system.debug('Inside if 36 pricebook ');   

                   	  		 }                    
                }
            
             system.debug('Retail pricebookEntries:'+pricebookEntries);
            if(retailPBEntryList != null && retailPBEntryList.size() > 0 && retailpricebookEntriesList.Size() == 0) { 
                Insert retailPBEntryList;  
                system.debug('Retail pricebookEntries after insertion:'+retailPBEntryList);
            }
            
            //assign product catgeory for products
             List<ProductCategoryProduct> ProductCategoryProducts = new List<ProductCategoryProduct>();
            List<ProductCategoryProduct> productCatgProductList = [Select id,name,ProductId,ProductCategoryId from ProductCategoryProduct where ProductId IN :ProdcutPriceEntryMap.KeySet()];
              system.debug('productCatgProductList:'+productCatgProductList);
            if(productCatgProductList.size() == 0){
            	for(ProductCategory cat: prodCategory){
                
                    if(cat.Name == 'Footwear'){
                        ProductCategoryProduct PCP1 = new ProductCategoryProduct(ProductId = ProductMap.get('Men Chilkat Nylon Boots').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP1);
                        ProductCategoryProduct PCP2 = new ProductCategoryProduct(ProductId = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP2);
                        ProductCategoryProduct PCP3 = new ProductCategoryProduct(ProductId = ProductMap.get('Duramo Speed Shoes').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP3);
                        ProductCategoryProduct PCP4 = new ProductCategoryProduct(ProductId = ProductMap.get('UltraRunBreeze').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP4);
                    }
                    if(cat.Name == 'Gear'){
                        ProductCategoryProduct PCP5 = new ProductCategoryProduct(ProductId = ProductMap.get('Furnace Sleeping Bags').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP5);
                        ProductCategoryProduct PCP6 = new ProductCategoryProduct(ProductId = ProductMap.get('Homestead Domey 3 Tent').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP6);
                        ProductCategoryProduct PCP7 = new ProductCategoryProduct(ProductId = ProductMap.get('Homestead Roomy').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP7);
                        ProductCategoryProduct PCP8 = new ProductCategoryProduct(ProductId = ProductMap.get('Homestead Shelter').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP8);
                        ProductCategoryProduct PCP9 = new ProductCategoryProduct(ProductId = ProductMap.get('Northstar').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP9);
                        ProductCategoryProduct PCP10 = new ProductCategoryProduct(ProductId =ProductMap.get('Talus4').Id, ProductCategoryId =cat.Id); 
                        ProductCategoryProducts.add(PCP10);                                                   
                    }      
           		 }
            }
             system.debug('productcategory product'+ProductCategoryProducts);
                if(ProductCategoryProducts.Size() > 0){
                insert ProductCategoryProducts;
                    system.debug('after productcategory product'+ProductCategoryProducts);
                }

            //Assign Entitlement policy
            List<CommerceEntitlementProduct> commercePolicyList = new List<CommerceEntitlementProduct>();
            CommerceEntitlementPolicy  cmrceentiltmntPolicy = [SELECT Id, Name FROM CommerceEntitlementPolicy WHERE Name = 'All Access for Outfitters' LIMIT 1];
            system.debug('cmrceentiltmntPolicy:'+cmrceentiltmntPolicy);
            List<CommerceEntitlementProduct> commerceEntProductList = [Select id,ProductId,PolicyId from CommerceEntitlementProduct where ProductId IN : productList AND PolicyId =:cmrceentiltmntPolicy.Id];
             system.debug('commerceEntProductList:'+commerceEntProductList);
            if(commerceEntProductList.Size() == 0){
                for(Product2 pId : productList){
                    CommerceEntitlementProduct cep = New CommerceEntitlementProduct();
                    cep.PolicyId = cmrceentiltmntPolicy.Id;
                    cep.ProductId = pId.Id;
                    commercePolicyList.add(cep);
                }
            }
            if(!commercePolicyList.isempty()){
                insert commercePolicyList;
                 system.debug('commercePolicyList:'+commercePolicyList);
            } 
        }catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw e;
        }
    }
}