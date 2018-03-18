import Foundation

/// Protects navigation.
public protocol ProtectionSpace: class {
    func protect(_ handler: ProtectionHandler)
    func shouldProtect() -> Bool
}
