import UIKit
import MapKit

class SearchMapViewController: UIViewController, ObserverProtocol, UISearchBarDelegate {
	
	var id = String(describing: self)
	var viewModel: ViewModel?

	var searchController: UISearchController!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var cityList: [MKMapItem] = []
	
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
		let localSearchRequest: MKLocalSearch.Request = MKLocalSearch.Request()
		var localSearch: MKLocalSearch!
		
		searchBar.resignFirstResponder()
		
		localSearchRequest.naturalLanguageQuery = searchBar.text
		localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.start { (localSearchResponse, error) -> Void in
			
			if localSearchResponse == nil {
				self.alert(message: "검색된 도시가 없습니다.", okTitle: "확인")
				return
			}
			
			localSearchResponse?.mapItems.forEach {
				print($0.name)
				print($0.placemark.title)
				print($0.placemark.locality)
			}
			
			guard let mapItems = localSearchResponse?.mapItems else { return }
			self.cityList = mapItems
			self.tableView.reloadData()
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
		guard let selectedCity = cityList[indexPath.item].placemark.locality else { return }
		var savedCityList = UserDefaults.standard.array(forKey: "CityList") as? [String] ?? []
		savedCityList.append(selectedCity)
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
		cell.cityNameLabel.text = cityList[indexPath.item].placemark.title
		return cell
	}
	
}
