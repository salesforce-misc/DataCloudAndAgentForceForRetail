public with sharing class GetWeather {
    @InvocableMethod(
        label='Check Weather'
        description='Check weather at Mexico location for a specific date. The date must be in the future, not today or earlier.'
    )
    public static List<WeatherResponse> getWeather(
        List<WeatherRequest> requests
    ) {
        // Retrieve the date for which we want to check the weather
        Datetime dateToCheck = (Datetime) requests[0].dateToCheck;

        WeatherService.Weather weather = WeatherService.getMexicoWeather();
        
        // Create the response for the agent
        WeatherResponse response = new WeatherResponse();
        system.debug('RESPONSE'+response);
        response.minTemperature = weather.minTemperatureC;
        response.maxTemperature = weather.maxTemperatureC;
         response.dayCondition = weather.condition;
        system.debug('DAY'+response.dayCondition);
        response.temperatureDescription =
            'Since the marathon is in Mexico, I checked the expected weather —it will be' +
            +' ' + 
            weather.condition +
            ', around ' + 
            weather.minTemperatureF +
            ' - '+
            weather.maxTemperatureF +
             '°F ' + 
             '('+
             weather.minTemperatureC +
              '-'+  
              weather.maxTemperatureC +
            '°C )';
           	WeatherBasedShoeFlyout__e eventMessage = new WeatherBasedShoeFlyout__e();
            eventMessage.isVisible__c = True;
            eventMessage.WeatherCondition__c = response.dayCondition;
            system.debug('WEATHER CONDITION DEBUG'+eventMessage.WeatherCondition__c);
        	Database.SaveResult sr = EventBus.publish(eventMessage);
        
        // Add logger to check if the event is published successfully
        if (sr.isSuccess()) {
            System.debug('Event published successfully: ' + sr.getId());
        } else {
            for (Database.Error error : sr.getErrors()) {
                System.debug('Failed to publish event: ' + error.getStatusCode() + ' - ' + error.getMessage());
            }
            
        }
		//Invoke a Auto-launched Flow
        
        //Call the Flow
        // Flow.Interview myFlow = new Flow.Interview.GenerateProductRecommendationBasedOnWeather(new Map<String,Object>
        //                                                                                      {'weatherCondition' => response.dayCondition});
        // myFlow.start();
        //Get the Flow Output
        // String promptResponse = (String)myFlow.getVariableValue('promptResponse');
        // System.debug('Prompt Response'+promptResponse);
        return new List<WeatherResponse>{ response };
    }

    public class WeatherRequest {
        @InvocableVariable(
            required=true
            description='Date for which we want to check the temperature. The variable needs to be an Apex Date type with format yyyy-MM-dd.'
        )
        public Date dateToCheck;
    }

    public class WeatherResponse {
        @InvocableVariable(
            description='Minimum temperature in Celsius at Mexico location for the provided date'
        )
        public Decimal minTemperature;
        @InvocableVariable(
            description='Maximum temperature in Celsius at Mexico location for the provided date'
        )
        public Decimal maxTemperature;
        
        @InvocableVariable(
            description='Description of temperatures at Mexico location for the provided date'
        )
        public String temperatureDescription;
        
        //  @InvocableVariable(
        //     description='Description of Day Condition at Mexico location for the provided date'
        // )
        public String dayCondition;
      
    }
}