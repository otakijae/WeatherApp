class Weather {
	var timeZone: String?
	var icon: String?
	var temperature: Double?
	var summary: String?
	
	var temperatureMax: Double?
	var temperatureMin: Double?
	var sunriseTime: String?
	var sunsetTime: String?
	
	var precipitationProbability: Double?
	var humidity: Double?
	var windSpeed: Double?
	var apparentTemperature: Double?
	var precipitationIntensity: Double?
	var pressure: Double?
	var visibility: Double?
	var uvIndex: Double?
}

class Daily {
	var dayOfWeek: String?
	var icon: String?
	var summary: String?
	var temperatureMax: String?
	var temperatureMin: String?
}

class Hourly {
	var time: String?
	var icon: String?
	var summary: String?
	var temperature: Double?
}
