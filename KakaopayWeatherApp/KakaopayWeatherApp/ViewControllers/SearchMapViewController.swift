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
	
	var cityList: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.searchBar.delegate = self
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
			print(localSearchResponse?.mapItems.first?.name)
			
			if localSearchResponse == nil {
				self.alert(message: "검색된 도시가 없습니다.", okTitle: "확인", okAction: { [unowned self] in
					self.dismiss(self)
				})
				return
			}
			
			self.cityList.removeAll()
			self.cityList.append(searchBar.text!)
			self.tableView.reloadData()
			
			self.pointAnnotation = MKPointAnnotation()
			self.pointAnnotation.title = searchBar.text
			self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
			
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

extension SearchMapViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return view.frame.height / 10
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cityList.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var savedCityList = UserDefaults.standard.array(forKey: "CityList") as? [String] ?? []
		savedCityList.append(cityList[indexPath.item])
		UserDefaults.standard.set(savedCityList, forKey: "CityList")
		UserDefaults.standard.synchronize()
		
		tableView.deselectRow(at: indexPath, animated: true)
		self.dismiss(self)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureSearchedCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureSearchedCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCityCell.className, for: indexPath) as? SearchedCityCell else { return UITableViewCell() }
		cell.cityNameLabel.text = cityList[indexPath.item]
		return cell
	}
	
}
