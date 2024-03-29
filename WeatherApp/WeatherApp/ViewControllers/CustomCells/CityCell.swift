import UIKit

class CityCell: UITableViewCell {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	var city: City? {
		didSet {
			configureCityCell()
		}
	}
	
	func configureCityCell() {
		guard let city = city else { return }
		self.accessoryType = .disclosureIndicator
		timeLabel.text = city.time
		cityNameLabel.text = city.name
		temperatureLabel.text = city.temperature
	}
}

class SearchedCityCell: UITableViewCell {
	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
}
