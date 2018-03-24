import Foundation

// MARK: - UINavigationController navigation
extension UINavigationController {
    /// Pushes view controller from this view controller.
    ///
    /// - Parameter block: Configuration block.
    public func push(_ block: (To<Result<UIViewController, Any>>) -> Void) {
        block(To(.push, from: self))
    }
}
