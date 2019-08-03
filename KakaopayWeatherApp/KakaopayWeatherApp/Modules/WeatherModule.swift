import Foundation

class WeatherModule: Observation {
	
	static let instance = WeatherModule()
	
	func requestWeather(latitude: Double, longitude: Double) {
		API.instance.requestWeather(latitude: latitude, longitude: longitude, time: getCurrentTimeZone()) { json in
			print(json)
			self.notify(json)
		}
	}
	
	func notify(_ json: Any) {
		for observer in observers {
			observer.update(json)
		}
	}
	
	func getCurrentTimeZone() -> String {
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
		let defaultTimeZoneString = dateFormatter.string(from: date)
		return defaultTimeZoneString
	}
	
	func getStringTime(from unixDate: Double?) -> String? {
		guard let unixDate = unixDate else { return nil }
		
		let unixStringDate = NSDate(timeIntervalSince1970: unixDate)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let dateString = dateFormatter.string(from: unixStringDate as Date)
		
		let trimmedStringDate: String = String(dateString.prefix(19))
		guard let date = dateFormatter.date(from: trimmedStringDate) else { return nil }
		dateFormatter.amSymbol = "오전"
		dateFormatter.pmSymbol = "오후"
		dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
		let time: String = dateFormatter.string(from: date)
		
		return time
	}
	
}
