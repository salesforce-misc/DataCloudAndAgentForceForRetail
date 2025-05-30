/**
 * Class for executing semantic queries and formatting their results.
 * 
 * This class utilizes the TE_GenericInvoker to interact with the Semantic Layer API.
 * It accepts structured query and semantic container payloads, executes the query,
 * and processes the results into a simplified JSON format.
 *
 * Author: Kunal Tomar
 * Contact: Kunal.tomar@salesforce.com
 */
public with sharing class TE_ExecuteSemanticQuery {

    /**
     * Input wrapper for the invocable method.
     * Contains parameters required for executing the semantic query.
     */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String structuredSemanticQueryPayload; // JSON string for the structured semantic query.

        @InvocableVariable(required=true)
        public String semanticContainerPayload; // JSON string for the semantic container definition.

        @InvocableVariable(required=false)
        public String dataspace = 'default'; // Optional, defaults to 'default'.

    }

    /**
     * Output wrapper for the invocable method.
     * Contains the formatted query results.
     */
    public class OutputWrapper {
        @InvocableVariable
        public String formattedResults; // Simplified JSON string containing query results.
    }

    /**
     * Invocable method to execute a semantic query and format the results.
     * 
     * @param inputs List of InputWrapper objects containing the query and container payloads.
     * @return A list of OutputWrapper objects with the formatted results or error messages.
     * 
     */
    @InvocableMethod(label='Execute Semantic Query and Format Results' description='Executes a semantic query and returns formatted queryResults.')
    public static List<OutputWrapper> executeSemanticQuery(List<InputWrapper> inputs) {
        List<OutputWrapper> outputList = new List<OutputWrapper>();

        for (InputWrapper input : inputs) {
            OutputWrapper output = new OutputWrapper();
            try {
                // Validate inputs
                validateInputs(input);

                // Construct the JSON payload
                String jsonPayload = constructPayload(input);

                // Create the invoker request
                TE_GenericInvoker.RequestWrapper request = createInvokerRequest(jsonPayload);

                // Call the invoker
                List<TE_GenericInvoker.ResponseWrapper> responses = TE_GenericInvoker.invokeApi(new List<TE_GenericInvoker.RequestWrapper>{request});

                // Process the response
                output.formattedResults = processResponse(responses);
            } catch (Exception e) {
                // Handle errors by returning an error message in the output
                output.formattedResults = 'Error: ' + e.getMessage();
            }
            // Add the output to the list
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
    private static void validateInputs(InputWrapper input) {
        if (String.isBlank(input.structuredSemanticQueryPayload)) {
            throw new IllegalArgumentException('Query payload is empty.');
        }
        if (String.isBlank(input.semanticContainerPayload)) {
            throw new IllegalArgumentException('Semantic model is empty.');
        }
    }

    /**
     * Constructs the API payload for the semantic query execution.
     * 
     * @param input The InputWrapper object containing query parameters.
     * @return A JSON string representing the API payload.
     */
    private static String constructPayload(InputWrapper input) {
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('structuredSemanticQuery', JSON.deserializeUntyped(input.structuredSemanticQueryPayload));
        payloadMap.put('semanticContainer', JSON.deserializeUntyped(input.semanticContainerPayload));
        payloadMap.put('dataspace', String.isEmpty(input.dataspace) ? 'default' : input.dataspace);
        payloadMap.put('source', 'agent'); 
        return JSON.serialize(payloadMap);
    }

    /**
     * Creates a request wrapper for invoking the semantic query.
     * 
     * @param jsonPayload The JSON payload for the query.
     * @return A configured RequestWrapper object for the API call.
     */
    private static TE_GenericInvoker.RequestWrapper createInvokerRequest(String jsonPayload) {
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'executeSemanticQuery';
        request.method = 'POST';
        request.payload = jsonPayload;
        return request;
    }

    /**
     * Processes the API response and extracts formatted query results.
     * 
     * @param responses List of ResponseWrapper objects from the API call.
     * @return A string containing the formatted query results.
     * @throws IllegalArgumentException if the response is invalid or contains errors.
     */
    private static String processResponse(List<TE_GenericInvoker.ResponseWrapper> responses) {
        if (responses.isEmpty()) {
            throw new IllegalArgumentException('No response received from the API.');
        }

        String rawResponse = responses[0].resultText;
        if (String.isBlank(rawResponse)) {
            throw new IllegalArgumentException('Received an empty response from the API.');
        }

        try {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(rawResponse);

            if (responseMap.containsKey('queryResults')) {
                return JSON.serialize(responseMap.get('queryResults'));
            } else if (responseMap.containsKey('error')) {
                throw new IllegalArgumentException('Error in API response: ' + String.valueOf(responseMap.get('error')));
            } else {
                throw new IllegalArgumentException('queryResults not found in response.');
            }
        } catch (Exception e) {
            throw new IllegalArgumentException('Failed to parse JSON response: ' + rawResponse + '. Error: ' + e.getMessage());
        }
    }
}