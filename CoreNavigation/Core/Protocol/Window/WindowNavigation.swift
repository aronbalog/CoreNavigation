import Foundation

protocol WindowNavigation {
    associatedtype WindowObject: WindowNavigationAware
    
    var windowObject: WindowObject { get set }
    
    @discardableResult func inWindow(_ window: UIWindow) -> Self
}

// MARK: - Window configuration
extension Configuration: WindowNavigation {
    /// Sets window to navigate on.
    ///
    /// - Parameter window: `Window` object.
    /// - Returns: `Configuration` instance.
    @discardableResult public func inWindow(_ window: UIWindow) -> Self {
        windowObject.window = window
        
        return self
    }
}
