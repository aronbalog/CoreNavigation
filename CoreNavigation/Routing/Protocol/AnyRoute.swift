import Foundation

public protocol AnyRoute {
    static func route(parameters: [String: Any]?, destination: @escaping (Any, Any?) -> Void)
}
