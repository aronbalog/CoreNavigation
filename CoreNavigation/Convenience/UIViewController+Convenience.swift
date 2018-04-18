import UIKit

// MARK: - UIViewController routing
public extension UIViewController {
    /// Route to path.
    ///
    /// - Parameters:
    ///   - path: Path to route to.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func route<T: UIViewController>(to path: String, _ viewControllerBlock: @escaping (T) -> Void)  {
        _route(to: path, viewControllerBlock)
    }
    
    /// Route to URL.
    ///
    /// - Parameters:
    ///   - url: URL to route to.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func route<T: UIViewController>(to url: URL, _ viewControllerBlock: @escaping (T) -> Void)  {
        _route(to: url, viewControllerBlock)
    }
    
    /// Route to `Matchable` object.
    ///
    /// - Parameters:
    ///   - matchable: Object conforming `Matchable` protocol.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func route<T: UIViewController>(to matchable: Matchable, _ viewControllerBlock: @escaping (T) -> Void)  {
        _route(to: matchable, viewControllerBlock)
    }
    
    /// Route to `Route` object.
    ///
    /// - Parameters:
    ///   - route: Object conforming `Route` protocol.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func route<T: Route>(to route: T, _ viewControllerBlock: @escaping (T.ViewController) -> Void) {
        route.viewController(viewControllerBlock)
    }
}

// MARK: - UIViewController navigation
public extension UIViewController {
    /// Presents view controller from this view controller.
    ///
    /// - Parameter block: Configuration block.
    /// - Returns: This instance.
    @discardableResult public func present(_ block: (To<Result<UIViewController, Any>>) -> Void) -> Self {
        block(To(.present, from: self))
        
        return self
    }
    
    /// Pushes view controller from this view controller.
    ///
    /// - Parameter block: Configuration block.
    /// - Returns: This instance.
    @discardableResult public func push(_ block: (To<Result<UIViewController, Any>>) -> Void) -> Self {
        block(To(.push, from: self))
        
        return self
    }
}

private func _route<T: UIViewController>(to matchable: Matchable, _ viewControllerBlock: @escaping (T) -> Void)  {
    typealias ToType = To<Result<T, Any>>
    
    ToType.to(matchable: matchable, from: nil) { (configuration) in
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
    }
}
