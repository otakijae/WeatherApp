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
			print("ViewModel")
			print(city)
			self.city.value = city
		}
		
		WeatherModule.instance.cityList.addObserver(self) { cityList in
			print("ViewModel")
			print(cityList)
		}
		
		WeatherModule.instance.simpleWeatherList.addObserver(self) { simpleWeatherList in
			print("ViewModel")
			print(simpleWeatherList)
		}
		
	}
	
	func requestSimpleWeather(with city: City) {
		WeatherModule.instance.requestSimpleWeather(with: city)
	}
	
	func requestSimpleWeatherList(with cityList: [City]) {
		WeatherModule.instance.requestSimpleWeatherList(with: cityList)
	}
	
}
