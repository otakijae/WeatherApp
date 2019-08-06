import Foundation

class City: Codable {
	var name: String?
	var latitude: Double?
	var longitude: Double?
	var currentTime: String?
	var dayOfWeek: String?
	var currentTemperature: String?
	var weather: Weather?
	var dailyWeatherList: [Daily] = []
	var hourlyWeatherList: [Hourly] = []
}

extension UserDefaults {
	
	func set<T: Codable>(for type : T, using key : String) {
		let encodedData = try? PropertyListEncoder().encode(type)
		UserDefaults.standard.set(encodedData, forKey: key)
		UserDefaults.standard.synchronize()
	}
	
	func value<T: Codable>(for type : T.Type, using key : String) -> T? {
		guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
		let decodedObject = try? PropertyListDecoder().decode(type, from: data)
		return decodedObject
	}
	
}
