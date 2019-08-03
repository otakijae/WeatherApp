import Foundation
import MapKit

class WeatherModule {
	
	static let instance = WeatherModule()
	
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var simpleWeatherList: Observable<[City]> = Observable<[City]>(value: [])
	
	func requestSimpleWeather(with city: City) {
		getCoordinates(with: city) { coodinates in
			city.latitude = coodinates?.0
			city.longitude = coodinates?.1
			API.instance.requestSimpleWeather(with: city) { json in
				guard
					let data = json as? [String: Any],
					let timeZone = data["timezone"] as? String,
					let currently = data["currently"] as? [String: Any],
					let temperature = currently["temperature"] as? Double else { return }
				
				city.currentTime = Time.instance.getSimpleCurrentTime(in: timeZone)
				city.currentTemperature = String(temperature)
				self.city.value = city
			}
		}
	}
	
	func requestSimpleWeather(with city: City, resultHandler: @escaping (City) -> Void) {
		getCoordinates(with: city) { coodinates in
			city.latitude = coodinates?.0
			city.longitude = coodinates?.1
			API.instance.requestSimpleWeather(with: city) { json in
				guard
					let data = json as? [String: Any],
					let timeZone = data["timezone"] as? String,
					let currently = data["currently"] as? [String: Any],
					let temperature = currently["temperature"] as? String else { return }
				
				city.currentTime = Time.instance.getSimpleCurrentTime(in: timeZone)
				city.currentTemperature = temperature
				resultHandler(city)
			}
		}
	}
	
	func requestSimpleWeatherList(with cityList: [City]) {
		simpleWeatherList.value.removeAll()
		cityList.forEach {
			requestSimpleWeather(with: $0)
		}
	}
	
	func getCoordinates(with city: City, resultHandler: @escaping ((Double,Double)?) -> Void) {
		var localSearchRequest: MKLocalSearch.Request!
		var localSearch: MKLocalSearch!
		
		localSearchRequest = MKLocalSearch.Request()
		localSearchRequest.naturalLanguageQuery = city.name
		localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.start { (localSearchResponse, error) -> Void in
			if localSearchResponse == nil {
				resultHandler(nil)
				return
			}
			resultHandler((localSearchResponse!.boundingRegion.center.latitude, localSearchResponse!.boundingRegion.center.longitude))
		}
	}
	
}
