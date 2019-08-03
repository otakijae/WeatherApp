import UIKit

class MainListViewController: UIViewController {
		
	var viewModel: ViewModel?
	var vcList: [String] = []
	
	var rightEditButton = UIBarButtonItem()
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		setupRightEditButton()
		
		guard let viewModel = viewModel else { return }
		addObservers(to: viewModel)
		
		viewModel.requestWeather()
	}
	
	func setupRightEditButton() {
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
	
	func addObservers(to viewModel: ViewModel) {
		viewModel.addObserver(self)
	}
	
	@IBAction func addCityButtonTapped(_ sender: Any) {
		self.present(SearchMapViewController.instance, animated: true)
	}
}

extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.show(DetailWeatherViewController.instance, sender: self)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureCityCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureCityCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.className, for: indexPath) as? CityCell else { return UITableViewCell() }
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
}

extension MainListViewController: Observer {
	
	func update(_ list: [String]) {
		vcList = list
		alert(message: "\(vcList)",
			okTitle: "네",
			okAction: { [unowned self] in
				self.show(DetailWeatherViewController.instance, sender: self)
		})
	}
	
	func update(_ json: Any) {
//		print("### TEST ... MainListViewController")
//		print(json)
	}
	
}
