import Foundation

/// Configuration block
public typealias ConfigurationBlock = (To<Result<UIViewController, Any>>) -> Void

/// Navigation starting point.
public struct Navigation {
    
    /// Navigation history.
    public static var history: History {
        return History.shared
    }
    
    /// Presents view controller with configuration block.
    ///
    /// - Parameter configuration: `Configuration` block which returns object that can be used to configure push navigation.
    /// - Returns: `Navigation` class.
    @discardableResult public static func present(_ configuration: ConfigurationBlock) -> Navigation.Type {
        configuration(To<Result<UIViewController, Any>>(.present))
        
        return self
    }
    
    /// Pushes view controller with configuration block.
    ///
    /// - Parameter configuration: `Configuration` block which returns object that can be used to configure presenting navigation.
    /// - Returns: `Navigation` class.
    @discardableResult public static func push(_ configuration: ConfigurationBlock) -> Navigation.Type {
        configuration(To<Result<UIViewController, Any>>(.push))
        
        return self
    }
}
