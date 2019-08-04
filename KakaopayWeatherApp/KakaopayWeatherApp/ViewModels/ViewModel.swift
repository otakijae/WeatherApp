import Foundation

class ViewModel: ObserverProtocol {
	
	var id = String(describing: ViewModel.self)
	var json: Observable<String> = Observable(value: "")
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	
	init() {
		subscribe()
	}
	
	func subscribe() {
		
		WeatherModule.instance.city.addObserver(self) { city in
			self.city.value = city
		}
		
		WeatherModule.instance.cityList.addObserver(self) { cityList in
			self.cityList.value = cityList
		}
		
	}
	
	func requestSimpleWeather(with city: City) {
		WeatherModule.instance.requestSimpleWeather(with: city)
	}
	
	func requestSimpleWeatherList(with cityList: [City]) {
		
	}
	
}
