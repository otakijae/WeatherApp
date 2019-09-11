import UIKit
import MapKit

class SearchLocationViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var cityList: [MKMapItem] = []

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		
		guard let viewModel = viewModel else { return }
		subscribe(viewModel)
	}
	
	func subscribe(_ viewModel: ViewModel) {
		viewModel.locationList.addObserver(self) { locationList in
			self.cityList = locationList
			self.tableView.reloadData()
		}
		
		viewModel.selectedCity.addObserver(self) { selectedCity in
			self.stopIndicator()
			self.dismiss(self)
		}
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
		startIndicator()
		tableView.deselectRow(at: indexPath, animated: true)
		guard let viewModel = self.viewModel else { return }
		viewModel.saveSelectedCity(with: self.cityList[indexPath.item])
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
		guard let viewModel = viewModel else { return }
		viewModel.requestLocations(query: searchBar.text)
	}
	
}
