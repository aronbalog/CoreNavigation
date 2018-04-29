import Foundation

/// Destination protocol describes wrapper for destination.
public protocol Destination: AnyDestination, ParametersAware {
    // MARK: - Defines destination
    associatedtype ViewControllerType: UIViewController

    /// Resolves routing.
    ///
    /// - Parameter context: `Context` object.
    static func resolve(context: Context<ViewControllerType>)
}

// MARK: - Destination default implementation
extension Destination {
    /// Resolves routing.
    ///
    /// - Parameter context: `Context` object.
    public static func resolve(context: Context<ViewControllerType>) {
        let viewController = ViewControllerType.init()

        context.destination(viewController, data: nil)
    }
}
