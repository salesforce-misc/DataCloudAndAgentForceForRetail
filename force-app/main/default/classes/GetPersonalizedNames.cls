public with sharing class GetPersonalizedNames {
    
    public class ProductWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String imageUrl;
        @AuraEnabled public String description;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProducts(List<String> productIds) {
        List<ssot__Product__dlm> productList = [
            SELECT ssot__Id__c, ssot__Name__c, ssot__Description__c, ManagedContentName__c
            FROM ssot__Product__dlm 
            WHERE ssot__Id__c IN :productIds LIMIT 3
        ];
        
       /* String orgDomain = URL.getOrgDomainUrl().toExternalForm();
        String baseURL = orgDomain.replace('.my.salesforce.com', '.vf.force.com'); 
        Long timestamp = DateTime.now().getTime();*/
        
        List<ProductWrapper> result = new List<ProductWrapper>();
        for (ssot__Product__dlm prod : productList) {
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.id = prod.ssot__Id__c;
            wrapper.name = prod.ssot__Name__c;
            wrapper.description = prod.ssot__Description__c;  
            wrapper.imageUrl = prod.ManagedContentName__c;
           /* if (prod.ManagedContentName__c != null) {
                wrapper.imageUrl = baseURL + '/resource/' + String.valueOf(timestamp) + '/' + prod.ManagedContentName__c;
            } else {
                wrapper.imageUrl = '/resource/default_image'; 
            }*/
            result.add(wrapper);
        }
        return result;
    }
    
    @AuraEnabled
    public static void sendRecommendationEmail(String accountId, String productId, String productName, String productDescription) {
        try {
            // Fetch the person's account details (name, email)
            Account personAccount = [SELECT Name, PersonEmail FROM Account WHERE Id = :accountId LIMIT 1];
            
            String accountName = personAccount.Name;
            String accountEmail = personAccount.PersonEmail;
            
            if (String.isBlank(accountEmail)) {
                throw new AuraHandledException('Invalid or missing email address for the selected account.');
            }
            
            System.debug('Account Name: ' + accountName);
            System.debug('Account Email: ' + accountEmail);
            System.debug('Product Name: ' + productName);
            System.debug('Product Description: ' + productDescription);
            
            // List to hold the recipient emails
            List<String> recipientEmails = new List<String>();
            recipientEmails.add(accountEmail);
            
            // Fetch the verified OrgWideEmailAddress with display name 'Komali'
            OrgWideEmailAddress[] owea = [SELECT Id, DisplayName FROM OrgWideEmailAddress WHERE IsVerified = TRUE LIMIT 1];
            
            // Prepare the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Check if we have a valid OrgWideEmailAddress
            if (owea.size() > 0) {
                // Set the OrgWideEmailAddress as the "FROM" address
                email.setOrgWideEmailAddressId(owea[0].Id);
            } else {
                // Handle case when no verified OrgWideEmailAddress is found
                throw new AuraHandledException('No verified OrgWideEmailAddress found for the sender.');
            }
            
            // Set the recipient email
            email.setToAddresses(recipientEmails);
            email.setSubject('We Have a Product Recommendation Just for You!');
            
            // Compose the email body
            // String emailBody = 'Hi ' + accountName + ',\n\n' +
            //                    'We hope you’re doing well!\n\n' +
            //                    'Based on your interests, we thought you might love this product from Outfitters:\n\n' +
            //                    'Product Name: ' + productName + '\n' +
            //                    'Description: ' + productDescription + '\n\n' +
            //                    'Thank you for being a valued part of the Outfitters community.\n\n' +
            //                    'Best regards,\nOutfitters Customer Service Team';
            String emailBody = '<html><body>' +
                'Hi ' + accountName + ',<br><br>' +
                'We hope you’re doing well!<br><br>' +
                'Based on your interests, we thought you might love this product from Outfitters:<br><br>' +
                '<strong>Product Name:</strong> ' + productName + '<br>' +
                '<strong>Description:</strong> ' + productDescription + '<br><br>' +
                'Thank you for being a valued part of the Outfitters community.<br><br>' +
                'Best regards,<br>' +
                'Outfitters Customer Service Team' +
                '</body></html>';
            
            // email.setPlainTextBody(emailBody);
            email.setHtmlBody(emailBody);
            
            // Send the email and capture the result
            Messaging.sendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
            // Log the email details
            System.debug('Email sent to: ' + accountEmail);
            System.debug('Email Sent with result: ' + results);
            
        } catch (Exception e) {
            // Log any errors
            System.debug('Error sending email: ' + e.getMessage());
            System.debug('Stack Trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to send email: ' + e.getMessage());
        }
    }
    
    
}