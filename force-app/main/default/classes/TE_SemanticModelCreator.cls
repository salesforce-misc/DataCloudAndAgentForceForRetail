/**
 * Class for processing and creating semantic models from payload templates.
 * This class provides methods to process static resources, parse semantic payloads,
 * and create semantic models with calculated dimensions and measurements.
 *
 * Author: Antoine Laviron
 * Contact: alaviron@salesforce.com
 */

public with sharing class TE_SemanticModelCreator {
    /**
     * Wrapper for input parameters required to process a semantic model.
     */
    public class InputWrapper {
        /** 
         * The name of the static resource containing the template payload. 
         */
        @InvocableVariable(required = true)
        public String staticResourceName;
        
        /** 
         * The new name for the semantic model to be created. 
         */
        @InvocableVariable(required = true)
        public String newModelName;

        /** 
         * The label of the semantic data object (e.g., 'Sales Cloud', 'Service Cloud'). 
         */
        @InvocableVariable(required = true)
        public String dataObjectLabel;
    }

    /**
     * Wrapper for the output results of the semantic model processing.
     */
    public class OutputWrapper {
        /** 
         * The updated payload after processing. 
         */
        @InvocableVariable
        public String updatedPayload;

        /** 
         * A list of semantic items (dimensions and measurements). 
         */
        @InvocableVariable
        public List<SemanticItem> semanticItems;

        /** 
         * The API name of the created semantic model. 
         */
        @InvocableVariable
        public String apiName;

        /**
         * Constructor for the OutputWrapper class.
         * @param updatedPayload The updated semantic model payload.
         * @param semanticItems A list of processed semantic items.
         */
        public OutputWrapper(String updatedPayload, List<SemanticItem> semanticItems) {
            this.updatedPayload = updatedPayload;
            this.semanticItems = semanticItems;
        }
    }

    /**
     * Represents a semantic item such as a dimension or measurement.
     */
    public class SemanticItem {
        public String apiName;
        public String label;
        public String description;
        public String sortOrder;
        public String displayCategory;
        public Boolean isVisible;
        public String dataType;
        public String semanticDataType;
        public Integer decimalPlace;
        public String aggregationType;
        public String sentiment;
        public Boolean shouldTreatNullsAsZeros;
        public List<Object> filters;
        public String expression;
    }

    /**
     * Invocable method to process a semantic model payload from a static resource.
     * @param inputs A list of InputWrapper objects containing input parameters.
     * @return A list of OutputWrapper objects containing the results of the processing.
     */
    @InvocableMethod(label = 'Create a Semantic Model from a template')
    public static List<OutputWrapper> processSemanticModel(List<InputWrapper> inputs) {
        List<OutputWrapper> results = new List<OutputWrapper>();

        for (InputWrapper input : inputs) {
            // Step 1: Fetch the template payload from the static resource.
            String templatePayload = getTemplatePayload(input.staticResourceName);

            // Step 2: Generate the payload for the new semantic model.
            String generatedPayload = TE_SemanticModelPayloadGenerator.generatePayload(input.newModelName, templatePayload);

            // Step 3: Parse the generated payload into a structured map.
            Map<String, Object> parsedPayload = parsePayload(generatedPayload);

            // Step 4: Extract and clear calculated fields from the payload.
            Map<String, List<Object>> calculatedFields = extractAndClearCalculatedFields(parsedPayload);
            List<Object> measurements = calculatedFields.get('measurements');
            List<Object> dimensions = calculatedFields.get('dimensions');

            // Step 5: Save new payload
            String updatedPayload = JSON.serialize(parsedPayload);

            // Step 6: Extract the semantic data object API name from the template.
            String templateSemanticDataObjectApiName = extractTemplateSemanticApiName(parsedPayload, input.dataObjectLabel);

            // Step 7: Create the semantic model via API.
            String rawResponse = invokeCreateSemanticModelApi(updatedPayload);
            Map<String, Object> responseMap = processApiResponse(rawResponse);

            // Step 8: Extract the new semantic data object API name from the response.
            String semanticDataObjectApiName = extractSemanticDataObjectApiName(responseMap, input.dataObjectLabel);

            // Validate the extracted API names.
            if (templateSemanticDataObjectApiName == null || semanticDataObjectApiName == null) {
                throw new IllegalArgumentException('Template or Semantic Data Object API Name cannot be null.');
            }

            // Extract the model ID from the response.
            String modelId = (String) responseMap.get('apiName');

            // Step 9: Build and process semantic items (dimensions and measurements).
            Map<String, List<SemanticItem>> semanticItemsMap = buildSemanticItems(measurements, dimensions, templateSemanticDataObjectApiName, semanticDataObjectApiName);

            List<SemanticItem> measurementsList = semanticItemsMap.get('measurements');
            List<SemanticItem> dimensionsList = semanticItemsMap.get('dimensions');

            // Step 10: Create calculated fields via API.
            List<Map<String, Object>> measurementResponses = createCalculatedFields(measurementsList, modelId, 'measurement');
            List<Map<String, Object>> dimensionResponses = createCalculatedFields(dimensionsList, modelId, 'dimension');
            
            // Step 11: Create and add the output wrapper to the results.
            results.add(createOutputWrapper(updatedPayload, measurementsList, responseMap));
        }
        return results;
    }

    /**
     * Invokes the API to create a calculated measurement for a semantic model.
     * 
     * @param payload The JSON payload representing the measurement to be created.
     * @param modelApiName The API name of the semantic model to which the measurement belongs.
     * @return The raw response string from the API.
     * @throws IllegalArgumentException if no response is received from the API.
     */
    private static String invokeCreateCalculatedMeasurementApi(String payload, String modelApiName) {
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'createCalculatedMeasure';
        request.method = 'POST';
        request.payload = payload;
        request.modelApiNameOrId = modelApiName;

        List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(new List<TE_GenericInvoker.RequestWrapper>{request});

        if (responses.isEmpty()) {
            throw new IllegalArgumentException('No response from the createCalculatedMeasurement API.');
        }
        return responses[0].resultText;
    }

    /**
     * Invokes the API to create a calculated dimension for a semantic model.
     * 
     * @param payload The JSON payload representing the dimension to be created.
     * @param modelApiName The API name of the semantic model to which the dimension belongs.
     * @return The raw response string from the API.
     * @throws IllegalArgumentException if no response is received from the API.
     */
    private static String invokeCreateCalculatedDimensionApi(String payload, String modelApiName) {
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'createCalculatedDimension';
        request.method = 'POST';
        request.payload = payload;
        request.modelApiNameOrId = modelApiName;

        List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(new List<TE_GenericInvoker.RequestWrapper>{request});

        if (responses.isEmpty()) {
            throw new IllegalArgumentException('No response from the createCalculatedDimension API.');
        }

        return responses[0].resultText;
    }

    /**
     * Invokes the API to create a new semantic model based on a given payload.
     * 
     * @param payload The JSON payload for the semantic model to be created.
     * @return The raw response string from the API.
     * @throws IllegalArgumentException if no response is received or if the response format is unexpected.
     */
    private static String invokeCreateSemanticModelApi(String payload) {
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'createSemanticModel';
        request.method = 'POST';
        request.payload = payload;

        List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(new List<TE_GenericInvoker.RequestWrapper>{request});

        if (responses.isEmpty()) {
            throw new IllegalArgumentException('No response from the createSemanticModel API.');
        }

        return responses[0].resultText;
    }

    /**
     * Retrieves the template payload from a static resource.
     * 
     * @param staticResourceName The name of the static resource containing the payload.
     * @return The content of the static resource as a string.
     * @throws IllegalArgumentException if the static resource cannot be found.
     */
    private static String getTemplatePayload(String staticResourceName) {
        List<StaticResource> resources = [SELECT Body FROM StaticResource WHERE Name = :staticResourceName LIMIT 1];
        if (resources.isEmpty()) {
            throw new IllegalArgumentException('Static resource with name "' + staticResourceName + '" not found.');
        }
        return resources[0].Body.toString();
    }

    /**
     * Parses a JSON payload into a structured map.
     * 
     * @param payload The JSON string to be parsed.
     * @return A map representing the structured data from the payload.
     * @throws IllegalArgumentException if the payload cannot be parsed into a map.
     */
    private static Map<String, Object> parsePayload(String payload) {
        try {
            return (Map<String, Object>) JSON.deserializeUntyped(payload);
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to parse the payload: ' + e.getMessage());
        }
    }

    /**
     * Builds semantic items (dimensions and measurements) from the provided lists and replaces placeholders
     * in expressions with the appropriate semantic data object API names.
     * 
     * @param measurements A list of measurement items from the parsed payload.
     * @param dimensions A list of dimension items from the parsed payload.
     * @param templateSemanticDataObjectApiName The API name of the template semantic data object.
     * @param semanticDataObjectApiName The API name of the new semantic data object.
     * @return A map containing two lists: 'measurements' and 'dimensions' as semantic items.
     */
    private static Map<String, List<SemanticItem>> buildSemanticItems(
        List<Object> measurements, 
        List<Object> dimensions,
        String templateSemanticDataObjectApiName, 
        String semanticDataObjectApiName
    ) {
        List<SemanticItem> semanticMeasurements = new List<SemanticItem>();
        List<SemanticItem> semanticDimensions = new List<SemanticItem>();

        // Process measurements
        if (measurements != null) {
            for (Object item : measurements) {
                if (item instanceof Map<String, Object>) {
                    semanticMeasurements.add(buildSemanticItem(
                        (Map<String, Object>) item, 
                        templateSemanticDataObjectApiName, 
                        semanticDataObjectApiName
                    ));
                }
            }
        }

        // Process dimensions
        if (dimensions != null) {
            for (Object item : dimensions) {
                if (item instanceof Map<String, Object>) {
                    semanticDimensions.add(buildSemanticItem(
                        (Map<String, Object>) item, 
                        templateSemanticDataObjectApiName, 
                        semanticDataObjectApiName
                    ));
                }
            }
        }

        return new Map<String, List<SemanticItem>>{
            'measurements' => semanticMeasurements,
            'dimensions' => semanticDimensions
        };
    }

    /**
     * Builds a single semantic item by populating its properties and replacing placeholders
     * in expressions with the appropriate semantic data object API names.
     * 
     * @param item A map representing the properties of the semantic item.
     * @param templateSemanticDataObjectApiName The API name of the template semantic data object.
     * @param semanticDataObjectApiName The API name of the new semantic data object.
     * @return A populated SemanticItem object.
     */
    private static SemanticItem buildSemanticItem(
        Map<String, Object> item,
        String templateSemanticDataObjectApiName,
        String semanticDataObjectApiName
    ) {
        if (item == null || !item.containsKey('apiName') || !item.containsKey('label')) {
            throw new IllegalArgumentException('Semantic item is missing required keys: apiName or label');
        }

        SemanticItem semanticItem = new SemanticItem();

        // Populate properties of the semantic item
        semanticItem.apiName = (String) item.get('apiName');
        semanticItem.label = (String) item.get('label');
        semanticItem.description = item.containsKey('description') ? (String) item.get('description') : null;
        semanticItem.sortOrder = item.containsKey('sortOrder') ? (String) item.get('sortOrder') : null;
        semanticItem.displayCategory = item.containsKey('displayCategory') ? (String) item.get('displayCategory') : null;
        semanticItem.isVisible = item.containsKey('isVisible') ? (Boolean) item.get('isVisible') : true; 
        semanticItem.dataType = item.containsKey('dataType') ? (String) item.get('dataType') : null;
        semanticItem.semanticDataType = item.containsKey('semanticDataType') ? (String) item.get('semanticDataType') : null;
        semanticItem.decimalPlace = item.containsKey('decimalPlace') ? (Integer) item.get('decimalPlace') : null;
        semanticItem.aggregationType = item.containsKey('aggregationType') ? (String) item.get('aggregationType') : null;
        semanticItem.sentiment = item.containsKey('sentiment') ? (String) item.get('sentiment') : null;
        semanticItem.shouldTreatNullsAsZeros = item.containsKey('shouldTreatNullsAsZeros') ? (Boolean) item.get('shouldTreatNullsAsZeros') : false;
        semanticItem.filters = item.containsKey('filters') ? (List<Object>) item.get('filters') : new List<Object>();

        // Replace placeholders in the expression
        Object expressionObj = item.get('expression');
        if (expressionObj != null && expressionObj instanceof String) {
            semanticItem.expression = ((String) expressionObj).replace(templateSemanticDataObjectApiName, semanticDataObjectApiName);
        } else {
            semanticItem.expression = null;
        }

        return semanticItem;
    }

    /**
     * Processes the raw JSON response from the API into a structured map.
     *
     * @param rawResponse The raw JSON response from the API as a string.
     * @return A map representation of the parsed JSON response.
     * @throws IllegalArgumentException if the response format is unexpected or parsing fails.
     */
    private static Map<String, Object> processApiResponse(String rawResponse) {
        if (rawResponse.startsWith('{') || rawResponse.startsWith('[')) {
            try {
                // Deserialize the raw JSON string into a generic map.
                return (Map<String, Object>) JSON.deserializeUntyped(rawResponse);
            } catch (Exception e) {
                throw new IllegalArgumentException('Failed to parse JSON response: ' + e.getMessage());
            }
        } else if (rawResponse.startsWith('Failed') || rawResponse.startsWith('Error')) {
            // Handle responses indicating failure or errors.
            throw new IllegalArgumentException('Raw Error Response: ' + rawResponse);
        } else {
            // Handle unexpected response formats.
            throw new IllegalArgumentException('Unexpected response format: ' + rawResponse);
        }
    }

    /**
     * Creates an OutputWrapper object based on the processed response map, semantic items, and updated payload.
     *
     * @param updatedPayload The updated semantic model payload after processing.
     * @param semanticItems A list of semantic items (dimensions and measurements).
     * @param responseMap A structured map of the API response data.
     * @return An OutputWrapper containing the processed results for the semantic model.
     */
    private static OutputWrapper createOutputWrapper(String updatedPayload, List<SemanticItem> semanticItems, Map<String, Object> responseMap) {
        // Initialize the output wrapper with the updated payload and semantic items.
        OutputWrapper output = new OutputWrapper(updatedPayload, semanticItems);

        // Extract API name and URLs from the response map.
        output.apiName = (String) responseMap.get('apiName');

        // Return the populated OutputWrapper.
        return output;
    }

    /**
     * Extracts the semantic data object API name from the parsed payload based on the label.
     *
     * @param parsedPayload A structured map of the parsed payload.
     * @param dataObjectLabel The label of the semantic data object to find.
     * @return The API name of the semantic data object.
     * @throws IllegalArgumentException if no data object with the specified label is found.
     */
    private static String extractTemplateSemanticApiName(Map<String, Object> parsedPayload, String dataObjectLabel) {
        if (!parsedPayload.containsKey('semanticDataObjects')) {
            throw new IllegalArgumentException('No semanticDataObjects found in the payload.');
        }

        List<Object> semanticDataObjects = (List<Object>) parsedPayload.get('semanticDataObjects');
        for (Object obj : semanticDataObjects) {
            if (obj instanceof Map<String, Object>) {
                Map<String, Object> dataObject = (Map<String, Object>) obj;
                String label = (String) dataObject.get('label');
                String apiName = (String) dataObject.get('apiName');

                if (dataObjectLabel.equalsIgnoreCase(label != null ? label.trim() : null)) {
                    return '[' + apiName + '].';
                }
            }
        }

        throw new IllegalArgumentException('No semanticDataObject with label "' + dataObjectLabel + '" found.');
    }


    /**
     * Extracts calculated fields (measurements and dimensions) from a parsed payload and clears them
     * from the payload to ensure they are not included in subsequent processing.
     *
     * @param parsedPayload A map representing the parsed JSON payload of the semantic model.
     *                      This payload should contain `semanticCalculatedMeasurements` and 
     *                      `semanticCalculatedDimensions` keys.
     * @return A map containing two lists: 
     *         - `measurements`: The extracted calculated measurement objects.
     *         - `dimensions`: The extracted calculated dimension objects.
     * @throws IllegalArgumentException if the payload does not contain the required keys.
     */
    private static Map<String, List<Object>> extractAndClearCalculatedFields(Map<String, Object> parsedPayload) {
        Map<String, List<Object>> calculatedFields = new Map<String, List<Object>>();
        calculatedFields.put('measurements', (List<Object>) parsedPayload.get('semanticCalculatedMeasurements'));
        calculatedFields.put('dimensions', (List<Object>) parsedPayload.get('semanticCalculatedDimensions'));
    
        // Clear calculated fields in the payload
        parsedPayload.put('semanticCalculatedMeasurements', new List<Object>());
        parsedPayload.put('semanticCalculatedDimensions', new List<Object>());
    
        return calculatedFields;
    }

    /**
     * Extracts the API name of the semantic data object from the API response map.
     *
     * @param responseMap The API response map containing semantic data objects.
     * @param dataObjectLabel The label of the semantic data object to match.
     * @return The API name of the matched semantic data object.
     * @throws IllegalArgumentException if no matching data object is found.
     */
    private static String extractSemanticDataObjectApiName(Map<String, Object> responseMap, String dataObjectLabel) {
        if (responseMap.containsKey('semanticDataObjects')) {
            List<Object> semanticDataObjects = (List<Object>) responseMap.get('semanticDataObjects');
            for (Object obj : semanticDataObjects) {
                if (obj instanceof Map<String, Object>) {
                    Map<String, Object> dataObject = (Map<String, Object>) obj;
                    if (dataObjectLabel.equals(dataObject.get('label'))) {
                        return '[' + dataObject.get('apiName') + '].';
                    }
                }
            }
        }
        throw new IllegalArgumentException('No semantic data object with label "' + dataObjectLabel + '" found in the response.');
    }

    /**
     * Creates calculated fields (measurements or dimensions) for a semantic model via API calls.
     * Serializes the SemanticItem, invokes the API, and processes the response.
     * 
     * @param semanticItems A list of SemanticItem objects to be processed.
     * @param modelId The API name or ID of the semantic model.
     * @param fieldType The type of field being processed ('measurement' or 'dimension').
     * @return A list of maps containing the processed API responses.
     * @throws IllegalArgumentException if an API call fails or returns an unexpected response.
     */
    private static List<Map<String, Object>> createCalculatedFields(
        List<SemanticItem> semanticItems,
        String modelId,
        String fieldType
    ) {
        List<Map<String, Object>> responses = new List<Map<String, Object>>();

        for (SemanticItem semanticItem : semanticItems) {
            // Serialize the semantic item into JSON payload
            String payload = JSON.serialize(semanticItem);

            // Invoke the appropriate API based on the field type
            String rawResponse;
            if ('measurement'.equalsIgnoreCase(fieldType)) {
                rawResponse = invokeCreateCalculatedMeasurementApi(payload, modelId);
            } else if ('dimension'.equalsIgnoreCase(fieldType)) {
                rawResponse = invokeCreateCalculatedDimensionApi(payload, modelId);
            } else {
                throw new IllegalArgumentException('Invalid field type: ' + fieldType);
            }

            // Process the API response and add it to the responses list
            responses.add(processApiResponse(rawResponse));
        }

        return responses;
    }

}