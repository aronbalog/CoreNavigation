import Foundation

public protocol Lifetime: class {
    func die(_ kill: @escaping () -> Void)
}
