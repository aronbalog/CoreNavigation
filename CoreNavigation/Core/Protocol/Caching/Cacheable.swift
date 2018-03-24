import Foundation

protocol Cacheable: class {
    associatedtype Caching: CachingAware
    
    var caching: Caching { get set }
    
    @discardableResult func keepAlive(within lifetime: Lifetime, cacheIdentifier: String) -> Self
}

extension Configuration: Cacheable {
    @discardableResult public func keepAlive(within lifetime: Lifetime, cacheIdentifier: String) -> Self {
        caching.configuration = (lifetime, cacheIdentifier)
        
        return self
    }
}

