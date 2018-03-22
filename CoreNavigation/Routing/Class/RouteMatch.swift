import Foundation

class RouteMatch {
    let route: RoutePatternsAware.Type
    let parameters: [String: Any]?
    
    init(route: RoutePatternsAware.Type, parameters: [String: Any]?) {
        self.route = route
        self.parameters = parameters
    }
}
