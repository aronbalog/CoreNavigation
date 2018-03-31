import Foundation

/// Protects navigation.
public protocol ProtectionSpace: class {
    /// Called by module before navigation.
    ///
    /// - Parameter handler: `ProtectionHandler` object. Call `unprotect()` when ready to continue navigation.
    func protect(_ handler: ProtectionHandler)
    
    /// Called by module before protecting.
    ///
    /// - Returns: Boolean. If `true` is returned, `protect(_:)` will be called. Returning false navigates immediately.
    func shouldProtect() -> Bool
}
