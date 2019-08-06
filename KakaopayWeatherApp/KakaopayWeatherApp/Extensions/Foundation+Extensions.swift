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

extension Optional {
	
	func ifSome(_ closure: (Wrapped) -> Void) {
		switch self {
		case .some(let wrapped): return closure(wrapped)
		case .none: break
		}
	}
	
	@discardableResult
	func ifNone(_ closure: () -> Void) -> Optional {
		switch self {
		case .some: return self
		case .none: closure(); return self
		}
	}
	
}

extension Bool {
	
	func ifTrue(_ closure: @autoclosure () -> Void) {
		switch self {
		case true: return closure()
		case false: return
		}
	}
	
	func ifFalse(_ closure: @autoclosure () -> Void) {
		switch self {
		case true: return
		case false: return closure()
		}
	}
	
}
