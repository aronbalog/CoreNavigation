import Foundation

public protocol DestinationAware {
    func to<T1: UIViewController>(_ destination: T1) -> Configuration<Result<T1, Any>>
    func to<T1: UIViewController>(_ destination: T1.Type) -> Configuration<Result<T1, Any>>
}
