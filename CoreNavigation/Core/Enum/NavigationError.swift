import Foundation

/// Navigation error enum.
///
/// - unknown: Unknown error.
/// - routeNotFound: Route is not found.
public enum NavigationError: Error {
    /// Unknown error.
    case unknown
    /// Route is not found.
    case routeNotFound
}
