import Foundation

// MARK: - Matchable implementation of URL
extension URL: Matchable {
    public var uri: String {
        return self.absoluteString.uri
    }
}
