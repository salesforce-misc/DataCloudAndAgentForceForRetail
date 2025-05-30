/**
 * Utility class for creating Tableau Workspace.
 * 
 * This class creates a Tableau Workspace.
 *
 * Author: Antoine Laviron 
 * Contact: alaviron@salesforce.com
 */

public with sharing class TE_CreateWorkspace {
    
    /**
     * Wrapper class for the output results.
     * 
     * Encapsulates the JSON output of the Workspace creation process.
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
     * Wrapper class for the input parameter required to create a Tableau Workspace.
     * 
     * Encapsulates necessary data for generating a Tableau Workspace.
     */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String workspaceName; // Name of the workspace.

        @InvocableVariable(required=false)
        public String workspaceDescription; // Description of the workspace.
    }
    
    /**
     * Creates a Tableau workspace based on input parameters.
     * 
     * This method constructs an API payload to create a Tableau Workspace. 
     * It sends the payload to the `createWorkspace` API endpoint and returns the result.
     * 
     * @param inputs List of InputWrapper objects containing required parameters.
     * @return List of OutputWrapper objects containing JSON output.
     * 
     * @example
     * InputWrapper input = new InputWrapper();
     * input.workspaceName = 'workspace_name';
     * List<OutputWrapper> results = TE_CreateWorkspace.createTableauWorkspace(new List<InputWrapper>{input});
     */
    @InvocableMethod(label='Create a Tableau Workspace' description='Create a Tableau Workspace from the input and returns the result')
    public static List<OutputWrapper> createTableauWorkspace(List<InputWrapper> inputs) {
        List<OutputWrapper> outputList = new List<OutputWrapper>();
    
        for (InputWrapper input : inputs) {
            OutputWrapper output = new OutputWrapper();
            try {
                validateInput(input);

                // Construct the payload
                Map<String, Object> payload = constructPayload(input);

                List<TE_GenericInvoker.RequestWrapper> requests = new List<TE_GenericInvoker.RequestWrapper>();
                TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
                request.endpointName = 'createWorkspace';
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
        if (String.isBlank(input.workspaceName)) {
            throw new IllegalArgumentException('Workspace API Name is required.');
        }
    }

    /**
     * Constructs the API payload for the workspace creation.
     * 
     * @param workspaceName The Name of the workspace
     * @return A Map representing the API payload.
     */
    private static Map<String, Object> constructPayload(InputWrapper input) {
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('description',input.workspaceDescription);
        payloadMap.put('label', input.workspaceName);

        return payloadMap;
    }

    /**
     * Parses the API response from the workspace creation request.
     * 
     * Extracts the relevant result (e.g., workspace API name) from the response.
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
    
            // Extract the 'name' field for workspace
            if (responseMap.containsKey('name')) {
                return (String) responseMap.get('name'); // Return the name for further processing
            } else {
                throw new IllegalArgumentException('Expected key "name" not found in the response: ' + rawResponse);
            }
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to parse API response: ' + rawResponse + '. Error: ' + e.getMessage());
        }
    }
}