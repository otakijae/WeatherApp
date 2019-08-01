import Foundation

class ViewModel: Observation {
	
	var vmlist: [String] = []
	
	func add() {
		vmlist.append("aaa")
		vmlist.append("bbb")
		vmlist.append("ccc")
		
		notify()
	}
	
	func notify() {
		for observer in observers {
			observer.update(vmlist)
		}
	}
	
}

protocol Observable {
	func addObserver(_ observer: Observer)
	func removeObserver(_ observer: Observer)
}

protocol Observer: class {
	func update(_ list: [String])
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
