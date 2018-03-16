import Foundation

public protocol Lifetime: class {
    func cacheIdentifier() -> String
    func die(_ kill: @escaping () -> Void)
}
