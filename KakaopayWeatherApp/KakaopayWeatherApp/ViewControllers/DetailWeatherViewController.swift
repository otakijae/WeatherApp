import UIKit
import SafariServices

class DetailWeatherViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var selectedCity: City?
	var refreshControl = UIRefreshControl()

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
			tableView.addSubview(refreshControl)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.tintColor = .darkGray
		tableView.delegate = self
		tableView.dataSource = self
		
		guard let viewModel = viewModel else { return }
		subscribe(viewModel)
		viewModel.requestDetailWeathers(with: selectedCity)
	}
	
	func subscribe(_ viewModel: ViewModel) {
		
		viewModel.cityWeather.addObserver(self) { [weak self] cityWeather in
			self?.selectedCity = cityWeather
		}
		
		viewModel.dailyWeatherList.addObserver(self) { [weak self] dailyWeatherList in
			self?.selectedCity?.dailyWeatherList = dailyWeatherList
		}
		
		viewModel.hourlyWeatherList.addObserver(self) { [weak self] hourlyWeatherList in
			self?.selectedCity?.hourlyWeatherList = hourlyWeatherList
		}
		
		viewModel.responseNotify.addObserver(self) { [weak self] in
			self?.refreshTableView()
		}
		
	}
	
	func refreshTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	@objc func refreshAction() {
		DispatchQueue.global(qos: .userInitiated).async {
			guard let viewModel = self.viewModel else { return }
			viewModel.requestDetailWeathers(with: self.selectedCity)
			DispatchQueue.main.async {
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	@IBAction func linkToAPIWebPage(_ sender: Any) {
		let url = URL(string: Constants.apiLink)!
		
		if #available(iOS 9.0, *) {
			present(SFSafariViewController(url: url), animated: true)
		}
	}
	
}

extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
	
	enum CellType: Int {
		case currently = 0
		case hourly = 1
		case daily = 2
		case other = 3
	}
	
	func getIdentifier(type: CellType) -> String {
		switch type {
		case .currently:
			return CurrentlyWeatherCell.className
		case .hourly:
			return HourlyWeatherCell.className
		case .daily:
			return DailyWeatherCell.className
		case .other:
			return OtherWeatherCell.className
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.item {
		case CellType.currently.rawValue:
			return 240
		case CellType.hourly.rawValue:
			return 150
		case CellType.daily.rawValue:
			return 240
		case CellType.other.rawValue:
			return 270
		default:
			return 240
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Constants.numberOfCells
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureWeatherCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard
			let type = CellType(rawValue: indexPath.item),
			let cell = tableView.dequeueReusableCell(withIdentifier: getIdentifier(type: type), for: indexPath) as? WeatherCell else { return UITableViewCell() }
		cell.selectedCity = selectedCity
		return cell
	}
	
}
