import Foundation
import SystemConfiguration

class ViewModel: ObserverProtocol {
	
	var id = String(describing: ViewModel.self)
	var networkDisconnected: Observable<Void> = Observable(value: Void())
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var cityListEmpty: Observable<Void> = Observable(value: Void())
	var cityListExists: Observable<Void> = Observable(value: Void())
	
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
	
	func requestSimpleWeatherList(with cityList: [City]) {
		cityList.forEach {
			WeatherModule.instance.requestSimpleWeather(with: $0)
		}
	}
	
	func requestDetailWeathers(with city: City?) {
		guard let city = city else { return }
		WeatherModule.instance.requestSpecificWeather(with: city)
		WeatherModule.instance.requestDailyWeather(with: city)
		WeatherModule.instance.requestHourlyWeather(with: city)
	}
	
	func configureCityList(with savedCityList: [String]) {
		var list: [City] = []
		savedCityList.forEach {
			let city = City()
			city.name = $0
			list.append(city)
		}
		cityList.value = list
		checkEmptyCityList(with: cityList.value)
	}
	
	func checkEmptyCityList(with cityList: [City]) {
		if cityList.isEmpty {
			cityListEmpty.value = Void()
		} else {
			cityListExists.value = Void()
			requestSimpleWeatherList(with: cityList)
		}
	}
	
	func requestNetworkConnectionStatus() {
		if !isConnectedToNetwork() {
			networkDisconnected.value = Void()
		}
	}
	
	func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		let ret = (isReachable && !needsConnection)
		
		return ret
	}
	
}
