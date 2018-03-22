import Foundation

public protocol RoutePatternsAware: AnyRoute {
    static var patterns: [String] { get }
}
