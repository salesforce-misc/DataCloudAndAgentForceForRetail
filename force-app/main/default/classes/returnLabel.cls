public class returnLabel {
    
    public Contact contact { get; set; }
    public String shipDate { get; set; }
    public Account account { get; set; }  // Account property to store the related Account
    
    @AuraEnabled
    public void getContactDetails() {
        String contactId = ApexPages.currentPage().getParameters().get('contactId'); // Example contact ID
        System.debug('Contact Id: ' + contactId);
        
        if(String.isNotBlank(contactId)) {
            try{
                // Get today's date
                Date dt = Date.Today();
                shipDate = dt.format().replace('/', '-');
                System.debug('SHIP DATE: ' + shipDate);

                // Query Contact with related Account's details using the relationship
                contact = [SELECT Id, Name, Phone, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, 
                           AccountId, Account.Name, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode 
                           FROM Contact WHERE Id = :contactId LIMIT 1];

                // Check if the AccountId is not null, then retrieve the Account details
                if(contact.AccountId != null) {
                    // You already have the Account details via the query on the Contact object itself
                    account = contact.Account; // This directly links the Account based on the Contact's AccountId
                    System.debug('Account Mailing Address: ' + account.ShippingStreet + ', ' + account.ShippingCity + ', ' + account.ShippingState + ', ' + account.ShippingPostalCode);
                }

            } catch(Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Contact is missing.'));
        }
    }
}