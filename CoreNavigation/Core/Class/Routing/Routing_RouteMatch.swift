extension Routing {
    class RouteMatch {
        let destinationType: AnyDestination.Type
        let parameters: [String: Any]?
        let pattern: String

        init(destinationType: AnyDestination.Type, parameters: [String: Any]?, pattern: String) {
            self.destinationType = destinationType
            self.parameters = parameters
            self.pattern = pattern
        }
    }
}
