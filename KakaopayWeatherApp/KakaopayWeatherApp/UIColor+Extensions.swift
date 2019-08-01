import UIKit
import Foundation

extension UIColor {
	
	static var pastelRed: UIColor {
		return UIColor(hexFromString: "FF4F79", alpha: 1.0)
	}
	
	static var pastelApricot: UIColor {
		return UIColor(hexFromString: "FDA293", alpha: 1.0)
	}
	
	static var pastelYellow: UIColor {
		return UIColor(hexFromString: "FDDA93", alpha: 1.0)
	}
	
	static var pastelGreen: UIColor {
		return UIColor(hexFromString: "A4BDA7", alpha: 1.0)
	}
	
	static var pastelSkyblue: UIColor {
		return UIColor(hexFromString: "7DB9CA", alpha: 1.0)
	}
	
	static var pastelBlue: UIColor {
		return UIColor(hexFromString: "0278C6", alpha: 1.0)
	}
	
	static var pastelLightpurple: UIColor {
		return UIColor(hexFromString: "D5C9DB", alpha: 1.0)
	}
	
	static var pastelPurple: UIColor {
		return UIColor(hexFromString: "662E93", alpha: 1.0)
	}
	
	static var pastelDarkGray: UIColor {
		return UIColor(hexFromString: "555555", alpha: 1.0)
	}
	
	class var silver: UIColor {
		return UIColor(red: 207/255, green: 208/255, blue: 218/255, alpha: 1.0)
	}
	
	static var black30: UIColor {
		return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
	}
	
	class var periwinkle: UIColor {
		return UIColor(red: 118/255, green: 123/255, blue: 254/255, alpha: 1.0)
	}
	
	class var defaultKeyboardBackground: UIColor {
		return UIColor(red: 204/255, green: 208/255, blue: 215/255, alpha: 1.0)
	}
	
	static var lavenderBlue: UIColor {
		return UIColor(red: 166/255, green: 155/255, blue: 245/255, alpha: 1.0)
	}
	
	static var softBlue: UIColor {
		return UIColor(red: 103/255, green: 159/255, blue: 233/255, alpha: 1.0)
	}
	
	static var darkBlueGrey70: UIColor {
		return UIColor(red: 37/255, green: 49/255, blue: 92/255, alpha: 0.7)
	}
	
	static var darkBlueGreyTwo70: UIColor {
		return UIColor(red: 45/255, green: 28/255, blue: 68/255, alpha: 0.7)
	}
	
	static var tableViewBackgroundColor: UIColor {
		return UIColor(red: 249/255, green: 251/255, blue: 255/255, alpha: 1.0)
	}
	
	static var haloColor: UIColor {
		return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
	}
	
	static var cellGrayColor: UIColor {
		return UIColor(red: 235/255, green:239/255, blue:250/255, alpha: 1)
	}
	
	static var labelGrayColor: UIColor {
		return UIColor(red: 138/255, green: 151/255, blue: 162/255, alpha: 1)
	}
	
	static var amethyst: UIColor {
		return UIColor(red: 136/255, green: 102/255, blue: 193/255, alpha: 1.0)
	}
	
	static var duskyPurple: UIColor {
		return UIColor(red: 141/255, green: 93/255, blue: 133/255, alpha: 1.0)
	}
	
	static var burntUmber: UIColor {
		return UIColor(red: 152/255, green: 75/255, blue: 19/255, alpha: 1.0)
	}
	
	static var disabledGrayColor: UIColor {
		return UIColor(red: 188/255, green: 191/255, blue: 208/255, alpha: 1)
	}
	
	static var titleGray: UIColor {
		return UIColor(red: 61/255, green: 73/255, blue: 83/255, alpha: 1)
	}
	
	static var buttonTitleGrayColor: UIColor {
		return UIColor(red: 86/255, green: 98/255, blue: 108/255, alpha: 1)
	}
	
	static var labelLightGrayColor: UIColor {
		return UIColor(red: 163/255, green: 174/255, blue: 184/255, alpha: 1)
	}
	
	static var disabledTitleGray: UIColor {
		return UIColor(red: 134/255, green: 143/255, blue: 163/255, alpha: 1)
	}
	
	static var whiteGray: UIColor {
		return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
	}
	
	static var veryLightBlueTwo: UIColor {
		return UIColor(red: 248/255, green: 250/255, blue: 255/255, alpha: 1)
	}
	
	static var backgroundColor: UIColor {
		return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
	}
	
	convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
		var cString: String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		var rgbValue: UInt32 = 10066329
		
		if cString.hasPrefix("#") {
			cString.remove(at: cString.startIndex)
		}
		
		if (cString.count) == 6 {
			Scanner(string: cString).scanHexInt32(&rgbValue)
		}
		
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: alpha
		)
	}
	
	func toHexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
		
		return String(format: "#%06x", rgb)
	}
	
}
