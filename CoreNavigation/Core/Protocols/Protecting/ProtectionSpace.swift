import Foundation

public protocol ProtectionSpace: class {
    func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool
}
