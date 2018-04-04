import Foundation

/// Route protocol describes wrapper for destination.
public protocol Route: AnyRoute, RouteParametersAware {
    // MARK: - Defines destination
    associatedtype Destination: UIViewController
    
    /// Handles routing.
    ///
    /// - Parameter handler: `RouteHandler` object.
    static func route(handler: RouteHandler<Self>)
}

// MARK: - Route default implementation
extension Route {
    /// Handles routing.
    ///
    /// - Parameter handler: `RouteHandler` object.
    public static func route(handler: RouteHandler<Self>) {
        let viewController = Destination.init()
        
        handler.destination(viewController, data: nil)
    }
}
