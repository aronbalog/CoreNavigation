import Foundation

extension Navigator {
    static func push<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transitioning.animated

        DispatchQueue.main.async {
            let navigationController = UIViewController.currentViewController?.navigationController
            let completionBlocks = configuration.transitioning.completionBlocks
            
            let item = History.Item(viewController: viewController,
                                    navigationType: .push,
                                    configuration: configuration)
            History.shared.add(item)
            
            navigationController?.pushViewController(viewController, animated: animated, completion: {
                completionBlocks.forEach { $0() }
                completion()
            })
        }
    }
}
