import UIKit

class CityCell: UITableViewCell {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
}

class SearchedCityCell: UITableViewCell {
	@IBOutlet weak var cityNameLabel: UILabel!
}
