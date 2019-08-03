import UIKit

class MainListViewController: UIViewController, ObserverProtocol {
	
	var id = String(describing: self)
	var viewModel: ViewModel?
	var savedCityList: [String] {
		get {
			return UserDefaults.standard.stringArray(forKey: "CityList") ?? ["서울", "뉴욕", "안양", "퀸즈타운", "웰링턴", "부산"]
		}
		set {
			UserDefaults.standard.set(savedCityList, forKey: "CityList")
			UserDefaults.standard.synchronize()
		}
	}
	var cityList: [City] = []
	
	var rightEditButton = UIBarButtonItem()
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		configureRightEditButton()
		configureCityList()
		
		guard let viewModel = viewModel else { return }
		subscribe(viewModel)
	}
	
	func subscribe(_ viewModel: ViewModel) {
		
		viewModel.city.addObserver(self) { city in
			self.cityList.append(city)
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		
		viewModel.cityList.addObserver(self) { cityList in
			print("MainList")
			print(cityList)
		}
		
	}
	
	func configureCityList() {
		savedCityList.forEach {
			let city = City()
			city.name = $0
			cityList.append(city)
			
			guard let viewModel = viewModel else { return }
			viewModel.requestSimpleWeather(with: city)
		}
		cityList.removeAll()
	}
	
	func configureRightEditButton() {
		rightEditButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonAction))
		self.navigationItem.rightBarButtonItem = rightEditButton
		self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
		//rightEditButton.isEnabled = !remocon.remoconReservations.isEmpty
	}
	
	@objc func editButtonAction() {
		setEditing(!tableView.isEditing, animated: true)
		if !tableView.isEditing {
			//requestList()
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
		return view.frame.height / 6
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
		guard let temperature = cityList[indexPath.item].currentTemperature else { return cell }
		cell.temperatureLabel.text = temperature
		return cell
	}
	
}
