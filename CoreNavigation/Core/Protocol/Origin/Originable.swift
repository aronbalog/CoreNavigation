import Foundation

public protocol Originable: class {
    associatedtype Origin: OriginAware
    
    var origin: Origin { get set }
    
    @discardableResult func from<T: UIViewController>(_ viewController: T) -> Self
}

extension Originable {
    @discardableResult public func from<T: UIViewController>(_ viewController: T) -> Self {
        origin.fromViewController = viewController
        
        return self
    }
}
