import Foundation

class ViewModel: ObserverProtocol {
	
	var id = String(describing: ViewModel.self)
	var json: Observable<String> = Observable(value: "")
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var cityWeather: Observable<City> = Observable<City>(value: City())
	var dailyWeatherList: Observable<[Daily]> = Observable<[Daily]>(value: [])
	var hourlyWeatherList: Observable<[Hourly]> = Observable<[Hourly]>(value: [])
	
	init() {
		subscribe()
	}
	
	func subscribe() {
		
		WeatherModule.instance.city.addObserver(self) { city in
			self.city.value = city
		}
		
		WeatherModule.instance.cityWeather.addObserver(self) { cityWeather in
			self.cityWeather.value = cityWeather
		}
		
		WeatherModule.instance.dailyWeatherList.addObserver(self) { dailyWeatherList in
			self.dailyWeatherList.value = dailyWeatherList
		}
		
		WeatherModule.instance.hourlyWeatherList.addObserver(self) { hourlyWeatherList in
			self.hourlyWeatherList.value = hourlyWeatherList
		}
		
	}
	
	func requestSimpleWeather(with city: City) {
		WeatherModule.instance.requestSimpleWeather(with: city)
	}
	
	func requestSpecificWeather(with city: City?) {
		guard let city = city else { return }
		WeatherModule.instance.requestSpecificWeather(with: city)
	}
	
	func requestDailyWeather(with city: City?) {
		guard let city = city else { return }
		WeatherModule.instance.requestDailyWeather(with: city)
	}
	
	func requestHourlyWeather(with city: City?) {
		guard let city = city else { return }
		WeatherModule.instance.requestHourlyWeather(with: city)
	}
	
}
