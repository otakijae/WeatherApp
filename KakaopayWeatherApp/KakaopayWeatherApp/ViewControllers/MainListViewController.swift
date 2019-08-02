import UIKit

class MainListViewController: UIViewController, Observer {
		
	var viewModel: ViewModel?
	var vcList: [String] = []
		
	@IBOutlet weak var button: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		API.instance.requestWeather(latitude: 42.3601, longitude: -71.0589) { json in
			print(json)
		}
		
		guard let viewModel = viewModel else { return }
		addObservers(to: viewModel)
		viewModel.add()
	}
		
	func update(_ list: [String]) {
		vcList = list
		alert(message: "\(vcList)",
			okTitle: "네",
			okAction: { [unowned self] in
				self.present(SearchMapViewController.instance, animated: true)
		})
	}
		
	func addObservers(to viewModel: ViewModel) {
		viewModel.addObserver(self)
	}
	
	@IBAction func test(_ sender: Any) {
		self.present(SearchMapViewController.instance, animated: true)
	}
	
}
