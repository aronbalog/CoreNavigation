import Foundation

extension Navigator {
    static func present<T>(_ viewController: UIViewController, with configuration: Configuration<T>)  {
        let animated = configuration.transition.animated
        
        DispatchQueue.main.async {
            let fromViewController = UIViewController.currentViewController
            let completionBlocks = configuration.transition.completionBlocks

            fromViewController?.present(viewController, animated: animated, completion: {
                completionBlocks.forEach { $0() }
            })
        }
    }
}
