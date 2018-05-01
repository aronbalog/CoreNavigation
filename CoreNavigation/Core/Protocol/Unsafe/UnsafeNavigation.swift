import Foundation

protocol SafeNavigation {
    associatedtype SafeNavigationObject: SafeNavigationAware

    var safeNavigation: SafeNavigationObject { get set }

    @discardableResult func safely() -> Self
}

// MARK: - Unsafe navigation configuration
extension Configuration: SafeNavigation {
    /// Adds navigation to queue.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func safely() -> Self {
        queue.async(flags: .barrier) {
            self.safeNavigation.isSafe = true
        }

        return self
    }
}
