import Foundation

class HttpHelper {
	
	let session: URLSession = URLSession.shared
	static let baseURL = "https://api.darksky.net/forecast"
	static let accessToken = "d5a050a57a21064809f5a3946ab02436"

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
	
	fileprivate func getParameterString(parameters: [String: Any]? = nil) -> String {
		guard let parameters = parameters else { return "" }
		var urlValues = [String]()
		parameters.forEach { (key: String, value: Any) in
			guard let value = value as? String else { return }
			if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
				urlValues.append(key + "=" + encodedValue)
			}
		}
		let firstValue = urlValues.removeFirst()
		return urlValues.reduce("?\(firstValue)") { return $0 + "&" + $1 }
	}
	
}
