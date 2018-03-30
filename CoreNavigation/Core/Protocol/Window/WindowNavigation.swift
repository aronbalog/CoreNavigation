import Foundation

protocol WindowNavigation {
    associatedtype WindowObject: WindowNavigationAware
    
    var windowObject: WindowObject { get set }
    
    @discardableResult func inWindow(_ window: UIWindow) -> Self
}

extension Configuration: WindowNavigation {
    @discardableResult public func inWindow(_ window: UIWindow) -> Self {
        windowObject.window = window
        
        return self
    }
}
