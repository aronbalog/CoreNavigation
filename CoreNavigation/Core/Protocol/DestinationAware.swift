import Foundation

protocol DestinationAware {
    @discardableResult func to<T: UIViewController>(_ viewController: T) -> Configuration<Result<T, Any>>
    @discardableResult func to<T: UIViewController>(_ viewControllerClass: T.Type) -> Configuration<Result<T, Any>>
    @discardableResult func to<T: UIViewController>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, Any>>
    @discardableResult func to<T: UIViewController>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, Any>>
}
