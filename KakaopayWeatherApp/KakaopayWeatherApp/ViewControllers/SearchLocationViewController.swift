import UIKit
import MapKit

class SearchLocationViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var cityList: [MKMapItem] = []
	
	var savedCityList: [City] {
		get {
			guard
				let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.cityList.rawValue) as? Data,
				let list = try? JSONDecoder().decode([City].self, from: data) else { return [] }
			return list
		}
		set {
			guard let encoded = try? JSONEncoder().encode(newValue) else { return }
			UserDefaults.standard.set(encoded, forKey: Constants.UserDefaultsKey.cityList.rawValue)
			UserDefaults.standard.synchronize()
		}
	}

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func dismiss(_ sender: Any) {
		view.endEditing(true)
		dismiss(animated: true)
	}
	
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return view.frame.height / 12
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cityList.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		saveSelectedCity(indexPath: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
		startIndicator()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
			self.stopIndicator()
			self.dismiss(self)
		}
	}
	
	func saveSelectedCity(indexPath: IndexPath) {
		if let selectedCityName = cityList[indexPath.item].placemark.locality {
			let city = City()
			city.name = selectedCityName
			LocationModule.instance.getCoordinates(with: city) { coordinates in
				city.latitude = coordinates?.0
				city.longitude = coordinates?.1
				var newCityList = self.savedCityList
				newCityList.append(city)
				self.savedCityList = newCityList
			}
		} else {
			guard let cityName = cityList[indexPath.item].placemark.name else { return }
			let city = City()
			city.name = cityName
			LocationModule.instance.getCoordinates(with: city) { coordinates in
				city.latitude = coordinates?.0
				city.longitude = coordinates?.1
				var newCityList = self.savedCityList
				newCityList.append(city)
				self.savedCityList = newCityList
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureSearchedCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureSearchedCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCityCell.className, for: indexPath) as? SearchedCityCell else { return UITableViewCell() }
		cell.cityNameLabel.text = cityList[indexPath.item].placemark.name
		cell.addressLabel.text = cityList[indexPath.item].placemark.title
		return cell
	}
	
}

extension SearchLocationViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		LocationModule.instance.requestLocations(query: searchBar.text) { result in
			self.cityList = result
			self.tableView.reloadData()
		}
	}
	
}
