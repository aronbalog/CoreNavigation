import Foundation

public protocol CachingAware {
    var lifetime: Lifetime? { get set }
}
