import Foundation

class City: NSObject, Codable {
	var name: String?
	var latitude: Double?
	var longitude: Double?
	var time: String?
	var dayOfWeek: String?
	var temperature: String?
	var weather: Weather?
	var dailyWeatherList: [Daily]?
	var hourlyWeatherList: [Hourly]?
}
