import Foundation
import MapKit

class WeatherModule {
	
	static let instance = WeatherModule()
	
	var city: Observable<City> = Observable<City>(value: City())
	var cityList: Observable<[City]> = Observable<[City]>(value: [])
	var cityWeather: Observable<City> = Observable<City>(value: City())
	var dailyWeatherList: Observable<[Daily]> = Observable<[Daily]>(value: [])
	var hourlyWeatherList: Observable<[Hourly]> = Observable<[Hourly]>(value: [])
	var discoveredDailyWeatherList: [Daily] = []
	var discoveredHourlyWeatherList: [Daily] = []
	
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
	
	func requestDailyWeather(with city: City) {
		getCoordinates(with: city) { coodinates in
			city.latitude = coodinates?.0
			city.longitude = coodinates?.1
			API.instance.requestDailyWeather(with: city) { json in
				self.discoveredDailyWeatherList.removeAll()
				guard
					let data = json as? [String: Any],
					let timeZone = data["timezone"] as? String,
					let daily = data["daily"] as? [String: Any],
					let dailyData = daily["data"] as? [Any] else { return }
				
				dailyData.forEach {
					guard
						let result = $0 as? [String: Any],
						let time = result["time"] as? Double,
						let icon = result["icon"] as? String,
						let temperatureMax = result["temperatureMax"] as? Double,
						let temperatureMin = result["temperatureMin"] as? Double else { return }
					
					let daily = Daily()
					daily.dayOfWeek = Time.instance.getDayOfWeek(from: time, in: timeZone)
					daily.icon = icon
					daily.temperatureMax = temperatureMax
					daily.temperatureMin = temperatureMin
					self.discoveredDailyWeatherList.append(daily)
				}
				self.dailyWeatherList.value = self.discoveredDailyWeatherList				
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
