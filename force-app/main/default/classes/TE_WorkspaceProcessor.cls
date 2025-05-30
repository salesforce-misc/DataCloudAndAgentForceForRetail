/**
 * Class to process workspace JSON input and extract key details like description, ID, name, and label.
 * This utility is particularly useful for Salesforce flows or processes requiring formatted workspace details.
 *
 * Author: Antoine Laviron
 * Contact: alaviron@salesforce.com
 */
 public with sharing class TE_WorkspaceProcessor {
    /**
     * Wrapper class for the input parameters.
     * Represents the JSON input to be processed.
     */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String jsonInput; // JSON input representing the semantic model.

    }

    /**
     * Wrapper class for the output results.
     * Contains the processed JSON output with workspace details.
     */
    public class OutputWrapper {
        @InvocableVariable
        public String jsonOutput; // JSON string containing details of Workspace.

        // Constructor for OutputWrapper
        public OutputWrapper(String jsonOutput) {
            this.jsonOutput = jsonOutput;
        }
    }

    /**
     * Invocable method to process Workspacel JSON and extract id, label, name.
     * 
     * @param inputs List of InputWrapper objects containing the JSON input.
     * @return A list of OutputWrapper objects with processed JSON Workspace details.
     *
     */
    @InvocableMethod(label='Process Workspace' description='Processes the workspace JSON and returns the JSON details needed to create a visualization.')
    public static List<OutputWrapper> processWorkspace(List<InputWrapper> inputs) {
        List<OutputWrapper> outputList = new List<OutputWrapper>();

        for (InputWrapper input : inputs) {
            try {
                // Validate input
                validateInput(input);

                // Parse and process the workspace JSON
                String processedJson = extractWorkspaceDetails(input.jsonInput);

                // Add successful output to the list
                outputList.add(new OutputWrapper(processedJson));
            } catch (Exception e) {
                outputList.add(createErrorResponse(e));
            }
        }
        
        return outputList;
    }
    
    /**
     * Validates the input JSON string.
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
     * Extracts workspace details (description, ID, label, name) from the JSON string.
     * 
     * @param jsonInput The JSON input string.
     * @return A JSON string containing extracted workspace details.
     * @throws IllegalArgumentException If required fields are missing or malformed.
     */
    private static String extractWorkspaceDetails(String jsonInput) {
        // Parse the input JSON into a map
        Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);

        // Validate and extract required fields
        List<Map<String, String>> workspaceDetailsList = new List<Map<String, String>>();
        workspaceDetailsList.add(new Map<String, String>{
            'description' => extractField(parsedJson, 'description'),
            'id' => extractField(parsedJson, 'id'),
            'label' => extractField(parsedJson, 'label'),
            'name' => extractField(parsedJson, 'name')
        });

        // Serialize and return the processed details
        return JSON.serialize(workspaceDetailsList);
    }

    /**
     * Extracts a specific field from the parsed JSON map and validates its presence.
     * 
     * @param parsedJson The parsed JSON map.
     * @param fieldName The name of the field to extract.
     * @return The extracted field value.
     * @throws IllegalArgumentException If the field is missing or empty.
     */
    private static String extractField(Map<String, Object> parsedJson, String fieldName) {
        if (!parsedJson.containsKey(fieldName) || String.isEmpty((String) parsedJson.get(fieldName))) {
            throw new IllegalArgumentException('Missing or empty field: ' + fieldName);
        }
        return (String) parsedJson.get(fieldName);
    }

    /**
     * Creates an error response wrapper with the exception details.
     * 
     * @param e The exception to handle.
     * @return An OutputWrapper containing the error details.
     */
    private static OutputWrapper createErrorResponse(Exception e) {
        String errorJson = JSON.serialize(new Map<String, String>{
            'error' => e.getMessage()
        });
        return new OutputWrapper(errorJson);
    }
}