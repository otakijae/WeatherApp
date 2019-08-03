import Foundation

class ViewModel: Observation {
	
	override init() {
		super.init()
		addObservers()
	}
	
	func addObservers() {
		WeatherModule.instance.addObserver(self)
	}
	
	func notify(_ json: Any) {
		for observer in observers {
			observer.update(json)
		}
	}
	
	func notify(_ city: City) {
		for observer in observers {
			observer.update(city)
		}
	}
	
	func notify(_ cityList: [City]) {
		for observer in observers {
			observer.update(cityList)
		}
	}
	
	func requestSimpleWeather(with city: City) {
		WeatherModule.instance.requestSimpleWeather(with: city)
	}
	
	func requestSimpleWeatherList(with cityList: [City]) {
		WeatherModule.instance.requestSimpleWeatherList(with: cityList) { simpleWeatherList in
			self.notify(simpleWeatherList)
		}
	}
	
}

extension ViewModel: Observer {
	
	func update(_ list: [String]) {
		
	}
	
	func update(_ json: Any) {
		notify(json)
	}
	
	func update(_ city: City) {
		notify(city)
	}
	
	func update(_ cityList: [City]) {
		notify(cityList)
	}
	
}
