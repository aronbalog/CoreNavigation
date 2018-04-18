import Foundation

/// Describes object having parameters.
public protocol ParametersAware {
    /// Parameters that will get passed to Context.
    var parameters: [String: Any]? { get }
}

// MARK: - Default implementation.
extension ParametersAware {
    /// Parameters that will get passed to Context.
    public var parameters: [String: Any]? {
        return nil
    }
}
