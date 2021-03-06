import Foundation

protocol Cacheable: class {
    associatedtype Caching: CachingAware

    var caching: Caching { get set }

    @discardableResult func keepAlive(within lifetime: Lifetime, cacheIdentifier: String) -> Self
}

// MARK: - Cache configuration
extension Configuration: Cacheable {
    /// Caches navigation.
    ///
    /// - Parameters:
    ///   - lifetime: Lifetime object.
    ///   - cacheIdentifier: Cache identifier string.
    /// - Returns: Configuration instance.
    @discardableResult public func keepAlive(within lifetime: Lifetime, cacheIdentifier: String) -> Self {
        queue.async(flags: .barrier) {
            self.caching.configuration = (lifetime, cacheIdentifier)
        }

        return self
    }
}
