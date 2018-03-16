import Foundation

public protocol Cacheable: class {
    associatedtype Caching: CachingAware
    
    var caching: Caching { get set }
    
    @discardableResult func keepAlive(within lifetime: Lifetime) -> Self
}

extension Cacheable {
    @discardableResult public func keepAlive(within lifetime: Lifetime) -> Self {
        caching.lifetime = lifetime
        
        return self
    }
}

