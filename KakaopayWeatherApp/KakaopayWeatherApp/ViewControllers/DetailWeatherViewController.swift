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
		
		viewModel.cityWeather.addObserver(self) { cityWeather in
			self.selectedCity = cityWeather
			self.refreshTableView()
		}
		
		viewModel.dailyWeatherList.addObserver(self) { dailyWeatherList in
			self.selectedCity?.dailyWeatherList = dailyWeatherList
			self.refreshTableView()
		}
		
		viewModel.hourlyWeatherList.addObserver(self) { hourlyWeatherList in
			self.selectedCity?.hourlyWeatherList = hourlyWeatherList
			self.refreshTableView()
		}
		
	}
	
	func refreshTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	@objc func refreshAction() {
		guard let viewModel = viewModel else { return }
		viewModel.requestDetailWeathers(with: selectedCity)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.refreshControl.endRefreshing()
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
		switch indexPath.item {
		case CellType.currently.rawValue:
			return configureCurrentlyWeatherCell(tableView: tableView, indexPath: indexPath)
		case CellType.hourly.rawValue:
			return configureHourlyWeatherCell(tableView: tableView, indexPath: indexPath)
		case CellType.daily.rawValue:
			return configureDailyWeatherCell(tableView: tableView, indexPath: indexPath)
		case CellType.other.rawValue:
			return configureOtherWeatherCell(tableView: tableView, indexPath: indexPath)
		default:
			return UITableViewCell()
		}
	}
	
	func configureCurrentlyWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentlyWeatherCell.className, for: indexPath) as? CurrentlyWeatherCell else { return UITableViewCell() }
		cell.selectedCity = selectedCity
		return cell
	}
	
	func configureHourlyWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherCell.className, for: indexPath) as? HourlyWeatherCell else { return UITableViewCell() }
		cell.selectedCity = selectedCity
		return cell
	}
	
	func configureDailyWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.className, for: indexPath) as? DailyWeatherCell else { return UITableViewCell() }
		cell.selectedCity = selectedCity
		return cell
	}
	
	func configureOtherWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherWeatherCell.className, for: indexPath) as? OtherWeatherCell else { return UITableViewCell() }
		cell.selectedCity = selectedCity
		return cell
	}
	
}
