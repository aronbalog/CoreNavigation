import Foundation

/// Configuration block
public typealias ConfigurationBlock = (To<Result<UIViewController, Any>>) -> Void

/// Navigation starting point.
public struct Navigate {

    /// Navigation history.
    public static var history: History {
        return History.shared
    }

    /// Navigation router.
    public static var router: Router {
        return Router.shared
    }

    /// Presents view controller with configuration block.
    ///
    /// - Parameter configuration: `Configuration` block which returns object that can be used to configure push navigation.
    /// - Returns: `Navigate` class.
    @discardableResult public static func present(_ configuration: ConfigurationBlock) -> Navigate.Type {
        configuration(To<Result<UIViewController, Any>>(.present, from: nil))

        return self
    }

    /// Pushes view controller with configuration block.
    ///
    /// - Parameter configuration: `Configuration` block which returns object that can be used to configure presenting navigation.
    /// - Returns: `Navigate` class.
    @discardableResult public static func push(_ configuration: ConfigurationBlock) -> Navigate.Type {
        configuration(To<Result<UIViewController, Any>>(.push, from: nil))

        return self
    }
}
