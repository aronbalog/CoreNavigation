import Foundation

/// It ensures that route can be accessed via matchable type, e.g. string or URL
public protocol Routable: AnyDestination {
    /// Array of pattern strings.
    static var patterns: [String] { get }
}

// MARK: - Registration extension
extension Routable {
    /// Registers route.
    static public func register() {
        Navigate.router.register(routeType: self)
    }
}
