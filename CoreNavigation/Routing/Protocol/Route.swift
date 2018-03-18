import Foundation

public protocol Route: AnyRoute, RouteParametersAware {
    associatedtype Destination
    
    static func route(handler: RouteHandler<Self>)
}
