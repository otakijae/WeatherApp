import UIKit

class MainListViewController: UIViewController {
		
	var viewModel: ViewModel?
	var vcList: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let viewModel = viewModel else { return }
		addObservers(to: viewModel)
		viewModel.add()
		viewModel.requestWeather()
	}
	
	func addObservers(to viewModel: ViewModel) {
		viewModel.addObserver(self)
	}
	
	@IBAction func addCityButtonTapped(_ sender: Any) {
		self.present(SearchMapViewController.instance, animated: true)
	}
}

extension MainListViewController: Observer {
	
	func update(_ list: [String]) {
		vcList = list
		alert(message: "\(vcList)",
			okTitle: "네",
			okAction: { [unowned self] in
				self.present(SearchMapViewController.instance, animated: true)
		})
	}
	
	func update(_ json: Any) {
		print("### TEST ... MainListViewController")
		print(json)
	}
	
}
