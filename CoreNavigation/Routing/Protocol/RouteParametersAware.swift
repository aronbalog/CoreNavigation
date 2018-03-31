import Foundation

/// Describes object having parameters.
public protocol RouteParametersAware {
    /// Parameters that will get passed to RouteHandler.
    var parameters: [String: Any]? { get }
}

// MARK: - Default implementation.
extension RouteParametersAware {
    /// Parameters that will get passed to RouteHandler.
    public var parameters: [String: Any]? {
        return nil
    }
}
