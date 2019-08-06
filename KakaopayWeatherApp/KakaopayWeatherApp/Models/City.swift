import Foundation

class City: NSObject, Codable {
	var name: String?
	var latitude: Double?
	var longitude: Double?
	var currentTime: String?
	var dayOfWeek: String?
	var currentTemperature: String?
	var weather: Weather?
	var dailyWeatherList: [Daily]?
	var hourlyWeatherList: [Hourly]?
}
