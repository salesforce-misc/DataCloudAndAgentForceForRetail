/**
 * Generic invoker for interacting with the Tableau Einstein Semantic Layer APIs.
 * This class supports dynamic endpoint invocation.
 *
 * Author: Antoine Laviron 
 * Contact: alaviron@salesforce.com
 */
public with sharing class TE_GenericInvoker {

    /**
     * Wrapper class for API request parameters.
     */
    public class RequestWrapper {
        @InvocableVariable(required=true)
        public String endpointName; // Key for the endpoint, e.g., 'getSemanticModelById'

        @InvocableVariable
        public String modelApiNameOrId; // Parameter for dynamic endpoint substitution

        @InvocableVariable
        public String payload; // Optional payload for the request

        @InvocableVariable
        public String method; // HTTP method (e.g., GET, POST, PUT)

        @InvocableVariable
        public String workspaceApiName; // Parameter for dynamic endpoint substitution

        @InvocableVariable
        public String visualizationApiName; // Parameter for dynamic endpoint substitution

        @InvocableVariable
        public String metricApiNames; // Parameter for dynamic endpoint substitution
    }

    /**
     * Wrapper class for API response details.
     */
    public class ResponseWrapper {
        @InvocableVariable
        public String resultText; // API response or error message

        @InvocableVariable
        public String status; // 'Success' or 'Error'
    }

    // Mapping of endpoint keys to their respective API URLs
    private static Map<String, String> endpointMap = new Map<String, String>{
        'getSemanticModel' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}',
        'getSemanticModelCollection'  => '/services/data/v63.0/ssot/semantic/models',
        'executeSemanticQuery' => '/services/data/v63.0/semantic-engine/gateway',
        'getVisualizationCollection' => '/services/data/v63.0/tableau/visualizations',
        'getVisualization' => '/services/data/v63.0/tableau/visualizations/{visualizationApiName}',
        'getWorkspaceCollection' => '/services/data/v63.0/tableau/workspaces',
        'getWorkspace' => '/services/data/v63.0/tableau/workspaces/{workspaceApiName}',
        'createVisualization' => '/services/data/v63.0/tableau/visualizations',
        'createSemanticModel' => '/services/data/v63.0/ssot/semantic/models',
        'createCalculatedDimension' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/calculated-dimensions',
        'createCalculatedMeasure' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/calculated-measurements',
        'createMetric' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/metrics',
        'createSubmetric' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/sub-metrics',
        'getMetricCollection' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/metrics',
        'getSubMetricCollection' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/sub-metrics',
        'getSubmetricByMetric' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/metric-api-names/{metricApiNames}/sub-metric',
        'getSubmetric' => '/services/data/v63.0/ssot/semantic/models/{modelApiNameOrId}/sub-metrics/{subMetricNameOrId}',
        'createWorkspace' => '/services/data/v63.0/tableau/workspaces'
    };

    /**
     * Generates a unique key for caching based on endpoint and payload.
     *
     * @param endpointName The name of the endpoint.
     * @param payload The payload used in the request.
     * @return A unique cache key string.
     */
    private static String generateCacheKey(String endpointName, String payload) {
        String payloadHash;
        if (payload != null) {
            Blob digest = Crypto.generateDigest('SHA-256', Blob.valueOf(payload));
            payloadHash = EncodingUtil.base64Encode(digest); // Encode hash for readability
        } else {
            payloadHash = 'no_payload';
        }
        return endpointName + ':' + payloadHash;
    }

    /**
     * Invocable method to call a Semantic Layer API with optional query parameters.
     *
     * @param requestList A list of RequestWrapper objects containing the API details.
     * @return A list of ResponseWrapper objects with the API response or error messages.
     * 
     */
    @InvocableMethod(label='Generic Seamntic Layer API Invoker with Query Parameter' description='Invokes a Semantic Layer API endpoint with optional query parameter')
    public static List<ResponseWrapper> invokeApi(List<RequestWrapper> requestList) {
        List<ResponseWrapper> responses = new List<ResponseWrapper>();

        for (RequestWrapper request : requestList) {
            ResponseWrapper response = new ResponseWrapper();

            try {
                // Validate input
                validateRequest(request);

                // Retrieve the endpoint template
                String endpointTemplate = endpointMap.get(request.endpointName);
                if (String.isEmpty(endpointTemplate)) {
                    throw new IllegalArgumentException('Invalid endpoint name: ' + request.endpointName);
                }

                // Replace placholders
                endpointTemplate = replacePlaceholders(endpointTemplate, buildParamsMap(request));

                // Construct the full endpoint URL
                String fullEndpoint = 'callout:TableauEinsteinAPI' + endpointTemplate;
                // System.debug(fullEndpoint);
                // System.debug(request.payload);

                // Send the API request
                HttpResponse httpResponse = TE_ApiHelper.sendApiRequest(
                    request.method,
                    fullEndpoint,
                    request.payload
                );
                // Process the API response
                responses.add(processHttpResponse(httpResponse));
                // System.debug(responses);
            } catch (Exception e) {
                // Handle any errors during processing
                responses.add(createErrorResponse(e));
            }
        }
        return responses;
    }

    /**
     * Validates the required fields of a RequestWrapper object.
     * 
     * @param request The RequestWrapper object containing API call details.
     * @throws IllegalArgumentException If required fields (endpointName, method) are missing or empty.
     */
    private static void validateRequest(RequestWrapper request) {
        if (String.isEmpty(request.endpointName)) {
            throw new IllegalArgumentException('Endpoint name is required.');
        }
        if (String.isEmpty(request.method)) {
            throw new IllegalArgumentException('HTTP method is required.');
        }
    }

    /**
     * Replaces placeholders in the endpoint template with actual values from the parameters map.
     * 
     * @param template The endpoint URL template containing placeholders (e.g., {modelApiNameOrId}).
     * @param params A map of placeholder keys to their replacement values.
     * @return The endpoint URL with placeholders replaced by actual values.
     * @throws IllegalArgumentException If a required parameter value is missing.
     */
    private static String replacePlaceholders(String template, Map<String, String> params) {
        for (String key : params.keySet()) {
            String placeholder = '{' + key + '}';
            String value = params.get(key);
    
            // Replace only if the value is not empty
            if (template.contains(placeholder) && !String.isEmpty(value)) {
                template = template.replace(placeholder, value);
            } else if (template.contains(placeholder) && String.isEmpty(value)) {
                throw new IllegalArgumentException('Missing required parameter: ' + key);
            }
        }
        return template;
    }

    /**
     * Constructs a map of parameters for placeholder substitution in endpoint templates.
     * 
     * @param request The RequestWrapper object containing the parameters for substitution.
     * @return A map of placeholder keys to their values (e.g., modelApiNameOrId -> 'sampleModelId').
     */
    private static Map<String, String> buildParamsMap(RequestWrapper request) {
        return new Map<String, String>{
            'modelApiNameOrId' => request.modelApiNameOrId,
            'workspaceApiName' => request.workspaceApiName,
            'visualizationApiName' => request.visualizationApiName,
            'metricApiNames' => request.metricApiNames
        };
    }

    /**
     * Processes an HTTP response and creates a ResponseWrapper object.
     * 
     * @param httpResponse The HttpResponse object returned by the HTTP request.
     * @return A ResponseWrapper object containing the status and response body.
     */
    private static ResponseWrapper processHttpResponse(HttpResponse httpResponse) {
        ResponseWrapper response = new ResponseWrapper();
        Integer statusCode = httpResponse.getStatusCode();
        if (statusCode == 200 || statusCode == 201) {
            response.resultText = httpResponse.getBody();
            response.status = 'Success';
        } else {
            response.resultText = 'Failed with status code: ' + statusCode;
            response.status = 'Error';
        }
        return response;
    }

    /**
     * Creates a ResponseWrapper object to represent an error response.
     * 
     * @param e The Exception object thrown during request processing.
     * @return A ResponseWrapper object containing the error message and status as 'Error'.
     */
    private static ResponseWrapper createErrorResponse(Exception e) {
        ResponseWrapper errorResponse = new ResponseWrapper();
        errorResponse.resultText = 'Error: ' + e.getMessage();
        errorResponse.status = 'Error';
        return errorResponse;
    }
    
}