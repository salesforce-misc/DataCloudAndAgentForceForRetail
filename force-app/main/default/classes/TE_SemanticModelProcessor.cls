/**
 * Class for processing semantic model JSON to extract specific fields and documentation.
 * Provides invocable methods for use in Salesforce flows or processes.
 *
 * Author: Antoine Laviron
 * Contact: alaviron@salesforce.com
 */
 public with sharing class TE_SemanticModelProcessor {
    /**
    * Wrapper class for input parameters required by the semantic model processor.
    */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String jsonInput; // JSON input representing the semantic model.

        @InvocableVariable
        public String fieldsComponents; // Comma-separated string of components to include in the fields node (e.g., "semanticDataObjects,semanticMeasurements").

        @InvocableVariable
        public String documentationComponents; // Comma-separated string of components to include in the documentation node (e.g., "semanticDimensions,semanticCalculatedDimensions").
    }


    /**
    * Wrapper class for the output of the semantic model processor.
    */
    public class OutputWrapper {
        @InvocableVariable
        public String jsonOutput; // JSON output containing fields and documentation.

        public OutputWrapper(String jsonOutput) {
            this.jsonOutput = jsonOutput;
        }
    }

    /**
     * Invocable method to process semantic model JSON for extracting fields and documentation.
     * 
     * @param inputs A list of InputWrapper objects containing the JSON input and processing parameters.
     * @return A list of OutputWrapper objects containing the processed JSON output or error messages.
     *
     */
    @InvocableMethod(label='Process Semantic Model' description='Processes semantic model JSON for fields and documentation.')
    public static List<OutputWrapper> processSemanticModel(List<InputWrapper> inputs) {
        List<OutputWrapper> outputList = new List<OutputWrapper>();

        for (InputWrapper input : inputs) {
            try {
                // Validate input
                validateInput(input);

                // Parse the input JSON
                Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(input.jsonInput);

                // Process components
                List<Map<String, Object>> fields = processFields(parsedJson, input.fieldsComponents);
                List<Map<String, Object>> documentation = processDocumentation(parsedJson, input.documentationComponents);

                // Construct final output JSON
                Map<String, Object> result = new Map<String, Object>{
                    'fields' => fields,
                    'documentation' => documentation
                };
 
                outputList.add(new OutputWrapper(JSON.serialize(result)));
            } catch (Exception e) {
                outputList.add(handleError(e));
            }
        }

        return outputList;
    }

    /**
     * Validates the input parameters.
     * 
     * @param input The InputWrapper object to validate.
     * @throws IllegalArgumentException If validation fails.
     */
    private static void validateInput(InputWrapper input) {
        if (String.isEmpty(input.jsonInput)) {
            throw new IllegalArgumentException('JSON input is empty.');
        }
    }
    
    /**
     * Processes the fields components from the semantic model JSON.
     * 
     * @param parsedJson The parsed semantic model JSON.
     * @param fieldsComponents A comma-separated string of fields components to process.
     * @return A list of processed fields.
     */
    private static List<Map<String, Object>> processFields(Map<String, Object> parsedJson, String fieldsComponents) {
        List<Map<String, Object>> fields = new List<Map<String, Object>>();
        if (String.isEmpty(fieldsComponents)) return fields;

        Set<String> componentsSet = new Set<String>(fieldsComponents.split(','));

        if (componentsSet.contains('semanticDataObjects') && parsedJson.containsKey('semanticDataObjects')) {
            List<Object> semanticDataObjects = (List<Object>) parsedJson.get('semanticDataObjects');
            for (Object obj : semanticDataObjects) {
                Map<String, Object> dataObject = (Map<String, Object>) obj;

                // Add dimensions
                fields.addAll(extractDimensions(dataObject, componentsSet));

                // Add measurements
                fields.addAll(extractMeasurements(dataObject, componentsSet));
            }
        }

        // Add calculated dimensions
        if (componentsSet.contains('semanticCalculatedDimensions')) {
            fields.addAll(extractCalculated(parsedJson, 'semanticCalculatedDimensions', 'Dimension'));
        }

        // Add calculated measurements
        if (componentsSet.contains('semanticCalculatedMeasurements')) {
            fields.addAll(extractCalculated(parsedJson, 'semanticCalculatedMeasurements', 'Measurement'));
        }

        return fields;
    } 

    /**
     * Processes the documentation components from the semantic model JSON.
     * 
     * @param parsedJson The parsed semantic model JSON.
     * @param documentationComponents A comma-separated string of documentation components to process.
     * @return A list of processed documentation.
     */
    private static List<Map<String, Object>> processDocumentation(Map<String, Object> parsedJson, String documentationComponents) {
        List<Map<String, Object>> documentation = new List<Map<String, Object>>();
        if (String.isEmpty(documentationComponents)) return documentation;

        Set<String> componentsSet = new Set<String>(documentationComponents.split(','));

        if (componentsSet.contains('semanticDataObjects') && parsedJson.containsKey('semanticDataObjects')) {
            List<Object> semanticDataObjects = (List<Object>) parsedJson.get('semanticDataObjects');
            for (Object obj : semanticDataObjects) {
                Map<String, Object> dataObject = (Map<String, Object>) obj;

                // Add dimensions
                documentation.addAll(extractDocumentationDetails(dataObject, 'semanticDimensions', 'Dimension'));

                // Add measurements
                documentation.addAll(extractDocumentationDetails(dataObject, 'semanticMeasurements', 'Measurement'));
            }
        }

        // Add calculated dimensions
        if (componentsSet.contains('semanticCalculatedDimensions')) {
            documentation.addAll(extractDocumentationCalculated(parsedJson, 'semanticCalculatedDimensions', 'Calculated Dimension'));
        }

        // Add calculated measurements
        if (componentsSet.contains('semanticCalculatedMeasurements')) {
            documentation.addAll(extractDocumentationCalculated(parsedJson, 'semanticCalculatedMeasurements', 'Calculated Measurement'));
        }

        return documentation;
    }

    /**
     * Extracts dimensions from a data object.
     * 
     * @param dataObject A map representing the semantic data object.
     * @param componentsSet A set of field components to include.
     * @return A list of maps representing the dimensions.
     */
    private static List<Map<String, Object>> extractDimensions(Map<String, Object> dataObject, Set<String> componentsSet) {
        List<Map<String, Object>> dimensions = new List<Map<String, Object>>();
        if (componentsSet.contains('semanticDimensions') && dataObject.containsKey('semanticDimensions')) {
            List<Object> semanticDimensions = (List<Object>) dataObject.get('semanticDimensions');
            for (Object dim : semanticDimensions) {
                Map<String, Object> dimension = (Map<String, Object>) dim;
                dimensions.add(new Map<String, Object>{
                    'fieldName' => dimension.get('dataObjectFieldName'),
                    'dataType' => dimension.get('dataType'),
                    'tableName' => dataObject.get('dataObjectName')
                });
            }
        }
        return dimensions;
    }

    /**
     * Extracts measurements from a data object.
     * 
     * @param dataObject A map representing the semantic data object.
     * @param componentsSet A set of field components to include.
     * @return A list of maps representing the measurements.
     */
    private static List<Map<String, Object>> extractMeasurements(Map<String, Object> dataObject, Set<String> componentsSet) {
        List<Map<String, Object>> measurements = new List<Map<String, Object>>();
        if (componentsSet.contains('semanticMeasurements') && dataObject.containsKey('semanticMeasurements')) {
            List<Object> semanticMeasurements = (List<Object>) dataObject.get('semanticMeasurements');
            for (Object meas : semanticMeasurements) {
                Map<String, Object> measurement = (Map<String, Object>) meas;
                measurements.add(new Map<String, Object>{
                    'fieldName' => measurement.get('dataObjectFieldName'),
                    'dataType' => measurement.get('dataType'),
                    'tableName' => dataObject.get('dataObjectName')
                });
            }
        }
        return measurements;
    }

    /**
     * Extracts calculated fields from the parsed JSON.
     * 
     * @param parsedJson The parsed semantic model JSON.
     * @param key The key to locate calculated fields in the JSON (e.g., 'semanticCalculatedDimensions').
     * @param role The role associated with the fields (e.g., 'Dimension', 'Measurement').
     * @return A list of maps representing the calculated fields, including role, API name,
     *         aggregation type, and display category.
     */
    private static List<Map<String, Object>> extractCalculated(Map<String, Object> parsedJson, String key, String role) {
        List<Map<String, Object>> calculated = new List<Map<String, Object>>();
        if (parsedJson.containsKey(key)) {
            List<Object> calculatedFields = (List<Object>) parsedJson.get(key);
            for (Object field : calculatedFields) {
                Map<String, Object> calcField = (Map<String, Object>) field;
                calculated.add(new Map<String, Object>{
                    'role' => role,
                    'apiName' => calcField.get('apiName'),
                    'aggregationType' => calcField.get('aggregationType'),
                    'displayCategory' => calcField.get('displayCategory')
                });
            }
        }
        return calculated;
    }

    /**
     * Extracts documentation details from a data object.
     * 
     * @param dataObject The semantic data object containing the key to be processed.
     * @param key The key to locate the documentation fields (e.g., 'semanticDimensions').
     * @param type The type of field being processed (e.g., 'Dimension', 'Measurement').
     * @return A list of maps representing the documentation details, including type,
     *         field name, data type, and table name.
     */
    private static List<Map<String, Object>> extractDocumentationDetails(Map<String, Object> dataObject, String key, String type) {
        List<Map<String, Object>> documentationDetails = new List<Map<String, Object>>();
        if (dataObject.containsKey(key)) {
            List<Object> elements = (List<Object>) dataObject.get(key);
            for (Object element : elements) {
                Map<String, Object> docDetail = (Map<String, Object>) element;
                documentationDetails.add(new Map<String, Object>{
                    'type' => type,
                    'fieldName' => docDetail.get('dataObjectFieldName'),
                    'dataType' => docDetail.get('dataType'),
                    'tableName' => dataObject.get('dataObjectName')
                });
            }
        }
        return documentationDetails;
    }

    /**
     * Extracts calculated fields for documentation.
     * 
     * @param parsedJson The parsed semantic model JSON.
     * @param key The key to locate calculated fields for documentation (e.g., 'semanticCalculatedDimensions').
     * @param type The type of field being processed (e.g., 'Calculated Dimension', 'Calculated Measurement').
     * @return A list of maps representing the documentation details for calculated fields.
     */
    private static List<Map<String, Object>> extractDocumentationCalculated(Map<String, Object> parsedJson, String key, String type) {
        List<Map<String, Object>> documentationCalculated = new List<Map<String, Object>>();
        if (parsedJson.containsKey(key)) {
            List<Object> elements = (List<Object>) parsedJson.get(key);
            for (Object element : elements) {
                Map<String, Object> calcField = (Map<String, Object>) element;
                documentationCalculated.add(new Map<String, Object>{
                    'type' => type,
                    'apiName' => calcField.get('apiName'),
                    'expression' => calcField.get('expression'),
                    'label' => calcField.get('label')
                });
            }
        }
        return documentationCalculated;
    }


    /**
     * Handles errors and creates an error response.
     * 
     * @param e The exception to be processed.
     * @return An OutputWrapper containing the error details in JSON format.
     */
    private static OutputWrapper handleError(Exception e) {
        String errorJson = JSON.serialize(new Map<String, String>{
            'error' => e.getMessage()
        });
        return new OutputWrapper(errorJson);
    }
}