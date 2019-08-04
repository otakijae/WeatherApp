import UIKit

class MainListViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var savedCityList: [String] {
		get {
			return UserDefaults.standard.array(forKey: "CityList") as? [String] ?? ["서울"]
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "CityList")
			UserDefaults.standard.synchronize()
		}
	}
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
	}
	
	override func viewWillAppear(_ animated: Bool) {
		configureRightEditButton()
		refreshAction()
	}
	
	func subscribe(_ viewModel: ViewModel) {
		
		viewModel.city.addObserver(self) { city in
			self.cityList.filter { $0.name == city.name }.first?.currentTime = city.currentTime
			self.cityList.filter { $0.name == city.name }.first?.currentTemperature = city.currentTemperature
			DispatchQueue.main.async {
				self.configureRightEditButton()
				self.tableView.reloadData()
			}
		}
		
		viewModel.cityList.addObserver(self) { cityList in
			
		}
		
	}
	
	@objc func refreshAction() {
		guard let viewModel = viewModel else { return }
		configureCityList()
		checkEmptyCityList(viewModel)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.refreshControl.endRefreshing()
		}
	}
	
	func configureCityList() {
		cityList.removeAll()
		savedCityList.forEach {
			let city = City()
			city.name = $0
			cityList.append(city)
		}
	}
	
	func requestSimpleWeatherList(_ viewModel: ViewModel) {
		cityList.forEach {
			viewModel.requestSimpleWeather(with: $0)
		}
	}
	
	func checkEmptyCityList(_ viewModel: ViewModel) {
		if cityList.isEmpty {
			tableView.isHidden = true
			descriptionView.isHidden = false
		} else {
			tableView.isHidden = false
			descriptionView.isHidden = true
			requestSimpleWeatherList(viewModel)
		}
	}
	
	func configureRightEditButton() {
		rightEditButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonAction))
		self.navigationItem.rightBarButtonItem = rightEditButton
		self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
		rightEditButton.isEnabled = !cityList.isEmpty
	}
	
	@objc func editButtonAction() {
		setEditing(!tableView.isEditing, animated: true)
		if !tableView.isEditing {
			refreshAction()
		}
		rightEditButton.title = tableView.isEditing ? "완료" : "편집"
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		self.tableView.setEditing(editing, animated: animated)
	}
	
	@IBAction func addCityButtonTapped(_ sender: Any) {
		self.present(SearchMapViewController.instance, animated: true)
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
		self.show(DetailWeatherViewController.instance, sender: self)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			cityList.remove(at: indexPath.item)
			savedCityList.remove(at: indexPath.item)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.className, for: indexPath) as? CityCell else { return UITableViewCell() }
		cell.accessoryType = .disclosureIndicator
		cell.timeLabel.text = cityList[indexPath.item].currentTime
		cell.cityNameLabel.text = cityList[indexPath.item].name
		cell.temperatureLabel.text = cityList[indexPath.item].currentTemperature
		return cell
	}
	
}
