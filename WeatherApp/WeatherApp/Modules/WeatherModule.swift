import Foundation

class WeatherModule {
	
	static let instance = WeatherModule()
	
	var city = Observable<City>(value: City())
	var cityWeather = Observable<City>(value: City())
	var dailyWeatherList = Observable<[Daily]>(value: [])
	var hourlyWeatherList = Observable<[Hourly]>(value: [])
	var discoveredDailyWeatherList: [Daily] = []
	var discoveredHourlyWeatherList: [Hourly] = []
	
	func requestSimpleWeather(with city: City, in group: DispatchGroup) {
		group.enter()
		API.instance.requestSimpleWeather(with: city) { json in
			guard
				let data = json as? [String: Any],
				let timeZone = data["timezone"] as? String,
				let currently = data["currently"] as? [String: Any],
				let temperature = currently["temperature"] as? Double else { return }

			city.time = TimeModule.instance.getCurrentTime(in: timeZone)
			city.temperature = "\(Int(round(temperature)))"
			self.city.value = city
			group.leave()
		}
	}
	
	func requestSpecificWeather(with city: City, in group: DispatchGroup) {
		group.enter()
		API.instance.requestSpecificWeather(with: city) { (json, weather) in
			guard
				let data = json as? [String: Any],
				let timeZone = data["timezone"] as? String,
				let currently = data["currently"] as? [String: Any],
				let temperature = currently["temperature"] as? Double,
				let time = currently["time"] as? Double,
				
				let daily = data["daily"] as? [String: Any],
				let dailyData = daily["data"] as? [Any],
				let firstDailyData = dailyData.first as? [String: Any],
				let temperatureMax = firstDailyData["temperatureMax"] as? Double,
				let temperatureMin = firstDailyData["temperatureMin"] as? Double,
				let sunriseTime = firstDailyData["sunriseTime"] as? Double,
				let sunsetTime = firstDailyData["sunsetTime"] as? Double else { return }
			
			weather.temperatureMax = temperatureMax
			weather.temperatureMin = temperatureMin
			weather.sunriseTime = TimeModule.instance.getStringTime(from: sunriseTime)
			weather.sunsetTime = TimeModule.instance.getStringTime(from: sunsetTime)
			
			city.weather = weather
			city.time = TimeModule.instance.getCurrentTime(in: timeZone)
			city.dayOfWeek = TimeModule.instance.getDayOfWeek(from: time, in: timeZone)
			city.temperature = String(temperature)
			
			self.cityWeather.value = city
			group.leave()
		}
	}
	
	func requestDailyWeather(with city: City, in group: DispatchGroup) {
		group.enter()
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
					let summary = result["summary"] as? String,
					let temperatureMax = result["temperatureMax"] as? Double,
					let temperatureMin = result["temperatureMin"] as? Double else { return }
				
				let daily = Daily()
				daily.dayOfWeek = TimeModule.instance.getDayOfWeek(from: time, in: timeZone)
				daily.icon = icon
				daily.summary = summary
				daily.temperatureMax = "\(round(temperatureMax))" + "°"
				daily.temperatureMin = "\(round(temperatureMin))" + "°"
				self.discoveredDailyWeatherList.append(daily)
			}
			self.dailyWeatherList.value = self.discoveredDailyWeatherList
			group.leave()
		}
	}
	
	func requestHourlyWeather(with city: City, in group: DispatchGroup) {
		group.enter()
		API.instance.requestHourlyWeather(with: city) { json in
			self.discoveredDailyWeatherList.removeAll()
			guard
				let data = json as? [String: Any],
				let timeZone = data["timezone"] as? String,
				let hourly = data["hourly"] as? [String: Any],
				let hourlyData = hourly["data"] as? [Any] else { return }
			
			hourlyData.forEach {
				guard
					let result = $0 as? [String: Any],
					let time = result["time"] as? Double,
					let icon = result["icon"] as? String,
					let summary = result["summary"] as? String,
					let temperature = result["temperature"] as? Double else { return }
				
				let hourly = Hourly()
				hourly.time = TimeModule.instance.getStringTime(from: time, in: timeZone, dateFormat: "a hh시")
				hourly.icon = icon
				hourly.summary = summary
				hourly.temperature = temperature
				self.discoveredHourlyWeatherList.append(hourly)
			}
			self.hourlyWeatherList.value = self.discoveredHourlyWeatherList
			group.leave()
		}
	}
	
}
