import Foundation

protocol UnsafeNavigation {
    associatedtype UnsafeNavigationObject: UnsafeNavigationAware

    var unsafeNavigation: UnsafeNavigationObject { get set }

    @discardableResult func unsafely() -> Self
}

// MARK: - Unsafe navigation configuration
extension Configuration: UnsafeNavigation {
    /// Skips queue when navigating.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func unsafely() -> Self {
        queue.async(flags: .barrier) {
            self.unsafeNavigation.isUnsafe = true
        }

        return self
    }
}
