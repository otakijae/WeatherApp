import Foundation

class HttpHelper {
	
	static let baseURL = "https://api.darksky.net/forecast"
	static var accessToken = "d5a050a57a21064809f5a3946ab02436"
	let session: URLSession = URLSession.shared

	enum HTTPMethod: String {
		case post = "POST"
		case get = "GET"
		case put = "PUT"
		case delete = "DELETE"
	}
	
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
