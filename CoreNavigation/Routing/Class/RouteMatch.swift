import Foundation

class RouteMatch {
    let destinationType: AnyDestination.Type
    let parameters: [String: Any]?

    init(destinationType: AnyDestination.Type, parameters: [String: Any]?) {
        self.destinationType = destinationType
        self.parameters = parameters
    }
}
