import Foundation

protocol Originable: class {
    associatedtype Origin: OriginAware

    var origin: Origin { get set }

    @discardableResult func from<T: UIViewController>(_ viewController: T) -> Self
}

// MARK: - Origin configuration
extension Configuration: Originable {
    /// Sets origin.
    ///
    /// - Parameter viewController: Origin view controller in navigation.
    /// - Returns: Configuration instance.
    @discardableResult public func from<T: UIViewController>(_ viewController: T) -> Self {
        queue.async(flags: .barrier) {
            self.origin.fromViewController = viewController
        }

        return self
    }
}
