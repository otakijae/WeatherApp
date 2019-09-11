import UIKit
import Foundation

extension NSObject {
	
	class var className: String {
		return String(describing: self)
	}
	
	var className: String {
		return type(of: self).className
	}
	
}

extension UIViewController {
	
	static var instance: UIViewController {
		return UIStoryboard(name: self.className, bundle: nil).instantiateInitialViewController()!
	}
	
	func alert(title: String = Constants.applicationName, message: String, okTitle: String = Constants.confirm, okAction: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let okAction = UIAlertAction(title: okTitle, style: .cancel) { _ in
				guard let action = okAction else { return }
				action()
			}
			
			alert.addAction(okAction)
			alert.view.tintColor = UIColor.darkGray
			self.present(alert, animated: true, completion: { alert.view.tintColor = UIColor.darkGray })
		}
	}
	
	static let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
	static let indicatorLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
	
	func startIndicator(labelText: String = "") {
		if UIViewController.indicator.superview == nil {
			UIViewController.indicator.removeFromSuperview()
			UIViewController.indicator.alpha = 0.0
			UIViewController.indicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
			UIViewController.indicator.layer.cornerRadius = 10
			UIViewController.indicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
			UIViewController.indicator.center = self.view.center
			UIViewController.indicator.clipsToBounds = true
			UIViewController.indicator.startAnimating()
			self.view.addSubview(UIViewController.indicator)
		}
		
		UIViewController.indicatorLabel.center.x = self.view.center.x
		UIViewController.indicatorLabel.center.y = self.view.center.y + 55
		UIViewController.indicatorLabel.text = labelText
		UIViewController.indicatorLabel.font = UIFont(name: Constants.font, size: 14.0)
		UIViewController.indicatorLabel.alpha = 0.0
		UIViewController.indicatorLabel.textColor = UIColor.darkText
		UIViewController.indicatorLabel.textAlignment = .center
		UIViewController.indicatorLabel.backgroundColor = UIColor.clear
		
		if UIViewController.indicatorLabel.superview == nil {
			self.view.addSubview(UIViewController.indicatorLabel)
		}
		
		UIView.animate(withDuration: 0.2,
									 delay: 0.2,
									 options: UIView.AnimationOptions.curveEaseIn,
									 animations: {
										UIViewController.indicator.alpha = 1.0
										UIViewController.indicatorLabel.alpha = 1.0
		})
	}
	
	func stopIndicator() {
		UIView.animate(withDuration: 0.2,
									 delay: 0.2,
									 options: UIView.AnimationOptions.curveEaseOut,
									 animations: {
										UIViewController.indicator.alpha = 0.0
										UIViewController.indicatorLabel.alpha = 0.0 },
									 completion: { _ in
										UIViewController.indicator.stopAnimating()
										UIViewController.indicator.removeFromSuperview()
										UIViewController.indicatorLabel.removeFromSuperview()
		})
	}
	
}
