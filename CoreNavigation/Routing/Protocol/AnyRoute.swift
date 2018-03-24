import Foundation

/// All routes inherits from `AnyRoute` protocol. Use `Route` protocol instead.
public protocol AnyRoute {
    /// Handles routing.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block and pass viewController and optional data.
    static func route(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void)
}

// MARK: - Route default implementation of AnyRoute
extension AnyRoute where Self: Route {
    /// Handles routing.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block and pass viewController and optional data.
    public static func route(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.destinationBlocks.append(destination)
        
        route(handler: routeHandler)
    }
}
