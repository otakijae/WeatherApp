protocol ObservableProtocol: class {
	var observers: [ObserverProtocol] { get set }
	func addObserver(_ observer: ObserverProtocol)
	func removeObserver(_ observer: ObserverProtocol)
	func notifyObservers(_ observers: [ObserverProtocol])
}

protocol ObserverProtocol {
	var id: String { get set }
}

class Observable<T> {
	
	typealias CompletionHandler = ((T) -> Void)
	
	var value: T {
		didSet {
			self.notifyObservers(self.observers)
		}
	}
	
	var observers: [String: CompletionHandler] = [:]
	
	init(value: T) {
		self.value = value
	}
	
	func addObserver(_ observer: ObserverProtocol, completion: @escaping CompletionHandler) {
		self.observers[observer.id] = completion
	}
	
	func removeObserver(_ observer: ObserverProtocol) {
		self.observers.removeValue(forKey: observer.id)
	}
	
	func notifyObservers(_ observers: [String: CompletionHandler]) {
		observers.forEach { $0.value(value) }
	}
	
	deinit {
		observers.removeAll()
	}
	
}
