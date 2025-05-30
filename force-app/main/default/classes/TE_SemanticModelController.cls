public without sharing class TE_SemanticModelController {


    public class OptionWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }

    public class SemanticModelWrapper {
        @AuraEnabled public List<OptionWrapper> options;
        @AuraEnabled public String currentSelection;
    }

    @AuraEnabled(cacheable=true)
    public static SemanticModelWrapper getSemanticModelsAndSelection() {
        SemanticModelWrapper wrapper = new SemanticModelWrapper();
        wrapper.options = fetchAllSemanticModels();

        Tableau_Semantic_Model__mdt record = [
            SELECT Semantic_Model_API_Name__c
            FROM Tableau_Semantic_Model__mdt
            LIMIT 1
        ];
        wrapper.currentSelection = record.Semantic_Model_API_Name__c;

        return wrapper;
    }

    @AuraEnabled
    public static void updateSelectedModel(String selectedApiName) {
        updateModelInFuture(selectedApiName);
    }
    
    @Future(callout=true)
    public static void updateModelInFuture(String selectedApiName) {    
        try {
            System.debug('Starting updateSelectedModel with selectedApiName: ' + selectedApiName);
        
            MetadataService.MetadataPort service = createService();

            // Step 1: Query the current record
            Tableau_Semantic_Model__mdt currentModel;
            try {
                currentModel = [
                    SELECT DeveloperName, MasterLabel
                    FROM Tableau_Semantic_Model__mdt
                    WHERE Semantic_Model_API_Name__c = :selectedApiName
                    LIMIT 1
                ];
                System.debug('Found existing record: ' + currentModel);
            } catch (Exception e) {
                System.debug('No matching record found or query failed: ' + e.getMessage());
                currentModel = null;
            }
            
            // Step 2: Delete all existing records
            List<Tableau_Semantic_Model__mdt> allRecords = [
                SELECT DeveloperName
                FROM Tableau_Semantic_Model__mdt
            ];

            if (!allRecords.isEmpty()) {
                List<String> recordIdsToDelete = new List<String>();
                for (Tableau_Semantic_Model__mdt record : allRecords) {
                    recordIdsToDelete.add('Tableau_Semantic_Model__mdt.' + record.DeveloperName);
                }

                System.debug('Attempting to delete records: ' + recordIdsToDelete);

                List<MetadataService.DeleteResult> deleteResults = service.deleteMetadata(
                    'CustomMetadata',
                    recordIdsToDelete
                );

                for (MetadataService.DeleteResult deleteResult : deleteResults) {
                    if (!deleteResult.success) {
                        System.debug('Error during record deletion: ' + deleteResult.errors[0].message);
                    }
                }
                System.debug('All existing records deleted successfully.');
            }

        
            // Step 3: Create a new record with the selected API Name
            System.debug('Creating new record with API Name: ' + selectedApiName);
        
            MetadataService.CustomMetadata customMetadata = new MetadataService.CustomMetadata();
            customMetadata.fullName = 'Tableau_Semantic_Model__mdt.' + selectedApiName;
            customMetadata.label = 'Semantic Model';
            customMetadata.values = new List<MetadataService.CustomMetadataValue>();
        
            MetadataService.CustomMetadataValue apiNameValue = new MetadataService.CustomMetadataValue();
            apiNameValue.field = 'Semantic_Model_API_Name__c';
            apiNameValue.value = selectedApiName;
            customMetadata.values.add(apiNameValue);
        
            List<MetadataService.SaveResult> saveResults = service.createMetadata(
                new List<MetadataService.Metadata>{ customMetadata }
            );
        
            for (MetadataService.SaveResult saveResult : saveResults) {
                if (!saveResult.success) {
                    System.debug('Error during record creation: ' + saveResult.errors[0].message);
                }
            }
            System.debug('Record created successfully.');
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }

    private static MetadataService.MetadataPort createService() {        
        // Create a new MetadataService instance
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        
        // Use the session ID (no named credential)
        String endpoint = URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/m/63.0';
        service.endpoint_x = endpoint;
    
        // Manually add the session header using the current session ID
        String sessionId = UserInfo.getSessionId();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
    
        return service;
    }
    
    private static List<OptionWrapper> fetchAllSemanticModels() {
        List<OptionWrapper> models = new List<OptionWrapper>();

        List<TE_GenericInvoker.RequestWrapper> invokerRequests = new List<TE_GenericInvoker.RequestWrapper>();
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'getSemanticModelCollection';
        request.method = 'GET';
        invokerRequests.add(request);

        List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(invokerRequests);

        if (responses.isEmpty() || 
            (responses[0].status != 'Success' && responses[0].status != 'Success (From Cache)')) {
            throw new AuraHandledException(
                'Failed to fetch semantic models: ' + 
                (responses.isEmpty() ? 'No response received' : responses[0]?.resultText)
            );
        }

        String jsonResponse = responses[0].resultText;
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        if (responseMap != null && responseMap.containsKey('items')) {
            List<Object> items = (List<Object>) responseMap.get('items');
            for (Object item : items) {
                Map<String, Object> itemMap = (Map<String, Object>) item;
                OptionWrapper model = new OptionWrapper();
                model.label = (String) itemMap.get('label');
                model.value = (String) itemMap.get('apiName');
                models.add(model);
            }
        }

        return models;
    }
    
}