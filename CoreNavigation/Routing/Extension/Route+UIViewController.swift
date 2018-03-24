import Foundation

extension Route {
    /// Handles routing.
    ///
    /// - Parameter handler: `RouteHandler` object.
    public static func route(handler: RouteHandler<Self>) {
        let viewController = Destination.init()
        
        handler.destination(viewController, data: nil)
    }
    
    public static func route(parameters: [String: Any]?, destination: @escaping (Any, Any?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.destinationBlocks.append(destination)
        
        route(handler: routeHandler)
    }
}
