import Foundation

extension UIViewController {
    public func present(to block: (To<Result<UIViewController, Any>>) -> Void) {
        block(To(.present))
    }
}
