import Foundation

public class Router {
    static let shared = Router()
    
    private var registeredRoutes: [RoutePatternAware.Type] = []
    
    public func registerRoute<T: URLAccessibleRoute>(_ route: T.Type) {
        registeredRoutes.append(route)
    }
    
    public func registerRoute<T: PathAccessibleRoute>(_ route: T.Type) {
        registeredRoutes.append(route)
    }
    
    public func registerRoute<T: RoutePatternAware>(_ route: T.Type) {
        registeredRoutes.append(route)
    }
    
    func match(for matchable: Matchable) -> RouteMatch? {
        var parameters: [String: Any]?
        
        guard let route = (registeredRoutes.first { return $0.matches(matchable, &parameters) }) else { return nil }
        
        return RouteMatch(route: route, parameters: parameters)
    }
}

fileprivate extension RoutePatternAware {
    static func matches(_ matchable: Matchable, _ parameters: inout [String: Any]?) -> Bool {
        guard let regularExpression = try? RegularExpression(pattern: pattern) else { return false }
        
        return regularExpression.matchResult(for: matchable.uri, parameters: &parameters)
    }
}
