import Foundation

protocol UnsafeNavigation {
    associatedtype UnsafeNavigationObject: UnsafeNavigationAware
    
    var unsafeNavigation: UnsafeNavigationObject { get set }
    
    @discardableResult func unsafely() -> Self
}

extension UnsafeNavigation {
    @discardableResult public func unsafely() -> Self {
        unsafeNavigation.isUnsafe = true
        
        return self
    }
}

