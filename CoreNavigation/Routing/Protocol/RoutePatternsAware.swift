import Foundation

/// It ensures that route can be accessed via matchable type, e.g. string or URL
public protocol RoutePatternsAware: AnyRoute {
    /// Array of pattern strings.
    static var patterns: [String] { get }
}
