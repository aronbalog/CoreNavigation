import UIKit

// MARK: - UIViewController routing
public extension UIViewController {
    /// Resolves view controller from string path.
    ///
    /// - Parameters:
    ///   - path: Path to resolve.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func resolve<T: UIViewController>(_ path: String, _ viewControllerBlock: @escaping (T) -> Void)  {
        _resolve(matchable: path, viewControllerBlock)
    }
    
    /// Resolves view controller from URL.
    ///
    /// - Parameters:
    ///   - url: URL to resolve.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func resolve<T: UIViewController>(_ url: URL, _ viewControllerBlock: @escaping (T) -> Void)  {
        _resolve(matchable: url, viewControllerBlock)
    }
    
    /// Resolves view controller from `Matchable` object.
    ///
    /// - Parameters:
    ///   - matchable: Object conforming `Matchable` protocol.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func resolve<T: UIViewController>(_ matchable: Matchable, _ viewControllerBlock: @escaping (T) -> Void)  {
        _resolve(matchable: matchable, viewControllerBlock)
    }
    
    /// Resolves view controller from `Destination` object.
    ///
    /// - Parameters:
    ///   - destination: Object conforming `Destination` protocol.
    ///   - viewControllerBlock: Block returning UIViewController instance.
    public static func resolve<T: Destination>(_ destination: T, _ viewControllerBlock: @escaping (T.ViewControllerType) -> Void) {
        destination.viewController(viewControllerBlock)
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

private func _resolve<T: UIViewController>(matchable: Matchable, _ viewControllerBlock: @escaping (T) -> Void)  {
    typealias ToType = To<Result<T, Any>>
    
    ToType.to(matchable: matchable, from: nil) { (configuration) in
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
    }
}
