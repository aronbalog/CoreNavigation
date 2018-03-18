import Foundation

public protocol RoutePatternAware: AnyRoute {
    static var pattern: String { get }
}
