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
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.searchBar.delegate = self
		hideKeyboardWhenTappedAround()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
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
			
			print(localSearchResponse!.boundingRegion.center.latitude)
			print(localSearchResponse!.boundingRegion.center.longitude)
			
			self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
			self.mapView.centerCoordinate = self.pointAnnotation.coordinate
			self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		self.view.endEditing(true)
		self.tableView.resignFirstResponder()
		self.searchBar.resignFirstResponder()
	}

	@IBAction func dismiss(_ sender: Any) {
		view.endEditing(true)
		dismiss(animated: true)
	}
	
}

extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func hideKeyboard() {
		view.endEditing(true)
	}
	
}
