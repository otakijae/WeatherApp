import Foundation

class API: HttpHelper {
	
	static let instance = API()
	
	func requestWeather(latitude: Double, longitude: Double, resultHandler: @escaping (Any) -> Void) {
		let url = URL(string: "\(URLs.baseURL)/\(HttpHelper.accessToken)/\(latitude),\(longitude)")!
		get(url: url, completionHandler: { data, response, error in
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
		case patch = "PATCH"
		case delete = "DELETE"
	}
	
	let session: URLSession = URLSession.shared
	
	func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func put(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.put.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func patch(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.patch.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	func delete(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.delete.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		session.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
}
