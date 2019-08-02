import UIKit

class DetailWeatherViewController: UIViewController {
	
	var viewModel: ViewModel?
	var vcList: [String] = []

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.navigationBar.tintColor = .darkGray

		tableView.delegate = self
		tableView.dataSource = self
		
		guard let viewModel = viewModel else { return }
		addObservers(to: viewModel)
		
		viewModel.requestWeather()
	}
	
	func addObservers(to viewModel: ViewModel) {
		viewModel.addObserver(self)
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
			return 200
		case CellType.hourly.rawValue:
			return 150
		case CellType.daily.rawValue:
			return 200
		case CellType.other.rawValue:
			return 200
		default:
			return 200
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
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
		cell.editingAccessoryType = .disclosureIndicator
		return cell
	}
	
	func configureHourlyWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherCell.className, for: indexPath) as? HourlyWeatherCell else { return UITableViewCell() }
		cell.editingAccessoryType = .disclosureIndicator
		return cell
	}
	
	func configureDailyWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.className, for: indexPath) as? DailyWeatherCell else { return UITableViewCell() }
		cell.editingAccessoryType = .disclosureIndicator
		return cell
	}
	
	func configureOtherWeatherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherWeatherCell.className, for: indexPath) as? OtherWeatherCell else { return UITableViewCell() }
		cell.editingAccessoryType = .disclosureIndicator
		return cell
	}
	
}

extension DetailWeatherViewController: Observer {
	
	func update(_ list: [String]) {
		vcList = list
		alert(message: "\(vcList)",
			okTitle: "네",
			okAction: { [unowned self] in
				self.present(SearchMapViewController.instance, animated: true)
		})
	}
	
	func update(_ json: Any) {
		//		print("### TEST ... MainListViewController")
		//		print(json)
	}
	
}
