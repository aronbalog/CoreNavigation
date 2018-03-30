import Foundation

/// Defines view controller cache lifetime.
public protocol Lifetime: class {
    /// This method will be called by module before navigation.
    ///
    /// - Parameter kill: Call this block to invalidate cache.
    func die(_ kill: @escaping () -> Void)
}
