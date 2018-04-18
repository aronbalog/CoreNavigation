import Foundation

/// Describes any object which can receive abstract data.
public protocol AbstractDataReceivable {
    /// Called by module when data passing occurs.
    ///
    /// - Parameter data: Data passed on navigation.
    func didReceiveAbstractData(_ data: Any?)
}
