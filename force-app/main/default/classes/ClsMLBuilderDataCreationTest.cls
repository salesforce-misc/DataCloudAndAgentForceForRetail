@isTest
public class ClsMLBuilderDataCreationTest {
    @isTest
    public static void testAccountDataInsertion(){
        RecordType recType = [Select id,name,developername from RecordType where developername = 'PersonAccount' limit 1];
        
        // Create test data
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(
                FirstName = 'Test ML Model',
                LastName = 'TestChurn' + i,
                PersonEmail = 'snehal.salve@salesforce.com',
                Phone = '1234477585',
                Gender__pc = 'Male',
                Age__pc = 26,
                Description = 'Test Data',
                Income_Level__pc = '5,00,001-20,00,000',
                Customer_Satisfaction_CSAT__pc = 8,
                Net_Promoter_Score_NPS__pc = 7,
                Customer_Lifetime_Value_CLV__pc = 40000,
                Engagement_Frequency__pc = '21 Days',
                Recency_Of_Purchase__pc = '12 Days',
                Payment_Method__pc   = 'Debit Card',
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
                RecordTypeId = recType.Id
            ));
        }
        insert testAccounts;
        
        Test.StartTest();
        clsMLBuilderDataCreations.accountContactDataCreation();
        Test.StopTest();
    }
    
    @isTest
    public static void testExistingAccountUpdation(){
         RecordType recType = [Select id,name,developername from RecordType where developername = 'PersonAccount' limit 1];
        
        List<Account> accountInsertionList = new List<Account>();
        accountInsertionList.add(new Account(FirstName = 'Duncan', LastName = 'Macintosh',Phone = '29394949494',PersonEmail = 'testDuncan@salesforce.com',
                            Gender__pc = 'Male',Age__pc = 25,Income_Level__pc = '20,00,001-50,00,000',Customer_Satisfaction_CSAT__pc = 6,
                           Net_Promoter_Score_NPS__pc = 6,Customer_Lifetime_Value_CLV__pc = 25000,Engagement_Frequency__pc = '1 month',
                          Recency_Of_Purchase__pc = '1 month',Payment_Method__pc = 'Credit Card',Average_Order__pc = 35,Number_of_Complaint__pc = 20,
                           Number_of_Product_Return__pc = 12,Churn_Score__pc = 30,Location__pc = 'USA',Days_since_the_last_order__pc = 5,
                         Number_of_orders_period__pc = '12 days',Average_time_between_orders__pc = '10 days',Total_Amount_Spent_LTV__pc = 350000,
                        Total_amount_spent_period__pc = '50000 in 20 days',Average_order_value__pc = 55000,Maximum_order_value__pc = 67000,
                        Number_of_Unique_Products_Purchased__pc = 20,Most_Frequently_Purchased__pc = 'Stormbreak 2',
                        Last_Purchased_Product_Categories__pc = 'Tent',Average_Quantity_per_Order__pc = 20,Ordered_In_Last_30_Days__pc = True,
                        RecordTypeId = recType.Id));
        
        accountInsertionList.add(new Account(FirstName = 'Karen', LastName = 'Wells',Phone = '29394949484',PersonEmail = 'testKaren@salesforce.com',
                            Gender__pc = 'Female',Age__pc = 24,Income_Level__pc = '20,00,001-50,00,000',Customer_Satisfaction_CSAT__pc = 8,
                           Net_Promoter_Score_NPS__pc = 8,Customer_Lifetime_Value_CLV__pc = 39000,Engagement_Frequency__pc = '28 days',
                          Recency_Of_Purchase__pc = '20 Days',Payment_Method__pc = 'Debit Card',Average_Order__pc = 32,Number_of_Complaint__pc = 10,
                           Number_of_Product_Return__pc = 8,Churn_Score__pc = 39,Location__pc = 'USA',Days_since_the_last_order__pc = 10,
                         Number_of_orders_period__pc = '1 month',Average_time_between_orders__pc = '20 days',Total_Amount_Spent_LTV__pc = 100000,
                        Total_amount_spent_period__pc = '50000 in 20 days',Average_order_value__pc = 20000,Maximum_order_value__pc = 76000,
                        Number_of_Unique_Products_Purchased__pc = 90,Most_Frequently_Purchased__pc = 'Homestead Domey 3 Tent',
                        Last_Purchased_Product_Categories__pc = 'Tent',Average_Quantity_per_Order__pc = 20,Ordered_In_Last_30_Days__pc = True,
                        RecordTypeId = recType.Id));
        
                accountInsertionList.add(new Account(FirstName = 'Nicole', LastName = 'Grace',Phone = '29394947884',PersonEmail = 'testnicole@salesforce.com',
                                                    Gender__pc = 'Female',Age__pc = 30,Income_Level__pc = '50,00,001 and above',
                                                    Customer_Satisfaction_CSAT__pc = 9,Net_Promoter_Score_NPS__pc = 7,Customer_Lifetime_Value_CLV__pc = 40000,
                                                     Engagement_Frequency__pc = '14 days',Recency_Of_Purchase__pc = '7 Days',Payment_Method__pc = 'Credit Card',
                                                     Average_Order__pc = 17,Number_of_Complaint__pc = 12,Number_of_Product_Return__pc = 9,Churn_Score__pc = 30,
                                                     Location__pc = 'USA',Days_since_the_last_order__pc = 15,Number_of_orders_period__pc = '25 days',
                                                     Average_time_between_orders__pc = '10 days',Total_Amount_Spent_LTV__pc = 250000,
                                                     Total_amount_spent_period__pc = '50000 in 20 days',Average_order_value__pc = 50000,Maximum_order_value__pc = 55000,
                                                      Number_of_Unique_Products_Purchased__pc = 40,Most_Frequently_Purchased__pc = 'Duramo Speed Shoes',
                                                     Last_Purchased_Product_Categories__pc = 'Sports Shoes',Average_Quantity_per_Order__pc = 20,
                                                     Ordered_In_Last_30_Days__pc = True,RecordTypeId = recType.Id));
        
           accountInsertionList.add(new Account(FirstName = 'Mark', LastName = 'Smith',Phone = '23594947884',PersonEmail = 'testmark@salesforce.com',
                                               Gender__pc = 'Male',Age__pc = 32,Income_Level__pc = '50,00,001 and above',Customer_Satisfaction_CSAT__pc = 10,
                                               Net_Promoter_Score_NPS__pc = 9,Customer_Lifetime_Value_CLV__pc = 46000,Engagement_Frequency__pc = '10 days',
                                               Recency_Of_Purchase__pc = '9 Days',Payment_Method__pc = 'Credit Card',Average_Order__pc = 25,
                                               Number_of_Complaint__pc = 5,Number_of_Product_Return__pc = 5,Churn_Score__pc = 25,Location__pc = 'USA',
                                               Days_since_the_last_order__pc = 10,Number_of_orders_period__pc = '23 days',Average_time_between_orders__pc = '10 days',
                                              Total_Amount_Spent_LTV__pc = 300000,Total_amount_spent_period__pc = '50000 in 20 days',Average_order_value__pc = 50000,
                                              Maximum_order_value__pc = 70000,Number_of_Unique_Products_Purchased__pc = 30,
                                              Most_Frequently_Purchased__pc = 'UltraRunBreeze 3000',Last_Purchased_Product_Categories__pc = 'Walking Shoes',
                                              Average_Quantity_per_Order__pc = 20,Ordered_In_Last_30_Days__pc = True,RecordTypeId = recType.Id));
        
        
        
        insert accountInsertionList;
        Test.StartTest();
        clsMLBuilderDataCreations.updateExistingContact();
        Test.StopTest();
            
    }
    
}