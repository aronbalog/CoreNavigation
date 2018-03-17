import Foundation

public protocol Protectable: class {
    associatedtype Protection: ProtectionAware
    
    var protection: Protection { get set }
    
    @discardableResult func protect(with protectionSpace: ProtectionSpace) -> Self
}

extension Protectable {
    @discardableResult public func protect(with protectionSpace: ProtectionSpace) -> Self {
        protection.protectionSpace = protectionSpace
        
        return self
    }
}
