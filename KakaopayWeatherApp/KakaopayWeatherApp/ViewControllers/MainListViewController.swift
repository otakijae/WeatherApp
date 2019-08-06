import UIKit

class MainListViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var cityList: [City] = []

	@IBOutlet weak var descriptionView: UIView!
	var refreshControl = UIRefreshControl()
	var rightEditButton = UIBarButtonItem()
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
			tableView.addSubview(refreshControl)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self

		guard let viewModel = viewModel else { return }
		subscribe(viewModel)
		viewModel.requestNetworkConnectionStatus()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		refreshAction()
	}
	
	func subscribe(_ viewModel: ViewModel) {
		
		viewModel.networkDisconnected.addObserver(self) { _ in
			self.alert(message: Constants.networkAlertMessage)
		}
		
		viewModel.city.addObserver(self) { city in
			self.cityList.filter { $0.name == city.name }.first?.currentTime = city.currentTime
			self.cityList.filter { $0.name == city.name }.first?.currentTemperature = city.currentTemperature
			self.refreshTableView()
		}
		
		viewModel.cityList.addObserver(self) { cityList in
			self.cityList = cityList
		}
		
		viewModel.cityListEmpty.addObserver(self) { _ in
			self.tableView.isHidden = true
			self.descriptionView.isHidden = false
			self.refreshTableView()
		}
		
		viewModel.cityListExists.addObserver(self) { _ in
			self.tableView.isHidden = false
			self.descriptionView.isHidden = true
			self.refreshTableView()
		}
		
	}
	
	func refreshTableView() {
		DispatchQueue.main.async {
			self.configureRightEditButton()
			self.tableView.reloadData()
		}
	}
	
	@objc func refreshAction() {
		guard let viewModel = viewModel else { return }
		viewModel.configureCityList()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.refreshControl.endRefreshing()
		}
	}
	
	func configureRightEditButton() {
		rightEditButton = UIBarButtonItem(title: Constants.edit, style: .plain, target: self, action: #selector(editButtonAction))
		navigationItem.rightBarButtonItem = rightEditButton
		navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
		rightEditButton.isEnabled = !cityList.isEmpty
	}
	
	@objc func editButtonAction() {
		setEditing(!tableView.isEditing, animated: true)
		if !tableView.isEditing { refreshAction() }
		rightEditButton.title = tableView.isEditing ? Constants.complete : Constants.edit
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		tableView.setEditing(editing, animated: animated)
	}
	
	@IBAction func addCityButtonTapped(_ sender: Any) {
		presentSearchLocationViewController()
	}
	
	func presentSearchLocationViewController() {
		guard
			let viewModel = viewModel,
			let searchLocationViewController = SearchLocationViewController.instance as? SearchLocationViewController else { return }
		searchLocationViewController.viewModel = viewModel
		present(searchLocationViewController, animated: true)
	}
	
	func showDetailWeatherViewController(with city: City) {
		guard
			let viewModel = viewModel,
			let detailWeatherViewController = DetailWeatherViewController.instance as? DetailWeatherViewController else { return }
		detailWeatherViewController.selectedCity = city
		detailWeatherViewController.viewModel = viewModel
		show(detailWeatherViewController, sender: self)
	}
}

extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return view.frame.height / 7
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cityList.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		showDetailWeatherViewController(with: cityList[indexPath.item])
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			cityList.remove(at: indexPath.item)
			guard let viewModel = viewModel else { return }
			viewModel.savedCityList.remove(at: indexPath.item)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			if cityList.isEmpty {
				editButtonAction()
				refreshAction()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.className, for: indexPath) as? CityCell else { return UITableViewCell() }
		cell.city = cityList[indexPath.item]
		return cell
	}
	
}
