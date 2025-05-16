public class WeatherService 
{
	/**
     * Gets the weather at Mexico on the provided date
     */
    
    
     //DateTime dateToCheck = Datetime.now().addDays(10);
    public static Weather getMexicoWeather() {
        DateTime dateToCheck = Datetime.now().addDays(7);
        Integer currentYear = Date.today().year();
        Integer yearDelta = currentYear - dateToCheck.year();
        dateToCheck = dateToCheck.addYears(yearDelta);
        String isoDate = dateToCheck.format('yyyy-MM-dd');
        String dateString = dateToCheck.format('MMMM d');
        Decimal lat;
        Decimal lon;
        List<cancun_mexico__mdt> metadataRecords =[SELECT MasterLabel, lon__c, lat__c FROM cancun_mexico__mdt];
        for (cancun_mexico__mdt record : metadataRecords) 
        {
            lat = record.lat__c;
            lon = record.lon__c;
		}

        // Prepare API request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Weather_Endpoint/weather?lat=' + lat + '&lon=' + lon + '&date=' + isoDate);
        req.setMethod('GET');
        // Make callout
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Weather response'+ res);
        if (res.getStatusCode() != 200) {
            throw new CalloutException('Bad response: ' + res);
        }

        // The response contains a list of temperatures for different times of the day
        // We parse the response and find the min and max temperatures
        String body = res.getBody();
        system.debug('response body -->'+body);
        WeatherApiResponse weatherResponse = (WeatherApiResponse) JSON.deserialize(
            body,
            WeatherAPIResponse.class
        );
        List<Decimal> temperatures = new List<Decimal>();
        List<String> weatherCondition= New List<String>();
        for (TemperatureWrapper item : weatherResponse.weather) {
            if (item.temperature != null) {
                temperatures.add(item.temperature);
                weatherCondition.add(item.condition);
            }
            
        }
        temperatures.sort();
        
       System.debug('weather condition->'+weatherCondition);

        // Prepare temperatures and description
        Decimal minTempC = temperatures[0];
        Decimal maxTempC = temperatures[temperatures.size() - 1];
        Decimal minTempF = toFahrenheit(minTempC);
        Decimal maxTempF = toFahrenheit(maxTempC);
        String condition = weatherCondition[0];
        system.debug('Condition'+condition);
        String description =
       
            'Since the marathon is in Mexico, I checked the expected weather —it will be' +
            +' ' + 
            condition +
            ', around ' + 
            minTempF +
            ' - '+
             maxTempF +
             '°F ' + 
             '('+
             minTempC +
              '-'+  
              maxTempC +
            '°C )';

        // Return weather info
        Weather weather = new Weather();
        weather.minTemperatureC = minTempC;
        weather.minTemperatureF = minTempF;
        weather.maxTemperatureC = maxTempC;
        weather.maxTemperatureF = maxTempF;
        weather.description = description;
		weather.condition = condition;
        
        system.debug('return weather -->'+weather);
        return weather;
    }

    private static Decimal toFahrenheit(Decimal celsius) {
        return (celsius * 9 / 5 + 32).setScale(1);
    }

    private class WeatherApiResponse {
        public List<TemperatureWrapper> weather;
    }

    private class TemperatureWrapper {
        public Decimal temperature;
        public String condition;
    }

    public class Weather {
        public Decimal minTemperatureC;
        public Decimal minTemperatureF;
        public Decimal maxTemperatureC;
        public Decimal maxTemperatureF;
        public String description;
        public String condition;
    }
    
}