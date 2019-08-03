import Foundation

class ViewModel: Observation {
	
	var vmlist: [String] = []
	
	override init() {
		super.init()
		addObservers()
	}
	
	func addObservers() {
		WeatherModule.instance.addObserver(self)
	}
	
	func add() {
		vmlist.append("aaa")
		vmlist.append("bbb")
		vmlist.append("ccc")
		
		notify()
	}
	
	func requestWeather() {
		WeatherModule.instance.requestWeather(latitude: 37.566067729627, longitude: 126.97413895279169)
	}
	
	func notify() {
		for observer in observers {
			observer.update(vmlist)
		}
	}
	
	func notify(_ json: Any) {
		for observer in observers {
			observer.update(json)
		}
	}
	
}

extension ViewModel: Observer {
	
	func update(_ list: [String]) {
		
	}
	
	func update(_ json: Any) {
		notify(json)
	}
	
}
