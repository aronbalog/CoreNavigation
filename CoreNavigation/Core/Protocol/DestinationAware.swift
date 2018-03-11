import Foundation

public protocol DestinationAware {
    func to<T: UIViewController>(_ destination: T) -> Configuration<Result<T>>
    func to<T: UIViewController>(_ destination: T.Type) -> Configuration<Result<T>>
}
