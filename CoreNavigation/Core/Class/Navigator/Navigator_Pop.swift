extension Navigator {
    func pop<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            DispatchQueue.main.async {
                let navigationController: UINavigationController? = {
                    return configuration.sourceViewController.navigationController ?? configuration.sourceViewController as? UINavigationController
                }()
                navigationController?.popViewController(animated: configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(destination: configuration.destination, viewController: UIViewController.visibleViewController(), configuration: configuration)
                    self.resultCompletion(with: result, configuration: configuration)
                })
            }
        }
    }
    func popToRootViewController<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            DispatchQueue.main.async {
                let navigationController: UINavigationController? = {
                    return configuration.sourceViewController.navigationController ?? configuration.sourceViewController as? UINavigationController
                }()
                navigationController?.popToRootViewController(animated: configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(destination: configuration.destination, viewController: UIViewController.visibleViewController(), configuration: configuration)
                    self.resultCompletion(with: result, configuration: configuration)
                })
            }
        }
    }
}
