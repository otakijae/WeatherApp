import UIKit
import MapKit

class SearchMapViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?

	private let manager = CLLocationManager()
	private var search: MKLocalSearch? =  nil
	private var searchCompleter = MKLocalSearchCompleter()
	private var places = [MKLocalSearchCompletion]()

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.searchBar.delegate = self
		
		self.manager.delegate = self
		self.searchCompleter.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func dismiss(_ sender: Any) {
		view.endEditing(true)
		dismiss(animated: true)
	}
	
}

extension SearchMapViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return view.frame.height / 12
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return places.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = places[indexPath.item].title
		let search = MKLocalSearch(request: request)
		search.start { (response, error) in
			
			guard
				error == nil,
				let response = response,
				response.mapItems.count > 0,
				let item = response.mapItems.first else { return }
			
			var savedCityList = UserDefaults.standard.array(forKey: "CityList") as? [String] ?? []
			if let selectedCity = item.placemark.locality {
				savedCityList.append(selectedCity)
			} else {
				guard let cityName = item.placemark.name else { return }
				savedCityList.append(cityName)
			}
			UserDefaults.standard.set(savedCityList, forKey: "CityList")
			UserDefaults.standard.synchronize()
			
			tableView.deselectRow(at: indexPath, animated: true)
			self.dismiss(self)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureSearchedCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureSearchedCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCityCell.className, for: indexPath) as? SearchedCityCell else { return UITableViewCell() }
		cell.cityNameLabel.text = places[indexPath.item].title
		cell.addressLabel.text = places[indexPath.item].subtitle
		return cell
	}
	
}

extension SearchMapViewController: MKLocalSearchCompleterDelegate {
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		places = completer.results
		tableView.reloadData()
	}
	
	func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
		print("검색 결과가 없습니다")
	}
	
}

extension SearchMapViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchCompleter.queryFragment = searchText
		searchCompleter.filterType = .locationsOnly
	}
	
}

extension SearchMapViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		manager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

	}
	
}
