import Foundation
import MapKit

class WeatherModule {
	
	static let instance = WeatherModule()
	
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var simpleWeatherList: [City] = []
	
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
	
	func requestSpecificWeather(with city: City) {
		getCoordinates(with: city) { coodinates in
			city.latitude = coodinates?.0
			city.longitude = coodinates?.1
			API.instance.requestSpecificWeather(with: city) { json in
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
	
	func requestFullWeather(with city: City) {
		getCoordinates(with: city) { coodinates in
			city.latitude = coodinates?.0
			city.longitude = coodinates?.1
			API.instance.requestFullWeather(with: city) { json in
				print(json)
			}
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
