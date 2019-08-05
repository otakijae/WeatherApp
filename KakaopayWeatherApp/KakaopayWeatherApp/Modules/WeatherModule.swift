import Foundation
import MapKit

class WeatherModule {
	
	static let instance = WeatherModule()
	
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var cityWeather: Observable<City> = Observable<City>(value: City())
	
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
					let icon = currently["icon"] as? String,
					let temperature = currently["temperature"] as? Double,
					let summary = currently["summary"] as? String,
					let time = currently["time"] as? Double,
					
					let precipitationProbability = currently["precipIntensity"] as? Double,
					let humidity = currently["humidity"] as? Double,
					let windSpeed = currently["windSpeed"] as? Double,
					let apparentTemperature = currently["apparentTemperature"] as? Double,
					let precipitationIntensity = currently["precipIntensity"] as? Double,
					let pressure = currently["pressure"] as? Double,
					let visibility = currently["visibility"] as? Double,
					let uvIndex = currently["uvIndex"] as? Double,
					
					let daily = data["daily"] as? [String: Any],
					let dailyData = daily["data"] as? [Any],
					let firstDailyData = dailyData.first as? [String: Any],
					let temperatureMax = firstDailyData["temperatureMax"] as? Double,
					let temperatureMin = firstDailyData["temperatureMin"] as? Double,
					let sunriseTime = firstDailyData["sunriseTime"] as? Double,
					let sunsetTime = firstDailyData["sunsetTime"] as? Double else { return }
				
				let weather = Weather()
				
				weather.timeZone = timeZone
				weather.icon = icon
				weather.summary = summary
				
				weather.temperatureMax = temperatureMax
				weather.temperatureMin = temperatureMin
				weather.sunriseTime = Time.instance.getSimpleStringTime(from: sunriseTime)
				weather.sunsetTime = Time.instance.getSimpleStringTime(from: sunsetTime)
				
				weather.precipitationProbability = precipitationProbability
				weather.humidity = humidity
				weather.windSpeed = windSpeed
				weather.apparentTemperature = apparentTemperature
				weather.precipitationIntensity = precipitationIntensity
				weather.pressure = pressure
				weather.visibility = visibility
				weather.uvIndex = uvIndex
				
				city.weather = weather
				city.specificTime = Time.instance.getCurrentTime(in: timeZone)
				city.currentTime = Time.instance.getSimpleCurrentTime(in: timeZone)
				city.dayOfWeek = Time.instance.getDayOfWeek(from: time, in: timeZone)
				city.currentTemperature = String(temperature)
				
				self.cityWeather.value = city
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
