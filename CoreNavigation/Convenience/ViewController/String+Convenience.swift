import Foundation

// MARK: - Matchable implementation of String
extension String: Matchable {
    public var uri: String {
        return self
    }
}
