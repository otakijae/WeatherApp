import Foundation

class HttpHelper {
	
	enum HTTPMethod: String {
		case post   = "POST"
		case get    = "GET"
		case put    = "PUT"
		case delete = "DELETE"
	}
	
	func getURLRequest(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]? = nil) -> URLRequest {
		var request = URLRequest(url: url)
		request.timeoutInterval = 10.0
		request.httpMethod = httpMethod.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//		if self.accessToken == "" {
//			self.accessToken = AccessToken.token() ?? ""
//		}
		
		//### 중요
//		request.addValue(accessToken, forHTTPHeaderField: "Authorization")
		
		guard let parameters = parameters else { return request }
		
		switch httpMethod {
		case .get:
			request.url = URL(string:"\(url)\(getParameterString(parameters: parameters))")
			
		case .post:
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			} catch let error {
				print(error)
			}
			
		case .put:
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			} catch let error {
				print(error)
			}
			
		case .delete:
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			} catch let error {
				print(error)
			}
		}
		
		return request
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
