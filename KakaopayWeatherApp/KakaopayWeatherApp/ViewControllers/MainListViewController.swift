import UIKit

class MainListViewController: UIViewController {
		
	var viewModel: ViewModel?
	var vcList: [String] = []
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		guard let viewModel = viewModel else { return }
		addObservers(to: viewModel)
		
		viewModel.requestWeather()
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
		self.show(DetailWeatherViewController.instance, sender: self)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
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
