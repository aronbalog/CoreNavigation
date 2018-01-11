import Foundation

public protocol Protectable {
    func protect(with protectionSpace: ProtectionSpace) -> Self
}
