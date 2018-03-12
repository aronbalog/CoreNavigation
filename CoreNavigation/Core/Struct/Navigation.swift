import Foundation

public typealias ConfigurationBlock = (To<Result<UIViewController, Any>>) -> Void

public struct Navigation {
    public static var history: History {
        return History.shared
    }
    
    @discardableResult public static func present(_ configuration: ConfigurationBlock) -> Navigation.Type {
        configuration(To<Result<UIViewController, Any>>(.present))
        
        return self
    }
    
    @discardableResult public static func push(_ configuration: ConfigurationBlock) -> Navigation.Type {
        configuration(To<Result<UIViewController, Any>>(.push))
        
        return self
    }
}
