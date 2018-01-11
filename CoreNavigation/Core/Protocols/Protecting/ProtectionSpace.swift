import Foundation

public protocol ProtectionSpace {
    func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool
}
