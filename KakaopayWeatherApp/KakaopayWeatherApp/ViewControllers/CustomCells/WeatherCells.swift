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
	var selectedCity: City? {
		didSet {
			configureCurrentlyWeatherCell()
		}
	}
	
	func configureCurrentlyWeatherCell() {
		guard let selectedCity = selectedCity else { return }
		cityNameLabel.text = selectedCity.name
		statusLabel.text = selectedCity.weather?.icon
		temperatureLabel.text = selectedCity.currentTemperature
		summaryLabel.text = selectedCity.weather?.summary
		dateLabel.text = selectedCity.currentTime
		dayOfWeekLabel.text = selectedCity.dayOfWeek
		temperatureMinLabel.text = "\(selectedCity.weather?.temperatureMin ?? 0)°"
		temperatureMaxLabel.text = "\(selectedCity.weather?.temperatureMax ?? 0)°"
	}
	
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
		guard let selectedCity = selectedCity else { return 0 }
		return selectedCity.hourlyWeatherList.count
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
		return configureHourlyCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
	}
	
	func configureHourlyCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
		cell.timeLabel.text = selectedCity?.hourlyWeatherList[indexPath.item].time
		cell.statusLabel.text = selectedCity?.hourlyWeatherList[indexPath.item].summary
		cell.temperatureLabel.text = "\(selectedCity?.hourlyWeatherList[indexPath.item].temperature ?? 0)°"
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
	
}

class HourlyCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
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
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44
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
		cell.statusLabel.text = selectedCity?.dailyWeatherList[indexPath.item].summary
		cell.temperatureMinLabel.text = selectedCity?.dailyWeatherList[indexPath.item].temperatureMin
		cell.temperatureMaxLabel.text = selectedCity?.dailyWeatherList[indexPath.item].temperatureMax
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
	var selectedCity: City? {
		didSet {
			configureOtherWeatherCell()
		}
	}
	
	func configureOtherWeatherCell() {
		guard let selectedCity = selectedCity else { return }
		suriseTimeLabel.text = selectedCity.weather?.sunriseTime
		sunsetTimeLabel.text = selectedCity.weather?.sunsetTime
		precipitationProbabilityLabel.text = "\(selectedCity.weather?.precipitationProbability ?? 0)%"
		humidityLabel.text = "\(selectedCity.weather?.humidity ?? 0)"
		windSpeedLabel.text = "\(selectedCity.weather?.windSpeed ?? 0)m/s"
		apparentTemperatureLabel.text = "\(selectedCity.weather?.apparentTemperature ?? 0)°"
		precipitationIntensityLabel.text = "\(selectedCity.weather?.precipitationIntensity ?? 0)cm"
		pressureLabel.text = "\(selectedCity.weather?.pressure ?? 0)hPa"
		visibilityLabel.text = "\(selectedCity.weather?.visibility ?? 0)km"
		uvIndexLabel.text = "\(selectedCity.weather?.uvIndex ?? 0)"
	}
	
}
