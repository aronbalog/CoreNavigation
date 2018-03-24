import Foundation

/// :nodoc:
public protocol Originable: class {
    /// :nodoc:
    associatedtype Origin: OriginAware
    
    /// :nodoc:
    var origin: Origin { get set }
    
    /// <#Description#>
    ///
    /// - Parameter viewController: <#viewController description#>
    /// - Returns: <#return value description#>
    @discardableResult func from<T: UIViewController>(_ viewController: T) -> Self
}

// MARK: - <#Description#>
extension Originable {
    @discardableResult public func from<T: UIViewController>(_ viewController: T) -> Self {
        origin.fromViewController = viewController
        
        return self
    }
}
