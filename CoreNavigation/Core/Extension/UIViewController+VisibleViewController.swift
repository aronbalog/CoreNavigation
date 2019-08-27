extension UIViewController {
    
    /// Returns the current application's top most view controller.
    public static func visibleViewController(in window: UIWindow?) -> UIViewController? {
        let rootViewController: UIViewController? = window?.rootViewController
        
        return self.visibleViewController(of: rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    class func visibleViewController(of viewController: UIViewController?) -> UIViewController? {
        // UITabBarController
        if
            let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController
        {
            return self.visibleViewController(of: selectedViewController)
        }
        
        // UINavigationController
        if
            let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController
        {
            return self.visibleViewController(of: visibleViewController)
        }
        
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.visibleViewController(of: presentedViewController)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.visibleViewController(of: childViewController)
            }
        }
        
        return viewController
    }
    
}
