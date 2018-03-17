import Foundation

public protocol UnsafeNavigation {
    associatedtype UnsafeNavigationObject: UnsafeNavigationAware
    
    var unsafeNavigation: UnsafeNavigationObject { get set }
    
    func unsafely() -> Self
}

extension UnsafeNavigation {
    public func unsafely() -> Self {
        unsafeNavigation.isUnsafe = true
        
        return self
    }
}

