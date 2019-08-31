infix operator <-: AdditionPrecedence

/// :nodoc:
public func <-(left: AnyDestination.Type, right: [String]) {
    Router.instance.register(destinationType: left, patterns: right)
}

/// Handles routing.
public class Router {
    public static let instance = Router()
    
    private var registrations: [Registration] = []
    
    /// Registers route.
    ///
    /// - Parameter routableType: Route to register.
    public func register<T: Routable>(routableType: T.Type) {
        registrations.append(Registration(destinationType: routableType, patterns: routableType.routePatterns()))
    }
    
    /// Registers destination with patterns.
    ///
    /// - Parameters:
    ///   - destinationType: `Destination` type.
    ///   - patterns: Route patterns.
    public func register(destinationType: AnyDestination.Type, patterns: [String]) {
        registrations.append(Registration(destinationType: destinationType, patterns: patterns))
    }
    
    func match(for matchable: Matchable) -> Routing.RouteMatch? {
        var parameters: [String: Any]?
        
        guard let registration = (registrations.first { return $0.matches(matchable, &parameters) }) else {
            return nil
        }
        
        return Routing.RouteMatch(destinationType: registration.destinationType, parameters: parameters)
    }
}

private extension Router {
    struct Registration {
        let destinationType: AnyDestination.Type
        let patterns: [String]
        
        func matches(_ matchable: Matchable, _ parameters: inout [String: Any]?) -> Bool {
            return self.patterns.first { (pattern) -> Bool in
                guard let regularExpression = try? Routing.RegularExpression(pattern: pattern) else {
                    return false
                }
                
                return regularExpression.matchResult(for: matchable.uri, parameters: &parameters)
                } != nil
        }
    }
}
