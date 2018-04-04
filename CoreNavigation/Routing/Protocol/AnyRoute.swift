import Foundation

/// All routes inherits from `AnyRoute` protocol. Use `Route` protocol instead.
public protocol AnyRoute {
    /// Handles routing.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block to route and pass viewController and optional data.
    ///   - failure: Call this block and pass optional error to cancel routing.
    static func route(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void, failure: @escaping (Error?) -> Void)
}

// MARK: - Route default implementation of AnyRoute
extension AnyRoute where Self: Route {
    /// Handles routing.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block to route and pass viewController and optional data.
    ///   - failure: Call this block and pass optional error to cancel routing.
    public static func route(parameters: [String: Any]?, destination: @escaping (UIViewController, Any?) -> Void, failure: @escaping (Error?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.destinationBlocks.append(destination)
        routeHandler.cancelBlocks.append(failure)
        
        route(handler: routeHandler)
    }
}
