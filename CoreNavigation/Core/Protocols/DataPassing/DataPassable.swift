import Foundation

public protocol DataPassable {
    func pass(parameters: [String: Any]) -> Self
}
