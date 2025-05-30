/**
 * Utility class for making API calls to Salesforce or external services.
 * This class simplifies sending HTTP requests with necessary headers.
 * 
 * Author: Antoine Laviron 
 * Contact: alaviron@salesforce.com
 */
public with sharing class TE_ApiHelper {

    /**
     * Sends an HTTP request to the Salesforce API or external service.
     * 
     * @param method The HTTP method (e.g., GET, POST, PATCH, PUT).
     * @param endpoint The full API endpoint URL.
     * @param payload (Optional) The JSON payload for POST, PATCH, or PUT requests.
     * @return HttpResponse The response object from the API call.
     * 
     * @throws System.CalloutException If an issue occurs during the HTTP request.
     */
    public static HttpResponse sendApiRequest(String method, String endpoint, String payload) {
        // Validate input
        validateInputs(method,endpoint);

        // Create and configure the HTTP request
        HttpRequest req = new HttpRequest();
        req.setMethod(method); 
        req.setEndpoint(endpoint); // Set the target API endpoint URL
        req.setTimeout(20000); // Set default timeout
        setDefaultHeaders(req);

        // Attach the payload if required for the request type
        if (payload != null && (method == 'POST' || method == 'PATCH' || method == 'PUT')) {
            req.setBody(payload); // Set the JSON payload for applicable methods
        }
        Integer maxRetries = 3;
        Integer retryCount = 0;
        Integer retryDelayMillis = 1000; 


        // Initialize the HTTP object and send the request
        Http http = new Http();
        while (retryCount < maxRetries) {
            try {
                HttpResponse response = http.send(req);

                // Return response if successful
                if (response.getStatusCode() < 400) {
                    return response;
                }
            } catch (System.CalloutException e) {
                // System.debug('CalloutException on attempt ' + (retryCount + 1) + ': ' + e.getMessage());

                // Rethrow the exception if maximum retries reached
                if (retryCount == maxRetries - 1) {
                    throw e;
                }
            }

            // Add delay before retrying
            retryCount++;
            pauseExecution(retryDelayMillis);
        }
        throw new System.CalloutException('Failed to send API request after ' + maxRetries + ' attempts.');
        
    }

    /**
     * Validates required inputs.
     * 
     * @param method The HTTP method.
     * @param endpoint The endpoint URL.
     */
    private static void validateInputs(String method, String endpoint) {
        if (String.isEmpty(method)) {
            throw new IllegalArgumentException('HTTP method is required.');
        }
        if (String.isEmpty(endpoint)) {
            throw new IllegalArgumentException('Endpoint URL is required.');
        }
    }

    /**
     * Sets default headers for the HTTP request.
     * 
     * @param req The HTTP request object.
     */
    private static void setDefaultHeaders(HttpRequest req) {
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
    }

    /**
     * Pauses the execution for a specified duration.
     * 
     * @param milliseconds The duration in milliseconds to pause execution.
     */
    private static void pauseExecution(Integer milliseconds) {
        Long endTime = Datetime.now().getTime() + milliseconds;
        while (Datetime.now().getTime() < endTime) {
            
        }
    }

}