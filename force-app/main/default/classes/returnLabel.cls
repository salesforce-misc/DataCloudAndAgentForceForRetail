public  class returnLabel {
    
    public Contact contact { get; set; }
    public String shipDate { get; set; }
  /*  public returnLabel() {
        // Initialize the contact property
    contact = new Contact();
    }*/

    @AuraEnabled
    public void getContactDetails() {
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        System.debug('Contact Id' + contactId);
        if(String.isNotBlank(contactId)) {
            try{
                Date dt = Date.Today();
                shipDate = dt.format().replace('/', '-');
                System.debug('SHIP DATE'+shipDate);
                contact = [SELECT Name, Phone, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry  FROM Contact 
            WHERE Id = :contactId 
            LIMIT 1];
            }catch(Exception e){
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
         }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Contact is missing.'));
        }
        
    }
}