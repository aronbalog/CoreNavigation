import Foundation

extension Navigator {
    static func present<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transition.animated
        
        DispatchQueue.main.async {
            let fromViewController = UIViewController.currentViewController
            let completionBlocks = configuration.transition.completionBlocks

            fromViewController?.present(viewController, animated: animated, completion: {
                completionBlocks.forEach { $0() }
                completion()
            })
        }
    }
}
