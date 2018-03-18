import Foundation

public protocol RouteParametersAware {
    var parameters: [String: Any]? { get }
}

extension RouteParametersAware {
    public var parameters: [String: Any]? {
        return nil
    }
}
