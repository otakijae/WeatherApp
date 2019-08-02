import UIKit

class CurrentlyWeatherCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
			
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class HourlyWeatherCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
	
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

class DailyWeatherCell: UITableViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
	}
	
}

class OtherWeatherCell: UITableViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
	}
	
}
