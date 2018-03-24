import Foundation

public protocol AnyRoute {
    static func route(parameters: [String: Any]?, destination: @escaping (Any, Any?) -> Void)
}

extension AnyRoute where Self: Route {
    public static func route(parameters: [String: Any]?, destination: @escaping (Any, Any?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.destinationBlocks.append(destination)
        
        route(handler: routeHandler)
    }
}
