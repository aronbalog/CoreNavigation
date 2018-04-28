import Foundation

infix operator <-: AdditionPrecedence

/// :nodoc:
public func <-(left: AnyDestination.Type, right: [String]) {
    Router.shared.register(destinationType: left, patterns: right)
}

/// Handles routing.
public class Router {
    static let shared = Router()

    private var registrations: [Registration] = []

    /// Registers route.
    ///
    /// - Parameter routableType: Route to register.
    public func register<T: Routable>(routableType: T.Type) {
        let registration = Registration(destinationType: routableType, patterns: routableType.patterns)
        registrations.append(registration)
    }

    /// Registers destination with patterns.
    ///
    /// - Parameters:
    ///   - destinationType: `Destination` type.
    ///   - patterns: Route patterns.
    public func register(destinationType: AnyDestination.Type, patterns: [String]) {
        let registration = Registration(destinationType: destinationType, patterns: patterns)
        registrations.append(registration)
    }

    func match(for matchable: Matchable) -> RouteMatch? {
        var parameters: [String: Any]?

        guard let registration = (registrations.first { return $0.matches(matchable, &parameters) }) else {
            return nil
        }

        return RouteMatch(destinationType: registration.destinationType, parameters: parameters)
    }
}

private extension Router {
    struct Registration {
        let destinationType: AnyDestination.Type
        let patterns: [String]

        func matches(_ matchable: Matchable, _ parameters: inout [String: Any]?) -> Bool {
            return self.patterns.first { (pattern) -> Bool in
                guard let regularExpression = try? RegularExpression(pattern: pattern) else {
                    return false
                }

                return regularExpression.matchResult(for: matchable.uri, parameters: &parameters)
                } != nil
        }
    }
}
