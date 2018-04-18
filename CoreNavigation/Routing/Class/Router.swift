import Foundation

/// Handles routing.
public class Router {
    static let shared = Router()
    
    private var registeredRoutesTypes: [Routable.Type] = []
    
    /// Registers route.
    ///
    /// - Parameter routeType: Route to register.
    public func register<T: Routable>(_ routeType: T.Type) {
        registeredRoutesTypes.append(routeType)
    }
    
    func match(for matchable: Matchable) -> RouteMatch? {
        var parameters: [String: Any]?
        
        guard let routableType = (registeredRoutesTypes.first { return $0.matches(matchable, &parameters) }) else {
            return nil
        }
        
        return RouteMatch(routableType: routableType, parameters: parameters)
    }
}

fileprivate extension Routable {
    static func matches(_ matchable: Matchable, _ parameters: inout [String: Any]?) -> Bool {
        return patterns.first { (pattern) -> Bool in
            guard let regularExpression = try? RegularExpression(pattern: pattern) else {
                return false
            }
            
            return regularExpression.matchResult(for: matchable.uri, parameters: &parameters)
        } != nil
    }
}
