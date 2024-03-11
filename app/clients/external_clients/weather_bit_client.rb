class ExternalClients::WeatherBitClient
	API_KEY = '3abd3584ce094da4bf2d5f4846db7f52'.freeze

	def self.get_weather_forecast(zipcode)
		raise RestClient::BadRequest.new("Zipcode should not be empty") if zipcode.blank?
		url = "https://api.weatherbit.io/v2.0/forecast/daily?postal_code=#{zipcode}&key=#{API_KEY}"
		response = RestClient.get(url)
		case response.code
		when 200
			JSON.parse(response.body)
		end
	end
end