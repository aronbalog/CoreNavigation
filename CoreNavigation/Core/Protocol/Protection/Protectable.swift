import Foundation

protocol Protectable: class {
    associatedtype Protection: ProtectionAware
    
    var protection: Protection { get set }
    
    @discardableResult func protect(with protectionSpace: ProtectionSpace) -> Self
}

extension Configuration: Protectable {
    /// Protects navigation by pausing it and gives an option to continue.
    ///
    /// - Parameter protectionSpace: ProtectionSpace object.
    /// - Returns: Configuration instance.
    @discardableResult public func protect(with protectionSpace: ProtectionSpace) -> Self {
        protection.protectionSpace = protectionSpace
        
        return self
    }
}
