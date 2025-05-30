/**
 * Utility class for creating Tableau Visualizations.
 * To rework entirely when we'll havet the template for line chart,
 * to handle multiple Tableau Viz templates.
 * 
 * This class processes semantic metadata, workspace details, and visualization specifications 
 * to generate a Tableau visualization. It handles payload construction and API invocation.
 *
 * Author: Kunal Tomar
 * Contact: Kunal.tomar@salesforce.com
 */
public with sharing class TE_CreateVisualization {

    /**
     * Wrapper class for the output results.
     * 
     * Encapsulates the JSON output of the visualization creation process.
     */
    public class OutputWrapper {
        @InvocableVariable
        public String jsonOutput; 

        // Constructor for OutputWrapper
        public OutputWrapper() {
            this.jsonOutput = jsonOutput;
        }
    }

    /**
     * Wrapper class for the input parameters required to create a visualization.
     * 
     * Encapsulates necessary data for generating a Tableau visualization, including
     * semantic metadata, workspace API name, field payloads, and view specifications.
     */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String semanticMetadata; // Raw JSON of the Semantic Data Model.


        @InvocableVariable(required=true)
        public String workspaceApiName; // API Name of the workspace to create the visualization.

        @InvocableVariable(required=true)
        public String fieldsPayload; // JSON payload specifying fields for the visualization.

        @InvocableVariable
        public String visualSpecificationPayload; // JSON defining visualization specifications.

        @InvocableVariable
        public String viewPayload; // JSON defining the view configuration.


        /**
         * Default Constructor for InputWrapper.
         * 
         * Initializes default values for viewPayload and visualSpecificationPayload.
         */
        public InputWrapper() {
                               
            
            this.viewPayload = '{"name":"default","label":"default","viewSpecification":{"filters":[],"sorts":[{"fieldKey":"F1","type":"Nested","order":"Descending","byField":"F5"}]}}';
            this.visualSpecificationPayload = '{"rows":["F1"],"columns":["F2"],"marks":{"ALL":{"isAutomatic":true,"type":"Bar","stack":{"isAutomatic":true,"isStacked":true},"encodings":[{"fieldKey":"F3","type":"Color"},{"fieldKey":"F4","type":"Label"}]}},"style":{"referenceLines":{},"fit":"Standard","title":{"isVisible":true},"showDataPlaceholder":true,"marks":{"ALL":{"label":{"canOverlapLabels":false,"marksToLabel":{"type":"All"},"showMarkLabels":true},"color":{"color":""}}},"headers":{"F1":{"isVisible":true,"showMissingValues":false,"hiddenValues":[]}},"axis":{"F2":{"isVisible":true,"range":{"type":"Auto","includeZero":true},"scale":{"format":{"numberFormatInfo":{"type":"NumberShort","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}},"titleText":"PLACEHOLDER_MEASURE_1","ticks":{"majorTicks":{"type":"Auto"},"minorTicks":{"type":"Auto"}}}},"panes":{"F2":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F3":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F4":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}}},"fieldLabels":{"rows":{"showLabels":true},"columns":{"showLabels":true}}},"legends":{"F6":{"isVisible":false,"title":{"titleText":"To fix","isVisible":false},"position":"Right"}},"measureValues":[],"referenceLines":{},"forecasts":{}}';
            
            //this.visualSpecificationPayload = '{"rows":["F1"],"columns":["F2"],"marks":{"ALL":{"isAutomatic":true,"type":"Bar","stack":{"isAutomatic":true,"isStacked":true},"encodings":[{"fieldKey":"F3","type":"Color"},{"fieldKey":"F4","type":"Label"}]}},"style":{"referenceLines":{},"fit":"Standard","title":{"isVisible":true},"showDataPlaceholder":true,"marks":{"ALL":{"label":{"canOverlapLabels":false,"marksToLabel":{"type":"All"},"showMarkLabels":true},"color":{"color":""}}},"headers":{"F1":{"isVisible":true,"showMissingValues":false,"hiddenValues":[]}},"axis":{"F2":{"isVisible":true,"range":{"type":"Auto","includeZero":true},"scale":{"format":{"numberFormatInfo":{"type":"NumberShort","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}},"titleText":"PLACEHOLDER_MEASURE_1","ticks":{"majorTicks":{"type":"Auto"},"minorTicks":{"type":"Auto"}}}},"panes":{"F2":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F3":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F4":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}}},"fieldLabels":{"rows":{"showLabels":true},"columns":{"showLabels":true}}},"legends":{"F6":{"isVisible":false,"title":{"titleText":"To fix","isVisible":false},"position":"Right"}},"measureValues":[],"referenceLines":{},"forecasts":{}}';
        //    this.visualSpecificationPayload = '{"rows":["F1"],"columns":["F2"],"marks":{"ALL":{"isAutomatic":true,"type":"Bar","stack":{"isAutomatic":true,"isStacked":true},"encodings":[{"fieldKey":"F3","type":"Color"},{"fieldKey":"F4","type":"Label"}]}},"style":{"referenceLines":{},"fit":"Standard","title":{"isVisible":true},"showDataPlaceholder":true,"marks":{"ALL":{"label":{"canOverlapLabels":false,"marksToLabel":{"type":"All"},"showMarkLabels":true},"color":{"color":""}}},"headers":{"F1":{"isVisible":true,"showMissingValues":false,"hiddenValues":[]}},"axis":{"F2":{"isVisible":true,"range":{"type":"Auto","includeZero":true},"scale":{"format":{"numberFormatInfo":{"type":"NumberShort","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}},"titleText":"PLACEHOLDER_MEASURE_1","ticks":{"majorTicks":{"type":"Auto"},"minorTicks":{"type":"Auto"}}}},"panes":{"F2":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F3":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F4":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}}},"fieldLabels":{"rows":{"showLabels":true},"columns":{"showLabels":true}}},"legends":{"F6":{"isVisible":false,"title":{"titleText":"To fix","isVisible":false},"position":"Right"}},"measureValues":[],"referenceLines":{},"forecasts":{}}';
            // 252 payload: '{"name":"default","label":"default","viewSpecification":{"filters":[],"sorts":[{"fieldKey":"F1","type":"Nested","order":"Descending","byField":"F5"}]}}';
           // this.visualSpecificationPayload = '{"rows":["F1"],"columns":["F2"],"marks":{"ALL":{"isAutomatic":true,"type":"Bar","stack":{"isAutomatic":true,"isStacked":true},"encodings":[{"fieldKey":"F3","type":"Color"},{"fieldKey":"F4","type":"Label"}]}},"style":{"referenceLines":{},"fit":"Standard","title":{"isVisible":true},"showDataPlaceholder":true,"marks":{"ALL":{"label":{"canOverlapLabels":false,"marksToLabel":{"type":"All"},"showMarkLabels":true},"color":{"color":""}}},"headers":{"F1":{"isVisible":true,"showMissingValues":false,"hiddenValues":[]}},"axis":{"F2":{"isVisible":true,"range":{"type":"Auto","includeZero":true},"scale":{"format":{"numberFormatInfo":{"type":"NumberShort","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}},"titleText":"PLACEHOLDER_MEASURE_1","ticks":{"majorTicks":{"type":"Auto"},"minorTicks":{"type":"Auto"}}}},"panes":{"F2":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F3":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F4":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}}},"fieldLabels":{"rows":{"showLabels":true},"columns":{"showLabels":true}}},"legends":{"F6":{"isVisible":false,"title":{"titleText":"To fix","isVisible":false},"position":"Right"}},"measureValues":[],"referenceLines":{}}';
            // 252 payload: '{"rows":["F1"],"columns":["F2"],"marks":{"ALL":{"isAutomatic":true,"type":"Bar","stack":{"isAutomatic":true,"isStacked":true},"encodings":[{"fieldKey":"F3","type":"Color"},{"fieldKey":"F4","type":"Label"}]}},"style":{"fit":"Standard","title":{"isVisible":true},"showDataPlaceholder":true,"marks":{"ALL":{"label":{"canOverlapLabels":false,"showMarkLabels":true}}},"headers":{"F1":{"isVisible":true}},"axis":{"F2":{"isVisible":true,"range":{"type":"Auto","includeZero":true},"scale":{"format":{"numberFormatInfo":{"type":"NumberShort","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}},"titleText":"PLACEHOLDER_MEASURE_1"}},"panes":{"F2":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F3":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}},"F4":{"defaults":{"format":{"numberFormatInfo":{"type":"Number","decimalPlaces":2,"prefix":"","suffix":"","negativeValuesFormat":"Auto","includeThousandSeparator":true,"displayUnits":"Auto"}}}}},"fieldLabels":{"rows":{"showLabels":true},"columns":{"showLabels":true}}}}';
        }
    }

    /**
     * Creates a Tableau visualization based on input parameters.
     * 
     * This method processes semantic metadata, field payloads, and workspace information 
     * to construct an API payload for Tableau. It sends the payload to the `createVisualization` 
     * API endpoint and returns the result.
     * 
     * @param inputs List of InputWrapper objects containing required parameters.
     * @return List of OutputWrapper objects containing JSON output.
     * 
     * @example
     * InputWrapper input = new InputWrapper();
     * input.semanticMetadata = '{ "key": "value" }';
     * input.workspaceApiName = 'workspace_name';
     * List<OutputWrapper> results = TE_CreateVisualization.createTableauVisualization(new List<InputWrapper>{input});
     */
    @InvocableMethod(label='Create a Tableau Visualization' description='Create a Tableau Visualization from the input and returns the link of the visualization')
    public static List<OutputWrapper> createTableauVisualization(List<InputWrapper> inputs) {
        List<OutputWrapper> outputList = new List<OutputWrapper>();
    
        for (InputWrapper input : inputs) {
            OutputWrapper output = new OutputWrapper();
            try {
                validateInput(input);

                Map<String, Object> workspaceStructured = fetchAndProcessWorkspace(input.workspaceApiName);
                Map<String, Object> dataSource = buildDataSource(input.semanticMetadata);
                Map<String, Object> visualSpecification =buildVisualSpecification(
                                                            input.visualSpecificationPayload, 
                                                            input.fieldsPayload, 
                                                            input.semanticMetadata);
                Map<String, Object> fields = buildFields(input.fieldsPayload);
                Map<String, Object> view = buildView(input.viewPayload);
                


    
                Map<String, Object> payload = constructPayload(workspaceStructured, dataSource, visualSpecification, fields, view);

                List<TE_GenericInvoker.RequestWrapper> requests = new List<TE_GenericInvoker.RequestWrapper>();
                TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
                request.endpointName = 'createVisualization';
                request.method = 'POST';
                request.payload = JSON.serialize(payload);


                requests.add(request);

                List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(requests);
                output.jsonOutput = parseResponse(responses);
                
            } catch (Exception e) {
                output.jsonOutput = 'Error: ' + e.getMessage();
            }
            outputList.add(output);
        }
    
        return outputList;
    }

    /**
     * Validates input parameters.
     * 
     * Ensures all required fields are provided and valid before proceeding.
     * 
     * @param input The InputWrapper object to validate.
     * @throws IllegalArgumentException if required fields are missing or invalid.
     */
    private static void validateInput(InputWrapper input) {
        if (String.isBlank(input.workspaceApiName) || String.isBlank(input.semanticMetadata)) {
            throw new IllegalArgumentException('Workspace API Name and Semantic Metadata are required.');
        }
        if (String.isBlank(input.fieldsPayload)) {
            throw new IllegalArgumentException('Fields payload is required.');
        }
    }
    
    /**
     * Fetches and processes workspace metadata.
     * 
     * Retrieves the workspace details using the provided workspace API name.
     * 
     * @param workspaceApiName The API name of the workspace to fetch.
     * @return A Map containing the processed workspace metadata.
     * @throws IllegalArgumentException if the workspace fetch or processing fails.
     */
    private static Map<String, Object> fetchAndProcessWorkspace(String workspaceApiName) {
        // Prepare request
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'getWorkspace';
        request.workspaceApiName = workspaceApiName;
        request.method = 'GET';
        // request.useCache = true;
    
        List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(new List<TE_GenericInvoker.RequestWrapper>{request});
    
        // Validate response
        if (responses.isEmpty() || (responses[0].status != 'Success' && responses[0].status != 'Success (From Cache)')) {
            throw new IllegalArgumentException('Failed to fetch workspace: ' + (responses.isEmpty() ? 'No response.' : responses[0].resultText));
        }
    
        String workspaceRawResponse = responses[0].resultText;
    
        // Process workspace response
        TE_WorkspaceProcessor.InputWrapper processorInput = new TE_WorkspaceProcessor.InputWrapper();
        processorInput.jsonInput = workspaceRawResponse;
    
        List<TE_WorkspaceProcessor.OutputWrapper> processorOutputs = TE_WorkspaceProcessor.processWorkspace(new List<TE_WorkspaceProcessor.InputWrapper>{processorInput});
        if (processorOutputs.isEmpty()) {
            throw new IllegalArgumentException('Failed to process workspace: No output from processor.');
        }
    
        // Deserialize and normalize the workspace to return a single object
        Object workspaceObject = JSON.deserializeUntyped(processorOutputs[0].jsonOutput);
    
        if (workspaceObject instanceof List<Object>) {
            List<Object> workspaceList = (List<Object>) workspaceObject;
            if (!workspaceList.isEmpty()) {
                return (Map<String, Object>) workspaceList[0]; // Return the first element
            } else {
                throw new IllegalArgumentException('Workspace is empty in the response.');
            }
        } else if (workspaceObject instanceof Map<String, Object>) {
            return (Map<String, Object>) workspaceObject; // Return as is
        } else {
            throw new IllegalArgumentException('Invalid workspace structure in the response.');
        }
    }
    
    /**
     * Constructs the data source object.
     * 
     * Parses the semantic metadata to create a data source map for the visualization.
     * 
     * @param semanticMetadata The semantic metadata in JSON format.
     * @return A Map representing the data source.
     * @throws IllegalArgumentException if the semantic metadata is invalid.
     */
    private static Map<String, Object> buildDataSource(String semanticMetadata) {
        Map<String, Object> semanticModelMap;
        try {
            semanticModelMap = (Map<String, Object>) JSON.deserializeUntyped(semanticMetadata);
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to parse Semantic Metadata JSON: ' + semanticMetadata + '. Error: ' + e.getMessage());
        }
    
        // Ensure required keys exist
        if (!semanticModelMap.containsKey('id') || !semanticModelMap.containsKey('label') || !semanticModelMap.containsKey('apiName')) {
            throw new IllegalArgumentException('Semantic Metadata is missing required fields: id, apiName (for name), or label.');
        }
    
        // Build the dataSource map
        Map<String, Object> dataSourceMap = new Map<String, Object>();
        dataSourceMap.put('type', 'SemanticModel');
        dataSourceMap.put('id', semanticModelMap.get('id'));
        dataSourceMap.put('name', semanticModelMap.get('apiName')); // Use `apiName` for `name`
        dataSourceMap.put('label', semanticModelMap.get('label'));
        
        return dataSourceMap;
    }
    
    /**
     * Parses the fields payload into a Map representation.
     * 
     * This method deserializes the JSON payload for fields into a Map, allowing 
     * for easy access and manipulation of field data.
     * 
     * @param fieldsPayload The JSON payload specifying fields for the visualization.
     * @return A Map<String, Object> representing the fields data.
     */
    private static Map<String, Object> buildFields(String fieldsPayload) {
        return (Map<String, Object>) JSON.deserializeUntyped(fieldsPayload);
    }


    /**
     * Parses the view payload into a Map representation.
     * 
     * This method deserializes the JSON payload for the view into a Map. If no 
     * payload is provided, a default view configuration is used.
     * 
     * @param viewPayload The JSON payload specifying the view configuration.
     *                    If null or blank, a default payload is used.
     * @return A Map<String, Object> representing the view configuration.
     */
    private static Map<String, Object> buildView(String viewPayload) {
        String payload = String.isNotBlank(viewPayload) ? viewPayload : '{"name":"default","label":"default","viewSpecification":{"filters":[],"sorts":[{"fieldKey":"F1","type":"Nested","order":"Descending","byField":"F5"}]}}';
        return (Map<String, Object>) JSON.deserializeUntyped(payload);
    }

    /**
     * Constructs the API payload for the visualization request.
     * 
     * Combines workspace, data source, visualization specifications, fields, and view
     * into a single payload.
     * 
     * @param workspaceStructured The processed workspace metadata.
     * @param dataSource The data source map.
     * @param visualSpecification The visualization specification map.
     * @param fields The fields map.
     * @param view The view map.
     * @return A Map representing the API payload.
     */
    private static Map<String, Object> constructPayload( Map<String, Object> workspaceStructured, Map<String, Object> dataSource, Map<String, Object> visualSpecification, Map<String, Object> fields, Map<String, Object> view) {
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('interactions', new List<Object>());
        payloadMap.put('view', view);
        payloadMap.put('fields', fields);
        payloadMap.put('visualSpecification', visualSpecification);
        payloadMap.put('workspace', workspaceStructured); 
        payloadMap.put('dataSource', dataSource);
        payloadMap.put('name', '');

        DateTime now = DateTime.now();
        String formattedDate = now.format('MM/dd/yyyy');
        String formattedTime = now.format('hh:mm:ss a');
        payloadMap.put('label', 'From Agent Conversation ' + formattedDate + ' ' + formattedTime);

        payloadMap.put('id', '');
        return payloadMap;
    }

    /**
     * Parses the API response from the visualization creation request.
     * 
     * Extracts the relevant result (e.g., visualization name) from the response.
     * 
     * @param responses List of ResponseWrapper objects from the API call.
     * @return A String containing the parsed response.
     * @throws IllegalArgumentException if the response is invalid or contains errors.
     */
    private static String parseResponse(List<TE_GenericInvoker.ResponseWrapper> responses) {
        if (responses.isEmpty()) {
            throw new IllegalArgumentException('No response received from the API.');
        }
    
        String rawResponse = responses[0].resultText;
    
        if (String.isBlank(rawResponse)) {
            throw new IllegalArgumentException('Received an empty response from the API.');
        }
    
        try {
            // Parse the JSON response
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(rawResponse);
    
            // Check for errors in the response
            if (responseMap.containsKey('error')) {
                throw new IllegalArgumentException('Error in API response: ' + String.valueOf(responseMap.get('error')));
            }
    
            // Extract the 'name' field for visualization
            if (responseMap.containsKey('name')) {
                return (String) responseMap.get('name'); // Return the name for further processing
            } else {
                throw new IllegalArgumentException('Expected key "name" not found in the response: ' + rawResponse);
            }
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to parse API response: ' + rawResponse + '. Error: ' + e.getMessage());
        }
    }

    /**
     * Constructs the visualization specification.
     * 
     * Builds the visualization specification map, replacing placeholders with actual values.
     * 
     * @param visualSpecificationPayload The JSON payload for visualization specifications.
     * @param fieldsPayload The JSON payload for fields.
     * @param semanticMetadata The semantic metadata in JSON format.
     * @return A Map representing the visualization specification.
     */
    private static Map<String, Object> buildVisualSpecification(String visualSpecificationPayload, String fieldsPayload, String semanticMetadata) {
        // Parse the input payloads
        Map<String, Object> visualSpec = (Map<String, Object>) JSON.deserializeUntyped(visualSpecificationPayload);
        Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(fieldsPayload);
        Map<String, Object> semanticModel = (Map<String, Object>) JSON.deserializeUntyped(semanticMetadata);

        // Extract the apiName for F2
        Map<String, Object> fieldF2 = (Map<String, Object>) fields.get('F2');
        String apiNameF2 = (String) fieldF2.get('fieldName');

        // Find the matching label in semantic metadata
        String labelF2 = null;
        List<Object> calculatedMeasurements = (List<Object>) semanticModel.get('semanticCalculatedMeasurements');
        for (Object measurementObj : calculatedMeasurements) {
            Map<String, Object> measurement = (Map<String, Object>) measurementObj;
            if (apiNameF2.equalsIgnoreCase((String) measurement.get('apiName'))) {
                labelF2 = (String) measurement.get('label');
                break;
            }
        }

        // If not found in measurements, search in calculated dimensions
        if (labelF2 == null) {
            List<Object> calculatedDimensions = (List<Object>) semanticModel.get('semanticCalculatedDimensions');
            for (Object dimensionObj : calculatedDimensions) {
                Map<String, Object> dimension = (Map<String, Object>) dimensionObj;
                if (apiNameF2.equalsIgnoreCase((String) dimension.get('apiName'))) {
                    labelF2 = (String) dimension.get('label');
                    break;
                }
            }
        }

        // Replace the placeholder in the visual specification
        if (labelF2 != null) {
            Map<String, Object> axisF2 = (Map<String, Object>) ((Map<String, Object>) visualSpec.get('style')).get('axis');
            Map<String, Object> axisF2Details = (Map<String, Object>) axisF2.get('F2');
            String titleText = (String) axisF2Details.get('titleText');
            axisF2Details.put('titleText', titleText.replace('PLACEHOLDER_MEASURE_1', labelF2));
        } else {
            throw new IllegalArgumentException('Label not found for apiName: ' + apiNameF2);
        }

        return visualSpec;
    }

}