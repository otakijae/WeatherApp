import Foundation

class API: HttpHelper {
	
	static let instance = API()
	
	func requestSimpleWeather(with city: City, resultHandler: @escaping (Any) -> Void) {
		guard let latitude = city.latitude, let longitude = city.longitude else { return }
		let url = URL(string: "\(HttpHelper.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		let parameters = ["units": "si",
											"lang": "ko",
											"exclude": "minutely,daily,hourly,alerts,flags"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				resultHandler(jsonToArray)
			}
		})
	}
	
	func requestSpecificWeather(with city: City, resultHandler: @escaping ((Any, Weather)) -> Void) {
		guard let latitude = city.latitude, let longitude = city.longitude else { return }
		let url = URL(string: "\(HttpHelper.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		let parameters = ["units": "si",
											"lang": "ko",
											"exclude": "minutely,hourly,alerts,flags"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				let decoder = JSONDecoder()
				guard let darkSkyResponse = try? decoder.decode(DarkSky.self, from: data) else { return }
				resultHandler((jsonToArray, darkSkyResponse.currently))
			}
		})
	}
	
	func requestDailyWeather(with city: City, resultHandler: @escaping (Any) -> Void) {
		guard let latitude = city.latitude, let longitude = city.longitude else { return }
		let url = URL(string: "\(HttpHelper.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		let parameters = ["units": "si",
											"lang": "ko",
											"exclude": "currently,hourly,minutely,alerts,flags"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				resultHandler(jsonToArray)
			}
		})
	}
	
	func requestHourlyWeather(with city: City, resultHandler: @escaping (Any) -> Void) {
		guard let latitude = city.latitude, let longitude = city.longitude else { return }
		let url = URL(string: "\(HttpHelper.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		let parameters = ["units": "si",
											"lang": "ko",
											"exclude": "currently,daily,minutely,alerts,flags"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				resultHandler(jsonToArray)
			}
		})
	}
	
}
