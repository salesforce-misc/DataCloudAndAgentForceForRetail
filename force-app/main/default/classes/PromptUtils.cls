public class PromptUtils {
   // Method to invoke prompt and return parsed response
public static Map<String, String> invokePrompt(String promptTemplateDeveloperName, Map<String, ConnectApi.WrappedValue> inputParams) {
    // Prepare input for generating prompt template
    ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
    promptGenerationsInput.inputParams = inputParams;
    promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
    promptGenerationsInput.additionalConfig.numGenerations = 1;
    promptGenerationsInput.additionalConfig.enablePiiMasking = true;
    promptGenerationsInput.additionalConfig.applicationName = 'WeatherProductRecommendation';
    
    // Call the service to generate the prompt template response
    ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = 
    ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(promptTemplateDeveloperName, promptGenerationsInput);
    
    if (generationsOutput.generations.isEmpty()) {
    System.debug('No response generated from Prompt Template');
    return null;
    }
    
    // Extract response
    String responseText = generationsOutput.generations[0].text;
    System.debug('Prompt Response: ' + responseText);
    
    // Parse response into Product Name & Description
    Map<String, String> productDetails = new Map<String, String>();
    List<String> responseParts = responseText.split(' - '); // Assuming response format is 'ProductName - ShortDescription'
    if (responseParts.size() == 2) {
    productDetails.put('ProductName', responseParts[0].trim());
    productDetails.put('ProductDescription', responseParts[1].trim());
    } else {
    System.debug('Unexpected response format: ' + responseText);
    return null;
    }
    
    return productDetails;
    }
     
}