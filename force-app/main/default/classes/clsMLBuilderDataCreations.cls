public class clsMLBuilderDataCreations {
    
    public static void accountContactDataCreation(){
        
        try{
            List<Account> accountInsertion = new List<Account>();
            List<Account> accountInsertion1 = new List<Account>();
            List<Account> accountInsertion2 = new List<Account>();
            List<Account> accountInsertion4 = new List<Account>();
             List<Account> accountInsertion5 = new List<Account>();
             List<Account> accountInsertion6 = new List<Account>();
            RecordType recType = [Select id,name,developername from RecordType where developername = 'PersonAccount' limit 1];
            system.debug('DeveloperName of Rec:'+recType);
            Integer counter = 300;
          for(integer i=0;i<100;i++){
                accountInsertion.add(new Account(FirstName = 'ML Model', LastName = 'Churn' + i,
                                                 PersonEmail = 'snehal.salve@salesforce.com',Phone = '9028297345',
                                                 Gender__pc = 'Male',
                                                 Age__pc = 26,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '5,00,001-20,00,000',
                                                 Customer_Satisfaction_CSAT__pc = 8,
                                                 Net_Promoter_Score_NPS__pc = 7,
                                                 Customer_Lifetime_Value_CLV__pc = 40000,
                                                 Engagement_Frequency__pc = '21 Days',
                                                 Recency_Of_Purchase__pc = '12 Days',
                                                 Payment_Method__pc	 = 'Debit Card',
                                                 Average_Order__pc = 30,
                                                 Number_of_Complaint__pc = 15,
                                                 Number_of_Product_Return__pc = 40,
                                                 Churn_Score__pc = 40,
                                                 Location__pc = 'USA',
                                                 Days_since_the_last_order__pc = 25,
                                                 Number_of_orders_period__pc = '1 month',
                                                 Average_time_between_orders__pc = '20 days' ,
                                                 Total_Amount_Spent_LTV__pc = 86000,
                                                 Total_amount_spent_period__pc = '50000 in 20 days',
                                                 Average_order_value__pc = 20000,
                                                 Maximum_order_value__pc = 76000,
                                                 Number_of_Unique_Products_Purchased__pc = 90,
                                                 Most_Frequently_Purchased__pc = 'UltraRunBreeze 3000',
                                                 Last_Purchased_Product_Categories__pc = 'Walking Shoes',
                                                 Average_Quantity_per_Order__pc = 20,
                                                 Ordered_In_Last_30_Days__pc = True,
                                                 RecordTypeId = recType.Id));
            }
            insert accountInsertion;
            system.debug('accountInsertion:'+accountInsertion);
            
            
            for(integer i=0;i<100;i++){
                String lastNameAcc = 'Churn' + Counter;
                accountInsertion1.add(new Account(FirstName = 'ML Model', LastName = lastNameAcc,
                                                 PersonEmail = 'snehal.salve1@salesforce.com',Phone = '9028297365',
                                                 Gender__pc = 'Female',
                                                 Age__pc = 28,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '20,00,001-50,00,000',
                                                 Customer_Satisfaction_CSAT__pc = 9,
                                                 Net_Promoter_Score_NPS__pc = 9,
                                                 Customer_Lifetime_Value_CLV__pc = 60000,
                                                 Engagement_Frequency__pc = '14 Days',
                                                 Recency_Of_Purchase__pc = '20 Days',
                                                 Payment_Method__pc	 = 'Debit Card',
                                                 Average_Order__pc = 35,
                                                 Number_of_Complaint__pc = 21,
                                                 Number_of_Product_Return__pc = 45,
                                                 Churn_Score__pc = 45,
                                                 Location__pc = 'USA',
                                                 Days_since_the_last_order__pc = 10,
                                                 Number_of_orders_period__pc = '25 days',
                                                 Average_time_between_orders__pc = '17 days',
                                                 Total_Amount_Spent_LTV__pc = 80000,
                                                 Total_amount_spent_period__pc = '60000 in 20 days',
                                                 Average_order_value__pc = 25000,
                                                 Maximum_order_value__pc = 60000,
                                                 Number_of_Unique_Products_Purchased__pc = 100,
                                                 Most_Frequently_Purchased__pc = 'Duramo Speed Shoes',
                                                 Last_Purchased_Product_Categories__pc = 'Sports Shoes',
                                                 Average_Quantity_per_Order__pc = 10,
                                                 Ordered_In_Last_30_Days__pc = True,
                                                 RecordTypeId = recType.Id));
                counter = counter +1;
            }
            insert accountInsertion1;
            system.debug('accountInsertion1:'+accountInsertion1);
            
            for(integer i=0;i<100;i++){
                accountInsertion2.add(new Account(FirstName = 'ML Model', LastName = 'Churn' + Counter,
                                                 PersonEmail = 'snehal.salve2@salesforce.com',Phone = '9028297355',
                                                 Gender__pc = 'Male',
                                                 Age__pc = 35,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '50,00,001 and above',
                                                 Customer_Satisfaction_CSAT__pc = 6,
                                                 Net_Promoter_Score_NPS__pc = 8,
                                                 Customer_Lifetime_Value_CLV__pc = 40000,
                                                 Engagement_Frequency__pc = '2 month',
                                                 Recency_Of_Purchase__pc = '1 Month',
                                                 Payment_Method__pc	 = 'Credit Card',
                                                 Average_Order__pc = 25,
                                                 Number_of_Complaint__pc = 10,
                                                 Number_of_Product_Return__pc = 5,
                                                 Churn_Score__pc = 35,
                                                 Location__pc = 'USA',
                                                 Days_since_the_last_order__pc = 15,
                                                 Number_of_orders_period__pc = '20 days',
                                                 Average_time_between_orders__pc = '10 days',
                                                 Total_Amount_Spent_LTV__pc = 95000,
                                                 Total_amount_spent_period__pc = '70000 in 5 days',
                                                 Average_order_value__pc = 30000,
                                                 Maximum_order_value__pc = 70000,
                                                 Number_of_Unique_Products_Purchased__pc = 55,
                                                 Most_Frequently_Purchased__pc = 'Homestead Domey 3 Tent',
                                                 Last_Purchased_Product_Categories__pc = 'Tent for Home',
                                                 Average_Quantity_per_Order__pc = 50,
                                                 Ordered_In_Last_30_Days__pc = True,
                                                 RecordTypeId = recType.Id));
                counter = counter +1;
            }
            insert accountInsertion2;
            system.debug('accountInsertion3:'+accountInsertion2);
            
            for(integer i=0;i<100;i++){
                accountInsertion4.add(new Account(FirstName = 'ML Model', LastName = 'Churn' + Counter,
                                                 PersonEmail = 'snehal.salve3@salesforce.com',Phone = '9028297245',
                                                 Gender__pc = 'Female',
                                                 Age__pc = 35,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '50,00,001 and above',
                                                 Customer_Satisfaction_CSAT__pc = 8,
                                                 Net_Promoter_Score_NPS__pc = 8,
                                                 Customer_Lifetime_Value_CLV__pc = 45000,
                                                 Engagement_Frequency__pc = '1 month',
                                                 Recency_Of_Purchase__pc = '1 Month',
                                                 Payment_Method__pc	 = 'Credit Card',
                                                 Average_Order__pc = 50,
                                                 Number_of_Complaint__pc = 20,
                                                 Number_of_Product_Return__pc = 15,
                                                 Churn_Score__pc = 39,
                                                 Location__pc = 'USA',
                                                 Days_since_the_last_order__pc = 38,
                                                 Number_of_orders_period__pc = '2 month',
                                                 Average_time_between_orders__pc = '1 month' ,
                                                 Total_Amount_Spent_LTV__pc = 84000,
                                                 Total_amount_spent_period__pc = '50000 in 2 month',
                                                 Average_order_value__pc = 28000,
                                                 Maximum_order_value__pc = 60000,
                                                 Number_of_Unique_Products_Purchased__pc = 40,
                                                 Most_Frequently_Purchased__pc = 'Stormbreak 2',
                                                 Last_Purchased_Product_Categories__pc = 'Tents',
                                                 Average_Quantity_per_Order__pc = 20,
                                                 Ordered_In_Last_30_Days__pc = false,
                                                 RecordTypeId = recType.Id));
                counter = counter +1;
            }
            insert accountInsertion4;
            system.debug('accountInsertion4:'+accountInsertion4);
            
            for(integer i=0;i<100;i++){
                accountInsertion5.add(new Account(FirstName = 'ML Model', LastName = 'Churn' + Counter,
                                                 PersonEmail = 'snehal.salve4@salesforce.com',Phone = '9028297145',
                                                 Gender__pc = 'Female',
                                                 Age__pc = 20,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '0-5,00,000',
                                                 Customer_Satisfaction_CSAT__pc = 9,
                                                 Net_Promoter_Score_NPS__pc = 9,
                                                 Customer_Lifetime_Value_CLV__pc = 50000,
                                                 Engagement_Frequency__pc = '14 days',
                                                 Recency_Of_Purchase__pc = '14 days',
                                                 Payment_Method__pc	 = 'Cash On Delivery',
                                                 Average_Order__pc = 20,
                                                 Number_of_Complaint__pc = 8,
                                                 Number_of_Product_Return__pc = 15,
                                                 Churn_Score__pc = 32,
                                                 Location__pc = 'USA',
                                                 Days_since_the_last_order__pc = 48,
                                                 Number_of_orders_period__pc = '3 month',
                                                 Average_time_between_orders__pc = '2 month' ,
                                                 Total_Amount_Spent_LTV__pc = 70000,
                                                 Total_amount_spent_period__pc = '60000 in 2 month',
                                                 Average_order_value__pc = 2500,
                                                 Maximum_order_value__pc = 59000,
                                                 Number_of_Unique_Products_Purchased__pc = 85,
                                                 Most_Frequently_Purchased__pc = 'Men’s Chilkat Nylon Boots',
                                                 Last_Purchased_Product_Categories__pc = 'Boots',
                                                 Average_Quantity_per_Order__pc = 8,
                                                 Ordered_In_Last_30_Days__pc = false,
                                                 RecordTypeId = recType.Id));
                counter = counter + 1;
            }
            insert accountInsertion5;
            system.debug('accountInsertion5:'+accountInsertion5);
            
            for(integer i=0;i<100;i++){
                accountInsertion6.add(new Account(FirstName = 'ML Model', LastName = 'Churn' + Counter,
                                                 PersonEmail = 'snehal.salve6@salesforce.com',Phone = '9028297845',
                                                 Gender__pc = 'Male',
                                                 Age__pc = 26,
                                                 Description = 'This is for ML',
                                                 Income_Level__pc = '0-5,00,000',
                                                 Customer_Satisfaction_CSAT__pc = 6,
                                                 Net_Promoter_Score_NPS__pc = 6,
                                                 Customer_Lifetime_Value_CLV__pc = 25000,
                                                 Engagement_Frequency__pc = '21 days',
                                                 Recency_Of_Purchase__pc = '21 days',
                                                 Payment_Method__pc	 = 'Cash On Delivery',
                                                 Average_Order__pc = 17,
                                                 Number_of_Complaint__pc = 12,
                                                 Number_of_Product_Return__pc = 9,
                                                 Churn_Score__pc = 40,
                                                 Location__pc = 'USA',
                                                  Days_since_the_last_order__pc = 42,
                                                 Number_of_orders_period__pc = '2 month',
                                                 Average_time_between_orders__pc = '2 month' ,
                                                 Total_Amount_Spent_LTV__pc = 82000,
                                                 Total_amount_spent_period__pc = '55000 in 2 month',
                                                 Average_order_value__pc = 3000,
                                                 Maximum_order_value__pc = 67000,
                                                 Number_of_Unique_Products_Purchased__pc = 55,
                                                 Most_Frequently_Purchased__pc = 'Homestead Shelter',
                                                 Last_Purchased_Product_Categories__pc = 'Tents',
                                                 Average_Quantity_per_Order__pc = 30,
                                                 Ordered_In_Last_30_Days__pc = false,
                                                 RecordTypeId = recType.Id));
                counter = counter + 1;
            }
            insert accountInsertion6;
            system.debug('accountInsertion6:'+accountInsertion6);
      } catch(Exception e){
            system.debug('Exception e:'+e.getMessage());
        }   
    }
   
    public static void updateExistingContact(){
        
        try{
            List<Account> accountUpdateList = new List<Account>();
            Map<String,Account> mapOfAccount = new Map<String,Account>();
            Set<Id> accountIdSet = new Set<Id>();
            List<Contact> contactList = [Select id,name,AccountId,Email from contact where Email IN ('dmacintosh@yopmail.com','msmith@yopmail.com',
                                                                                              'ngrace@yopmail.com','kwells@yopmail.com')];
            system.debug('contactList:'+contactList); 
            for(Contact  con:contactList){
                accountIdSet.add(con.AccountId);
            }
            
            List<Account> accFetchList = [Select id,FirstName, LastName from Account where id IN :accountIdSet];
            
            for(Account acc:accFetchList ){
                mapOfAccount.put(acc.Id,acc);
            }
            
            for(Account a:accFetchList){
                if(mapOfAccount.get(a.Id).FirstName == 'Karen' && mapOfAccount.get(a.Id).LastName == 'Wells'){
                    a.id = a.id;
                    a.Gender__pc = 'Female';
                    a.Age__pc = 24;
                    a.Income_Level__pc = '20,00,001-50,00,000';
                    a.Customer_Satisfaction_CSAT__pc = 8;
                    a.Net_Promoter_Score_NPS__pc = 8;
                    a.Customer_Lifetime_Value_CLV__pc = 39000;
                    a.Engagement_Frequency__pc = '28 days';
                    a.Recency_Of_Purchase__pc = '20 Days';
                    a.Payment_Method__pc = 'Debit Card';
                    a.Average_Order__pc = 32;
                    a.Number_of_Complaint__pc = 10;
                    a.Number_of_Product_Return__pc = 8;
                    a.Churn_Score__pc = 39;
                    a.Location__pc = 'USA';
                    a.Days_since_the_last_order__pc = 10;
                    a.Number_of_orders_period__pc = '1 month';
                    a.Average_time_between_orders__pc = '20 days';
                    a.Total_Amount_Spent_LTV__pc = 100000;
                    a.Total_amount_spent_period__pc = '50000 in 20 days';
                    a.Average_order_value__pc = 20000;
                    a.Maximum_order_value__pc = 76000;
                    a.Number_of_Unique_Products_Purchased__pc = 90;
                    a.Most_Frequently_Purchased__pc = 'Homestead Domey 3 Tent';
                    a.Last_Purchased_Product_Categories__pc = 'Tent';
                    a.Average_Quantity_per_Order__pc = 20;
                    a.Ordered_In_Last_30_Days__pc = True;
                    accountUpdateList.add(a);     
                }
                
                if(mapOfAccount.get(a.Id).FirstName == 'Nicole' && mapOfAccount.get(a.Id).LastName == 'Grace'){
                    a.id = a.id;
                    a.Gender__pc = 'Female';
                    a.Age__pc = 30;
                    a.Income_Level__pc = '50,00,001 and above';
                    a.Customer_Satisfaction_CSAT__pc = 9;
                    a.Net_Promoter_Score_NPS__pc = 7;
                    a.Customer_Lifetime_Value_CLV__pc = 40000;
                    a.Engagement_Frequency__pc = '14 days';
                    a.Recency_Of_Purchase__pc = '7 Days';
                    a.Payment_Method__pc = 'Credit Card';
                    a.Average_Order__pc = 17;
                    a.Number_of_Complaint__pc = 12;
                    a.Number_of_Product_Return__pc = 9;
                    a.Churn_Score__pc = 30;
                    a.Location__pc = 'USA';
                    a.Days_since_the_last_order__pc = 15;
                    a.Number_of_orders_period__pc = '25 days';
                    a.Average_time_between_orders__pc = '10 days';
                    a.Total_Amount_Spent_LTV__pc = 250000;
                    a.Total_amount_spent_period__pc = '50000 in 20 days';
                    a.Average_order_value__pc = 50000;
                    a.Maximum_order_value__pc = 55000;
                    a.Number_of_Unique_Products_Purchased__pc = 40;
                    a.Most_Frequently_Purchased__pc = 'Duramo Speed Shoes';
                    a.Last_Purchased_Product_Categories__pc = 'Sports Shoes';
                    a.Average_Quantity_per_Order__pc = 20;
                    a.Ordered_In_Last_30_Days__pc = True;
                    accountUpdateList.add(a);        
                }
                if(mapOfAccount.get(a.Id).FirstName == 'Mark' && mapOfAccount.get(a.Id).LastName == 'Smith'){
                    a.id = a.id;
                    a.Gender__pc = 'Male';
                    a.Age__pc = 32;
                    a.Income_Level__pc = '50,00,001 and above';
                    a.Customer_Satisfaction_CSAT__pc = 10;
                    a.Net_Promoter_Score_NPS__pc = 9;
                    a.Customer_Lifetime_Value_CLV__pc = 46000;
                    a.Engagement_Frequency__pc = '10 days';
                    a.Recency_Of_Purchase__pc = '9 Days';
                    a.Payment_Method__pc = 'Credit Card';
                    a.Average_Order__pc = 25;
                    a.Number_of_Complaint__pc = 5;
                    a.Number_of_Product_Return__pc = 5;
                    a.Churn_Score__pc = 25;
                    a.Location__pc = 'USA';
                    a.Days_since_the_last_order__pc = 10;
                    a.Number_of_orders_period__pc = '23 days';
                    a.Average_time_between_orders__pc = '10 days';
                    a.Total_Amount_Spent_LTV__pc = 300000;
                    a.Total_amount_spent_period__pc = '50000 in 20 days';
                    a.Average_order_value__pc = 50000;
                    a.Maximum_order_value__pc = 70000;
                    a.Number_of_Unique_Products_Purchased__pc = 30;
                    a.Most_Frequently_Purchased__pc = 'UltraRunBreeze 3000';
                    a.Last_Purchased_Product_Categories__pc = 'Walking Shoes';
                    a.Average_Quantity_per_Order__pc = 20;
                    a.Ordered_In_Last_30_Days__pc = True;
                    accountUpdateList.add(a);     
                }
                if(mapOfAccount.get(a.Id).FirstName == 'Duncan' && mapOfAccount.get(a.Id).LastName == 'Macintosh'){
                    a.id = a.id;
                    a.Gender__pc = 'Male';
                    a.Age__pc = 25;
                    a.Income_Level__pc = '20,00,001-50,00,000';
                    a.Customer_Satisfaction_CSAT__pc = 6;
                    a.Net_Promoter_Score_NPS__pc = 6;
                    a.Customer_Lifetime_Value_CLV__pc = 25000;
                    a.Engagement_Frequency__pc = '1 month';
                    a.Recency_Of_Purchase__pc = '1 month';
                    a.Payment_Method__pc = 'Credit Card';
                    a.Average_Order__pc = 35;
                    a.Number_of_Complaint__pc = 20;
                    a.Number_of_Product_Return__pc = 12;
                    a.Churn_Score__pc = 30;
                    a.Location__pc = 'USA';
                    a.Days_since_the_last_order__pc = 5;
                    a.Number_of_orders_period__pc = '12 days';
                    a.Average_time_between_orders__pc = '10 days';
                    a.Total_Amount_Spent_LTV__pc = 350000;
                    a.Total_amount_spent_period__pc = '50000 in 20 days';
                    a.Average_order_value__pc = 55000;
                    a.Maximum_order_value__pc = 67000;
                    a.Number_of_Unique_Products_Purchased__pc = 20;
                    a.Most_Frequently_Purchased__pc = 'Stormbreak 2';
                    a.Last_Purchased_Product_Categories__pc = 'Tent';
                    a.Average_Quantity_per_Order__pc = 20;
                    a.Ordered_In_Last_30_Days__pc = True;
                    accountUpdateList.add(a);       
                }
            }
            
            update accountUpdateList;
            system.debug('accountUpdateList:'+accountUpdateList);
        } catch(Exception e){
            system.debug('Exception:'+e.getMessage());
        }  
    }
    
}