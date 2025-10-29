public class PromptTemplateController {
    public static String InvokePrompt(String sessionId){
        try{
            //create the input parameter
            //wrap the input parametre sessionId
            ConnectApi.WrappedValue SessionIdValue =  new ConnectApi.WrappedValue();
            SessionIdValue.value =  sessionId;
            //Prepare the input parametre map for the prompttemplate input
            Map<String,ConnectApi.WrappedValue> inputparams= new Map<String,ConnectApi.WrappedValue>();
            inputparams.put('input:SessionId', SessionIdValue);
            
            //setup template
            ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
			executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
			executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
			executeTemplateInput.isPreview = false;
			executeTemplateInput.inputParams = inputParams;
            
            //call the prompt template
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
    		'SurveyResponse-ShoeRecomendation',
    		executeTemplateInput
			);        
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0]; 
			 system.debug('generationsOutput'+JSON.serialize(generationsOutput));
            String recommendations = response.text;
            
            if(generationsOutput !=null){
                system.debug('generationsOutput'+JSON.serialize(recommendations));
                return recommendations;
            }
            else{
                return 'No recommendation';
            }
        
        }
        catch(Exception e){
            System.debug('Error '+ e.getMessage());
            return e.getMessage();
        }
        
    }
}