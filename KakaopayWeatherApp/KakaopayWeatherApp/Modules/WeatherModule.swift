class WeatherModule: Observation {
	
	static let instance = WeatherModule()
	
	func requestWeather(latitude: Double, longitude: Double) {
		API.instance.requestWeather(latitude: latitude, longitude: longitude) { json in
			print(json)
			self.notify(json)
		}
	}
	
	func notify(_ json: Any) {
		for observer in observers {
			observer.update(json)
		}
	}
	
}
