import Foundation

extension UIViewController {
    public func present(_ block: (To<Result<UIViewController, Any>>) -> Void) {
        block(To(.present))
    }
}
