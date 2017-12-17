import Foundation

public protocol Cachable {
    func keepAlive(within lifetime: Lifetime, identifier: String) -> Self
}
