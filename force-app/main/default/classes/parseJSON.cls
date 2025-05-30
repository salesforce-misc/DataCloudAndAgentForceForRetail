public with sharing class parseJSON {

	//Apex to parse JSON and get ProductID
    
    public class FlowInput {
        @InvocableVariable(required=true)
        public String jsonString;
    }
   
    public class FlowOutput {
        @InvocableVariable
        public String productId;
    }

   
    @InvocableMethod(label='Parse JSON and Get Product ID' 
                     description='Recibe el JSON con totalEngagements y productEngagements y devuelve el ID del producto más recientemente visitado.')
    public static List<FlowOutput> parseJSONtoGetProductId(List<FlowInput> requests) {
        System.debug('## requests = '+requests);
        List<FlowOutput> results = new List<FlowOutput>();

        for (FlowInput request : requests) {
            String foundProductId = '0';

            try {
                System.debug('## request.jsonString = '+request.jsonString);
                // 1. Deserializamos sin tipar para obtener un Map que contenga "productEngagements"
                Map<String, Object> rootMap = (Map<String, Object>) JSON.deserializeUntyped(request.jsonString);
                System.debug('## rootMap = '+rootMap);
                // 2. Extraemos la lista "productEngagements"
                List<Object> engagements = (List<Object>) rootMap.get('productEngagements');
                System.debug('## engagements = '+engagements);
                if (engagements != null && !engagements.isEmpty()) {
                    // 3. Recorremos la lista en orden inverso (más reciente al final)
                    for (Integer i = engagements.size() - 1; i >= 0; i--) {
                        Map<String, Object> interaction = (Map<String, Object>) engagements[i];
                        // 4. Obtenemos la URL
                        String pageURL = (String) interaction.get('ssot__PageURL__c');
                        // 5. Verificamos si la URL contiene "/product/detail"
                        if (pageURL != null && (pageURL.contains('/product/') || pageURL.contains('/product/detail'))) {
                            System.debug('## Coming inside if ='+ interaction.get('ssot__ProductId__c'));
                            // Extraemos la subcadena tras el último "/"
                            Integer lastSlashIndex = pageURL.lastIndexOf('/');
                            if (lastSlashIndex != -1) {
                                foundProductId = pageURL.substring(lastSlashIndex + 1);
                            }
                            break; // Detenemos la búsqueda al primer hallazgo
                        }else if(pageURL != null && !pageURL.contains('/product/')  && interaction.get('ssot__ProductId__c') != NULL){
                            foundProductId = (String) interaction.get('ssot__ProductId__c');
                            break;
                        }
                    }
                    System.debug('## foundProductId = '+foundProductId);
                }
            } catch (Exception ex) {
                // Si hay algún error, foundProductId permanece "0".
                // Podrías hacer logs con System.debug, etc.
            }

            // Construimos el objeto de salida
            FlowOutput output = new FlowOutput();
            output.productId = foundProductId;
            results.add(output);
        }

        return results;
    }
}