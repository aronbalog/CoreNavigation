import Foundation

/// Navigation error enum.
///
/// - unknown: Unknown error.
/// - destinationNotFound: Destination is not found.


/// Navigation error enum.
///
/// - unknown: Unknown error.
/// - notFound: Destination is not found.
public enum NavigationError: Error {
    /// Unknown error.
    case unknown
    
    /// Destination error
    ///
    /// - notFound: Destination is not found.
    public enum Destination: Error {
        /// Destination is not found.
        case notFound
    }
}
