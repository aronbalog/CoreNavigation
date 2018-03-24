import Foundation

protocol Originable: class {
    associatedtype Origin: OriginAware
    
    var origin: Origin { get set }
    
    @discardableResult func from<T: UIViewController>(_ viewController: T) -> Self
}

extension Configuration: Originable {
    @discardableResult public func from<T: UIViewController>(_ viewController: T) -> Self {
        origin.fromViewController = viewController
        
        return self
    }
}
