import UIKit

extension UIViewController {
    
    /// Returns the current application's top most view controller.
    public static func currentViewController(in application: UIApplicationProtocol) -> UIViewController? {
        let rootViewController: UIViewController? = application.keyWindow?.rootViewController
        
        return self.currentViewController(of: rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    class func currentViewController(of viewController: UIViewController?) -> UIViewController? {
        // UITabBarController
        if
            let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController
        {
            return self.currentViewController(of: selectedViewController)
        }
        
        // UINavigationController
        if
            let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController
        {
            return self.currentViewController(of: visibleViewController)
        }
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.currentViewController(of: presentedViewController)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.currentViewController(of: childViewController)
            }
        }
        
        return viewController
    }
    
}
