import Foundation

/// <#Description#>
public protocol StateRestorable: class {
    /// <#Description#>
    associatedtype StateRestoration: StateRestorationAware
    
    /// <#Description#>
    var stateRestoration: StateRestoration { get set }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    @discardableResult func stateRestorable() -> Self
    
    /// <#Description#>
    ///
    /// - Parameter identifier: <#identifier description#>
    /// - Returns: <#return value description#>
    @discardableResult func stateRestorable(identifier: String) -> Self
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - identifier: <#identifier description#>
    ///   - class: <#class description#>
    /// - Returns: <#return value description#>
    @discardableResult func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self
}

// MARK: - <#Description#>
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
