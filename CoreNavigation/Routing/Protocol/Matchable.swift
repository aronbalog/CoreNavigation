import Foundation

public protocol Matchable {
    var uri: String { get }
}

extension String: Matchable {
    public var uri: String {
        return self
    }
}

extension URL: Matchable {
    public var uri: String {
        return self.absoluteString
    }
}
