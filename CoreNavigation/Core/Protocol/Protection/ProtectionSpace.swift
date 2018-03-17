import Foundation

/// Protects navigation.
public protocol ProtectionSpace {
    func protect(_ handler: ProtectionHandler)
    func shouldProtect() -> Bool
}
