import UIKit
import MapKit

class SearchMapViewController: UIViewController, UISearchBarDelegate {

	var searchController: UISearchController!
	var annotation: MKAnnotation!
	var localSearchRequest: MKLocalSearch.Request!
	var localSearch: MKLocalSearch!
	var localSearchResponse: MKLocalSearch.Response!
	var error: NSError!
	var pointAnnotation: MKPointAnnotation!
	var pinAnnotationView: MKPinAnnotationView!
	
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController = UISearchController(searchResultsController: nil)
		searchController.hidesNavigationBarDuringPresentation = false
		self.searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
		dismiss(animated: true, completion: nil)
		if self.mapView.annotations.count != 0{
			annotation = self.mapView.annotations[0]
			self.mapView.removeAnnotation(annotation)
		}
		
		localSearchRequest = MKLocalSearch.Request()
		localSearchRequest.naturalLanguageQuery = searchBar.text
		localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.start { (localSearchResponse, error) -> Void in
			
			print(localSearchResponse?.mapItems.count)
			localSearchResponse?.mapItems.forEach { print($0) }
			
			if localSearchResponse == nil {
				let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertController.Style.alert)
				alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
				self.present(alertController, animated: true, completion: nil)
				return
			}
			
			self.pointAnnotation = MKPointAnnotation()
			self.pointAnnotation.title = searchBar.text
			self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
			
			
			self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
			self.mapView.centerCoordinate = self.pointAnnotation.coordinate
			self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
		}
	}

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}
	
	
}
