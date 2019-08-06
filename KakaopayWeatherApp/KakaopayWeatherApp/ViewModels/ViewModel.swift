import Foundation
import SystemConfiguration

class ViewModel: ObserverProtocol {
	
	var id = String(describing: ViewModel.self)
	var networkDisconnected = Observable(value: Void())
	var city = Observable<City>(value: City())
	var cityList = Observable<[City]>(value: [])
	var cityListEmpty = Observable(value: Void())
	var cityListExists = Observable(value: Void())
	
	var cityWeather = Observable<City>(value: City())
	var dailyWeatherList = Observable<[Daily]>(value: [])
	var hourlyWeatherList = Observable<[Hourly]>(value: [])
	
	var savedCityList: [City] {
		get {
			guard
				let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.cityList.rawValue) as? Data,
				let list = try? JSONDecoder().decode([City].self, from: data) else { return [] }
			return list
		}
		set {
			guard let encoded = try? JSONEncoder().encode(newValue) else { return }
			UserDefaults.standard.set(encoded, forKey: Constants.UserDefaultsKey.cityList.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
	
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
	
	func configureCityList() {
		cityList.value = savedCityList
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
	
	func appendNewLocation(_ city: City) {
		var newCityList = savedCityList
		newCityList.append(city)
		savedCityList = newCityList
	}
	
	func saveSelectedCity(with name: String) {
		let city = City()
		city.name = name
		LocationModule.instance.getCoordinates(with: city) { coordinates in
			city.latitude = coordinates?.0
			city.longitude = coordinates?.1
			self.appendNewLocation(city)
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
