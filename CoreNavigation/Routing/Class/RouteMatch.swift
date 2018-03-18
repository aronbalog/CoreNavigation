import Foundation

class RouteMatch {
    let route: RoutePatternAware.Type
    let parameters: [String: Any]?
    
    init(route: RoutePatternAware.Type, parameters: [String: Any]?) {
        self.route = route
        self.parameters = parameters
    }
}
