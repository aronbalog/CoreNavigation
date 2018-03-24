import Foundation

/// Route protocol describes wrapper for destination.
public protocol Route: AnyRoute, RouteParametersAware {
    associatedtype Destination: UIViewController
    
    /// Handles routing.
    ///
    /// - Parameter handler: `RouteHandler` object.
    static func route(handler: RouteHandler<Self>)
}
