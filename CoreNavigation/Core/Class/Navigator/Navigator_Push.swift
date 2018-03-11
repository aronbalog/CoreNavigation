import Foundation

extension Navigator {
    static func push<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transition.animated

        DispatchQueue.main.async {
            let navigationController = UIViewController.currentViewController?.navigationController
            let completionBlocks = configuration.transition.completionBlocks
            
            navigationController?.pushViewController(viewController, animated: animated, completion: {
                completionBlocks.forEach { $0() }
                completion()
            })
        }
    }
}
