import Foundation

class API: HttpHelper {
	
	static let instance = API()
	
	func requestSimpleWeather(with city: City, resultHandler: @escaping (Any) -> Void) {
		guard let latitude = city.latitude, let longitude = city.longitude else { return }
		let url = URL(string: "\(URLs.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		let parameters = ["units": "si",
											"lang": "ko",
											//"time": WeatherModule.instance.getCurrentTimeZone(),
											"exclude": "minutely,daily,hourly,alerts,flags"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if	let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				resultHandler(jsonToArray)
			}
		})
	}
	
	func requestFullWeather(with city: City, resultHandler: @escaping (Any) -> Void) {
		let url = URL(string: "\(URLs.baseURL)/\(HttpHelper.accessToken)/\(city.latitude!),\(city.longitude!)")!
		let parameters = ["units": "si",
											"lang": "ko"]
		get(url: url, parameters: parameters, completionHandler: { data, response, error in
			guard error == nil else { return }
			if	let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
				resultHandler(jsonToArray)
			}
		})
	}
	
}

class HttpHelper {
	
	static var accessToken: String {
		get {
			if let accessToken = UserDefaults.standard.string(forKey: "AccessToken") {
				return "\(accessToken)"
			} else {
				return "d5a050a57a21064809f5a3946ab02436"
			}
		}
		set {
			UserDefaults.standard.setValue(accessToken, forKey: "AccessToken")
			UserDefaults.standard.synchronize()
		}
	}
	
	enum HTTPMethod: String {
		case post = "POST"
		case get = "GET"
		case put = "PUT"
		case delete = "DELETE"
	}
	
	let session: URLSession = URLSession.shared
	
	func get(url: URL, parameters: [String: Any]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		if let parameters = parameters {
			request.url = URL(string:"\(url)\(getParameterString(parameters: parameters))")
		}
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func post(url: URL, parameters: [String: Any]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		if let parameters = parameters {
			request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
		}
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func put(url: URL, parameters: [String: Any]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.put.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		if let parameters = parameters {
			request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
		}
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func delete(url: URL, parameters: [String: Any]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.delete.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func getParameterString(parameters: [String: Any]? = nil) -> String {
		guard let parameters = parameters else { return "" }
		var urlValues = [String]()
		parameters.forEach { (key: String, value: Any) in
			guard let value = value as? String else { return }
			if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
				urlValues.append(key + "=" + encodedValue)
			}
		}
		let firstValue = urlValues.removeFirst()
		return urlValues.reduce("?\(firstValue)") { return $0 + "&" + $1 }
	}
	
}
