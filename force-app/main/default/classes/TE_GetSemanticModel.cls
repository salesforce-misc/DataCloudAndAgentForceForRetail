/**
 * Class to fetch and process semantic models.
 * Utilizes the Semantic Layer API to retrieve raw JSON of semantic models
 * and processes it for specific use cases like prompt templates.
 *
 * Author: Kunal Tomar
 * Contact: kunal.tomar@salesforce.com
 */
public with sharing class TE_GetSemanticModel {

    /**
     * Wrapper class for the results returned by the fetch and process operation.
     */
    public class ResultWrapper {
        @InvocableVariable
        public String rawJson; // Full semantic model description (unprocessed).

        @InvocableVariable
        public String processedJson; // Processed JSON for specific use cases (fields, tables, types).
    }

    /**
     * Wrapper class for the input parameters required to fetch the semantic model.
     */
    public class InputWrapper {
        @InvocableVariable(required=true)
        public String modelApiName; // API Name of the semantic model to fetch.
        
        @InvocableVariable
        public String fieldsComponents; // Comma-separated string of components to include in the fields node (e.g., "semanticDataObjects,semanticMeasurements").

        @InvocableVariable
        public String documentationComponents; // Components to include in the "documentation" node, if applicable.
    }

    /**
     * Invocable method to fetch and process a semantic model.
     * 
     * @param inputs A list of InputWrapper objects containing the required model API names and optional parameters.
     * @return A list of ResultWrapper objects with the raw and processed JSON results.
     * 
     */
    @InvocableMethod(label='Fetch and Process Semantic Model' description='Fetches the semantic model and returns both raw and processed JSON.')
    public static List<ResultWrapper> fetchAndProcessSemanticModel(List<InputWrapper> inputs) {
        List<ResultWrapper> results = new List<ResultWrapper>();

        for (InputWrapper input : inputs) {
            ResultWrapper result = new ResultWrapper();
            try {
                result.rawJson = fetchRawSemanticModel(input.modelApiName);

                result.processedJson = processSemanticModel(result.rawJson, input.fieldsComponents, input.documentationComponents);
            } catch (Exception e) {
                result.rawJson = 'Error: ' + e.getMessage();
                result.processedJson = 'Error: ' + e.getMessage();
            }

            results.add(result);
        }

        return results;
    }

    /**
     * Fetches the raw semantic model from the Semantic Layer API.
     * 
     * @param modelApiName The API name of the semantic model to fetch.
     * @return The raw JSON string of the semantic model.
     * @throws IllegalArgumentException if the API call fails or returns an error.
     */
    private static String fetchRawSemanticModel(String modelApiName) {
        List<TE_GenericInvoker.RequestWrapper> invokerRequests = new List<TE_GenericInvoker.RequestWrapper>();
        TE_GenericInvoker.RequestWrapper request = new TE_GenericInvoker.RequestWrapper();
        request.endpointName = 'getSemanticModel';
        request.modelApiNameOrId = modelApiName;
        request.method = 'GET';
        invokerRequests.add(request);

        List<TE_GenericInvoker.ResponseWrapper> invokerResponses = TE_GenericInvoker.invokeApi(invokerRequests);

        if (invokerResponses.isEmpty() || 
            (invokerResponses[0].status != 'Success' && invokerResponses[0].status != 'Success (From Cache)')) {
            throw new IllegalArgumentException(
                'API Fetch Error: ' + 
                (invokerResponses.isEmpty() ? 'No response received.' : invokerResponses[0]?.resultText)
            );
        }

        return invokerResponses[0].resultText;
    }

    /**
     * Processes the raw semantic model JSON using the Semantic Model Processor.
     * 
     * @param rawJson The raw JSON string of the semantic model.
     * @param fieldsComponents Comma-separated string of components to include in the fields node.
     * @param documentationComponents Comma-separated string of components to include in the documentation node.
     * @return The processed JSON string.
     * @throws IllegalArgumentException if the processing fails or returns no results.
     */
    private static String processSemanticModel(String rawJson, String fieldsComponents, String documentationComponents) {
        List<TE_SemanticModelProcessor.InputWrapper> loaderInputs = new List<TE_SemanticModelProcessor.InputWrapper>();
        TE_SemanticModelProcessor.InputWrapper loaderInput = new TE_SemanticModelProcessor.InputWrapper();
        loaderInput.jsonInput = rawJson;
        loaderInput.fieldsComponents = fieldsComponents;
        loaderInput.documentationComponents = documentationComponents;
        loaderInputs.add(loaderInput);

        List<TE_SemanticModelProcessor.OutputWrapper> loaderResponses = TE_SemanticModelProcessor.processSemanticModel(loaderInputs);

        if (loaderResponses.isEmpty()) {
            throw new IllegalArgumentException('Processing Error: TE_SemanticModelProcessor returned no results.');
        }

        return loaderResponses[0].jsonOutput;
    }
}