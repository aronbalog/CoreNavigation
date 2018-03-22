import Foundation

public protocol CachingAware {
    var configuration: (lifetime: Lifetime, cacheIdentifier: String)? { get set }
}
