import Foundation

protocol Protectable: class {
    associatedtype Protection: ProtectionAware
    
    var protection: Protection { get set }
    
    @discardableResult func protect(with protectionSpace: ProtectionSpace) -> Self
}

// MARK: - Protection configuration
extension Configuration: Protectable {
    /// Protects navigation by pausing it and gives an option to continue.
    ///
    /// - Parameter protectionSpace: ProtectionSpace object.
    /// - Returns: Configuration instance.
    @discardableResult public func protect(with protectionSpace: ProtectionSpace) -> Self {
        queue.async(flags: .barrier) {
            self.protection.protectionSpace = protectionSpace
        }
        
        return self
    }
}
