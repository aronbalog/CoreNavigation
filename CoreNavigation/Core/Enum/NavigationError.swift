import Foundation

/// Navigation error enum.
///
/// - unknown: Unknown error.
/// - destinationNotFound: Destination is not found.
public enum NavigationError: Error {
    /// Unknown error.
    case unknown
    /// Destination is not found.
    case destinationNotFound
}
