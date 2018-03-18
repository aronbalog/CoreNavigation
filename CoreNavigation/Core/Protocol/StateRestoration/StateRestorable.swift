import Foundation

public protocol StateRestorable: class {
    associatedtype StateRestoration: StateRestorationAware
    
    var stateRestoration: StateRestoration { get set }
    
    @discardableResult func stateRestorable() -> Self
    @discardableResult func stateRestorable(identifier: String) -> Self
    @discardableResult func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self
}

extension StateRestorable {
    @discardableResult public func stateRestorable() -> Self {
        stateRestoration.option = .automatically
        
        return self
    }
    
    @discardableResult public func stateRestorable(identifier: String) -> Self {
        stateRestoration.option = .automaticallyWithIdentifier(restorationIdentifier: identifier)
        
        return self
    }
    
    @discardableResult public func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self {
        stateRestoration.option = .manually(restorationIdentifier: identifier, restorationClass: `class`)
        
        return self
    }

}
