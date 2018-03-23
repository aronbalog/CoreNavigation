import UIKit

extension UIViewController {
    public static func route<T: UIViewController>(to path: String, _ viewControllerBlock: @escaping (T) -> Void)  {
        typealias ToType = To<Result<T, Any>>
        
        ToType.to(matchable: path, from: nil) { (configuration) in
            Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        }
    }
    
    public static func route<T: UIViewController>(to url: URL, _ viewControllerBlock: @escaping (T) -> Void)  {
        typealias ToType = To<Result<T, Any>>
        
        ToType.to(matchable: url, from: nil) { (configuration) in
            Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        }
    }
    
    public static func route<T: UIViewController>(to matchable: Matchable, _ viewControllerBlock: @escaping (T) -> Void)  {
        typealias ToType = To<Result<T, Any>>
        
        ToType.to(matchable: matchable, from: nil) { (configuration) in
            Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        }
    }
    
    public static func route<T: Route>(to route: T, _ viewControllerBlock: @escaping (T.Destination) -> Void) where T.Destination: UIViewController  {
        
        route.viewController(viewControllerBlock)
    }
}
