import Foundation

struct Time {
	
	static let instance = Time()
	
	func getCurrentTimeZoneType() -> String {
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
		let defaultTimeZoneString = dateFormatter.string(from: date)
		return defaultTimeZoneString
	}
	
	func getCurrentTime(in timeZone: String? = nil) -> String {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.amSymbol = "오전"
		dateFormatter.pmSymbol = "오후"
		dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
		if let timeZone = timeZone {
			dateFormatter.timeZone = TimeZone(identifier: timeZone)!
		}
		return dateFormatter.string(from: now)
	}
	
	func getSimpleCurrentTime(in timeZone: String? = nil) -> String {
		let now: Date = Date()
		let dateFormatter: DateFormatter = DateFormatter()
		dateFormatter.amSymbol = "오전"
		dateFormatter.pmSymbol = "오후"
		dateFormatter.dateFormat = "a hh시 mm분"
		if let timeZone = timeZone {
			dateFormatter.timeZone = TimeZone(identifier: timeZone)!
		}
		return dateFormatter.string(from: now)
	}
	
	func getStringTime(from unixDate: Double?, in timeZone: String? = nil) -> String? {
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
		if let timeZone = timeZone {
			dateFormatter.timeZone = TimeZone(identifier: timeZone)!
		}
		let time: String = dateFormatter.string(from: date)
		
		return time
	}
	
	func getSimpleStringTime(from unixDate: Double?, in timeZone: String? = nil) -> String? {
		guard let unixDate = unixDate else { return nil }
		
		let unixStringDate = NSDate(timeIntervalSince1970: unixDate)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let dateString = dateFormatter.string(from: unixStringDate as Date)
		
		let trimmedStringDate: String = String(dateString.prefix(19))
		guard let date = dateFormatter.date(from: trimmedStringDate) else { return nil }
		dateFormatter.amSymbol = "오전"
		dateFormatter.pmSymbol = "오후"
		dateFormatter.dateFormat = "a hh시 mm분"
		if let timeZone = timeZone {
			dateFormatter.timeZone = TimeZone(identifier: timeZone)!
		}
		let time: String = dateFormatter.string(from: date)
		
		return time
	}
	
}
