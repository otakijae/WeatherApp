import Foundation
import MapKit

class WeatherModule: Observation {
	
	static let instance = WeatherModule()
	
	var simpleWeatherList: [City] = []
	
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
				self.notify(city)
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
				
				print(json)
				
				city.currentTime = Time.instance.getSimpleCurrentTime(in: timeZone)
				city.currentTemperature = temperature
				resultHandler(city)
			}
		}
	}
	
	func requestSimpleWeatherList(with cityList: [City], resultHandler: @escaping ([City]) -> Void) {
		simpleWeatherList.removeAll()
		let last = cityList.count
		var count = 0
		cityList.forEach {
			count+=1
			requestSimpleWeather(with: $0) { city in
				self.simpleWeatherList.append(city)
				if cityList.count == self.simpleWeatherList.count {
					resultHandler(self.simpleWeatherList)
				}
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
