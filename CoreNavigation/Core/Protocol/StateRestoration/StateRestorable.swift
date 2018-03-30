import Foundation

protocol StateRestorable: class {
    associatedtype StateRestoration: StateRestorationAware
    
    var stateRestoration: StateRestoration { get set }
    
    @discardableResult func stateRestorable() -> Self
    @discardableResult func stateRestorable(identifier: String) -> Self
    @discardableResult func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self
}

extension Configuration: StateRestorable {
    /// Makes destination state restorable.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable() -> Self {
        stateRestoration.option = .automatically
        
        return self
    }
    
    /// Makes destination state restorable.
    ///
    /// - Parameter identifier: Restoration identifier.
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable(identifier: String) -> Self {
        stateRestoration.option = .automaticallyWithIdentifier(restorationIdentifier: identifier)
        
        return self
    }
    
    /// Makes destination state restorable.
    ///
    /// - Parameters:
    ///   - identifier: Restoration identifier.
    ///   - class: Restoration class
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self {
        stateRestoration.option = .manually(restorationIdentifier: identifier, restorationClass: `class`)
        
        return self
    }

}
