import Foundation

// MARK: - UIViewController navigation
public extension UIViewController {
    /// Presents view controller from this view controller.
    ///
    /// - Parameter block: Configuration block.
    public func present(_ block: (To<Result<UIViewController, Any>>) -> Void) {
        block(To(.present, from: self))
    }
}
