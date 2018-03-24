import Foundation

// MARK: - Matchable view controller convenience
public extension Matchable {
    /// Route to view controller.
    ///
    /// - Parameter viewControllerBlock: Block returning UIViewController instance.
    public func viewController<T: UIViewController>(_ viewControllerBlock: @escaping (T) -> Void) {
        UIViewController.route(to: self, viewControllerBlock)
    }
}
