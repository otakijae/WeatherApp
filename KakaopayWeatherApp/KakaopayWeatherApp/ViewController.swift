import UIKit

class ViewController: UIViewController, Observer {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let viewModel = ViewModel()
		
		viewModel.addObserver(self)
		viewModel.add()
	}
	
	var vcList: [String] = []

	func update(_ list: [String]) {
		vcList = list
		alert(message: "\(vcList)")
	}
	
	func bind() {
		
	}

}
