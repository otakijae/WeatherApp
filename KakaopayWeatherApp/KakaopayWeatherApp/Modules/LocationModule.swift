import Foundation
import MapKit

class LocationModule {
	
	static let instance = LocationModule()
	
	var locationList = Observable<[MKMapItem]>(value: [])
	
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
	
	func requestLocations(query: String) {
		let localSearchRequest = MKLocalSearch.Request()
		localSearchRequest.naturalLanguageQuery = query
		let localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.start { (localSearchResponse, error) -> Void in
			if localSearchResponse == nil { return }
			guard let mapItems = localSearchResponse?.mapItems else { return }
			self.locationList.value = mapItems
		}
	}
	
}