import Foundation

protocol CachingAware {
    var configuration: (lifetime: Lifetime, cacheIdentifier: String)? { get set }
}
