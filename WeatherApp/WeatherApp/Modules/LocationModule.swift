import Foundation
import MapKit

class LocationModule {
	
	static let instance = LocationModule()
	
	var locationList = Observable<[MKMapItem]>(value: [])
	var selectedCity = Observable<City>(value: City())
	
	func getCoordinates(with city: City) {
		let localSearchRequest = MKLocalSearch.Request()
		localSearchRequest.naturalLanguageQuery = city.name
		let localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.start { (localSearchResponse, error) -> Void in
			if localSearchResponse == nil { return }
			city.latitude = localSearchResponse!.boundingRegion.center.latitude
			city.longitude = localSearchResponse!.boundingRegion.center.longitude
			self.selectedCity.value = city
		}
	}
	
	func getCoordinates(with city: City, resultHandler: @escaping ((Double,Double)?) -> Void) {
		let localSearchRequest = MKLocalSearch.Request()
		localSearchRequest.naturalLanguageQuery = city.name
		let localSearch = MKLocalSearch(request: localSearchRequest)
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
