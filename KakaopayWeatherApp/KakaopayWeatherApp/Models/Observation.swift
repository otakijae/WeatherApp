protocol Observable {
	func addObserver(_ observer: Observer)
	func removeObserver(_ observer: Observer)
}

protocol Observer: class {
	func update(_ list: [String])
	func update(_ json: Any)
}

class Observation: Observable {
	
	var observers = [Observer]()
	
	func addObserver(_ observer: Observer) {
		observers.append(observer)
	}
	
	func removeObserver(_ observer: Observer) {
		observers = observers.filter({ $0 !== observer })
	}
	
}
