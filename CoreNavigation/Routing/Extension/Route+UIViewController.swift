import Foundation

extension Route where Destination: UIViewController {
    public static func route(handler: RouteHandler<Self>) {
        let viewController = Destination.init(nibName: nil, bundle: nil)
        
        handler.destination(viewController)
    }
    
    public static func route(parameters: [String: Any]?, destination: @escaping (Any) -> Void, data: @escaping (Any?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.onDestination(destination)
        
        route(handler: routeHandler)
    }
}

extension Route where Destination: DataReceivable {
    public static func route(parameters: [String: Any]?, destination: @escaping (Any) -> Void, data: @escaping (Any?) -> Void) {
        let routeHandler = RouteHandler<Self>(parameters: parameters)
        
        routeHandler.onData(data)
        routeHandler.onDestination(destination)
        
        route(handler: routeHandler)
    }
}
