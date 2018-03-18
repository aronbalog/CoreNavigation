import Foundation

protocol Matchable {
    var uri: String { get }
}

extension String: Matchable {
    var uri: String {
        return self
    }
}

extension URL: Matchable {
    var uri: String {
        return self.absoluteString
    }
}
