import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		navigationController.navigationBar.barTintColor = .white
		navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
		guard let mainListViewController = MainListViewController.instance as? MainListViewController else { return false }
		mainListViewController.viewModel = ViewModel()
		navigationController.viewControllers = [mainListViewController]
		self.window!.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}

	func applicationWillTerminate(_ application: UIApplication) {
		
	}


}

