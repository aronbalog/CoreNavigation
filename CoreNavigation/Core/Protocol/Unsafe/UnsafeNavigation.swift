import Foundation

protocol UnsafeNavigation {
    associatedtype UnsafeNavigationObject: UnsafeNavigationAware
    
    var unsafeNavigation: UnsafeNavigationObject { get set }
    
    @discardableResult func unsafely() -> Self
}

extension Configuration: UnsafeNavigation {
    /// Skips queue when navigating.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func unsafely() -> Self {
        unsafeNavigation.isUnsafe = true
        
        return self
    }
}

