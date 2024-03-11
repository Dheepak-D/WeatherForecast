class AddressController < ApplicationController

	before_action :validate_input_params, only: [:forecast_weather]
	before_action :read_from_cache, only: [:forecast_weather]
	after_action :write_in_cache, only: [:forecast_weather]
  
	def forecast_weather
	    zipcode = params['zipCode']
	    weatherbit_response = ExternalClients::WeatherBitClient.get_weather_forecast(zipcode) 
	    render status: 200, json: present_response(weatherbit_response)
	end

	private

	def validate_input_params
		params.require(:zipCode)
	end

	def present_response(weatherbit_response)
		weatherbitResponseToApiResponseMap = {
			high_temp: 'highTemperature',
			temp: 'avgTemperature',
			low_temp: 'avgTemperature',
			valid_date: 'date'
		}
		return {
			'city': weatherbit_response['city_name'],
			'countryCode': weatherbit_response['country_code'],
			'latitude': weatherbit_response['lat'],
            'longitude': weatherbit_response['lon'],
            'weatherForecastForNext16Days': present_weather_for_each_day(weatherbit_response['data'])
		}
	end

	def present_weather_for_each_day(next_16_days_weather)
		presentable_weather_for_next_16_days = []
		next_16_days_weather.each do |weather_forecast|
			peresentable_weather_forecast = {
				highTemperature: weather_forecast['high_temp'],
				avgTemperature: weather_forecast['temp'],
				lowTemperature: weather_forecast['low_temp'],
				date: weather_forecast['valid_date'],
			}
			presentable_weather_for_next_16_days << peresentable_weather_forecast
		end
		presentable_weather_for_next_16_days
	end

	def write_in_cache
		CacheWrapper.set_with_expiry(get_cache_key_for_zipcode(params["zipCode"]), 5.seconds.to_i, response.body)
		response.headers['Cache-Status'] = 'Miss'
	end

	def read_from_cache
		cached_response = CacheWrapper.fetch(get_cache_key_for_zipcode(params["zipCode"]))
		if cached_response.present?
			response.headers['Cache-Status'] = 'Hit'
            render status: 200, json: cached_response
		end
	end

	def get_cache_key_for_zipcode(zipcode)
		"GetWeatherForecastByZipCode::#{zipcode}"
	end
end