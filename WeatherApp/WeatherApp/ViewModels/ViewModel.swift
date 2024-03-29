import Foundation
import SystemConfiguration
import MapKit

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
	var responseNotify = Observable(value: Void())
	var locationList = Observable<[MKMapItem]>(value: [])
	var selectedCity = Observable<City>(value: City())
	
	var list: [City] = []
	
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
	
	fileprivate func subscribe() {
		
		WeatherModule.instance.city.addObserver(self) { [weak self] city in
			self?.list.append(city)
		}
		
		WeatherModule.instance.cityWeather.addObserver(self) { [weak self] cityWeather in
			self?.cityWeather.value = cityWeather
		}
		
		WeatherModule.instance.dailyWeatherList.addObserver(self) { [weak self] dailyWeatherList in
			self?.dailyWeatherList.value = dailyWeatherList
		}
		
		WeatherModule.instance.hourlyWeatherList.addObserver(self) { [weak self] hourlyWeatherList in
			self?.hourlyWeatherList.value = hourlyWeatherList
		}
		
		LocationModule.instance.locationList.addObserver(self) { locationList in
			self.locationList.value = locationList
		}
		
		LocationModule.instance.selectedCity.addObserver(self) { selectedCity in
			self.appendNewLocation(selectedCity)
			self.selectedCity.value = selectedCity
		}
		
	}
	
	func configureCityList() {
		cityList.value = savedCityList
		checkEmptyCityList(with: cityList.value)
	}
	
	fileprivate func checkEmptyCityList(with cityList: [City]) {
		if cityList.isEmpty {
			cityListEmpty.value = Void()
		} else {
			cityListExists.value = Void()
			requestSimpleWeatherList(with: cityList)
		}
	}
	
	fileprivate func requestSimpleWeatherList(with cityList: [City]) {
		list.removeAll()
		let group = DispatchGroup()
		cityList.forEach {
			WeatherModule.instance.requestSimpleWeather(with: $0, in: group)
		}
		group.notify(queue: .main) {
			self.cityList.value = self.list
		}
	}
	
	func requestDetailWeathers(with city: City?) {
		let group = DispatchGroup()
		let queue = DispatchQueue.global()
		guard let city = city else { return }
		queue.async(group: group) {
			WeatherModule.instance.requestSpecificWeather(with: city, in: group)
			WeatherModule.instance.requestDailyWeather(with: city, in: group)
			WeatherModule.instance.requestHourlyWeather(with: city, in: group)
		}
		group.notify(queue: queue) {
			self.responseNotify.value = Void()
		}
	}
	
	func requestLocations(query: String?) {
		guard let query = query else { return }
		LocationModule.instance.requestLocations(query: query)
	}
	
	fileprivate func appendNewLocation(_ city: City) {
		var newCityList = savedCityList
		newCityList.append(city)
		savedCityList = newCityList
	}
	
	func saveSelectedCity(with mapItem: MKMapItem) {
		if let selectedCityName = mapItem.placemark.locality {
			let city = City()
			city.name = selectedCityName
			LocationModule.instance.getCoordinates(with: city)
		} else {
			guard let cityName = mapItem.placemark.name else { return }
			let city = City()
			city.name = cityName
			LocationModule.instance.getCoordinates(with: city)
		}
	}
	
	func requestNetworkConnectionStatus() {
		if !isConnectedToNetwork() {
			networkDisconnected.value = Void()
		}
	}
	
	fileprivate func isConnectedToNetwork() -> Bool {
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
