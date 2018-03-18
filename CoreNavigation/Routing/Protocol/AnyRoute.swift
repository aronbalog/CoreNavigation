import Foundation

public protocol AnyRoute {
    static func route(parameters: [String: Any]?, destination: @escaping (Any) -> Void, data: @escaping (Any?) -> Void)
}
