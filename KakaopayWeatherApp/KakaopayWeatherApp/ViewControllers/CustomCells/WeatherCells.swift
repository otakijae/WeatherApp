import UIKit

class CurrentlyWeatherCell: UITableViewCell {

	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var temperatureMinLabel: UILabel!
	@IBOutlet weak var temperatureMaxLabel: UILabel!
	
}

class HourlyWeatherCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
	var selectedCity: City? {
		didSet {
			collectionView.reloadData()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		collectionViewFlowLayout.scrollDirection = .horizontal
		collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 140)
		collectionViewFlowLayout.minimumLineSpacing = 2.0
		collectionViewFlowLayout.minimumInteritemSpacing = 5.0
		
		collectionView.dataSource = self
		collectionView.delegate = self
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 9
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = self.collectionView.frame.width
		let height = self.collectionView.frame.height
		return CGSize(width: width/4 - 10, height: height - 1)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as UICollectionViewCell
		
		switch indexPath.row {
		case 0:
			cell.backgroundColor = .pastelRed
		case 1:
			cell.backgroundColor = .pastelApricot
		case 2:
			cell.backgroundColor = .pastelYellow
		case 3:
			cell.backgroundColor = .pastelGreen
		case 4:
			cell.backgroundColor = .pastelSkyblue
		case 5:
			cell.backgroundColor = .pastelBlue
		case 6:
			cell.backgroundColor = .pastelLightpurple
		case 7:
			cell.backgroundColor = .pastelPurple
		default:
			cell.backgroundColor = .pastelDarkGray
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
	
}

class HourlyCollectionViewCell: UICollectionViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
}

class DailyWeatherCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	var selectedCity: City? {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let selectedCity = selectedCity else { return 0 }
		return selectedCity.dailyWeatherList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return configureDailyTableViewCell(tableView: tableView, indexPath: indexPath)
	}
	
	func configureDailyTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.className, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
		cell.dayOfWeekLabel.text = selectedCity?.dailyWeatherList[indexPath.item].dayOfWeek
		cell.statusLabel.text = selectedCity?.dailyWeatherList[indexPath.item].icon
		cell.temperatureMinLabel.text = "\(selectedCity?.dailyWeatherList[indexPath.item].temperatureMin ?? 0)°"
		cell.temperatureMaxLabel.text = "\(selectedCity?.dailyWeatherList[indexPath.item].temperatureMax ?? 0)°"
		return cell
	}
	
}

class DailyTableViewCell: UITableViewCell {
	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var temperatureMinLabel: UILabel!
	@IBOutlet weak var temperatureMaxLabel: UILabel!
}

class OtherWeatherCell: UITableViewCell {
	
	@IBOutlet weak var suriseTimeLabel: UILabel!
	@IBOutlet weak var sunsetTimeLabel: UILabel!
	@IBOutlet weak var precipitationProbabilityLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var windSpeedLabel: UILabel!
	@IBOutlet weak var apparentTemperatureLabel: UILabel!
	@IBOutlet weak var precipitationIntensityLabel: UILabel!
	@IBOutlet weak var pressureLabel: UILabel!
	@IBOutlet weak var visibilityLabel: UILabel!
	@IBOutlet weak var uvIndexLabel: UILabel!
	
}
