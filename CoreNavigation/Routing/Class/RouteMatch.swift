import Foundation

class RouteMatch {
    let routableType: Routable.Type
    let parameters: [String: Any]?
    
    init(routableType: Routable.Type, parameters: [String: Any]?) {
        self.routableType = routableType
        self.parameters = parameters
    }
}
