extension Navigator {
    func pop(
        operation: Navigation.Operation) {
        queue.sync {
            DispatchQueue.main.async {
                let navigationController: UINavigationController? = {
                    return self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
                }()
                navigationController?.popViewController(animated: self.configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(destination: self.configuration.destination, viewController: UIViewController.visibleViewController())
                    self.resultCompletion(with: result, operation: operation)
                })
            }
        }
    }
    func popToRootViewController(
        operation: Navigation.Operation) {
        queue.sync {
            DispatchQueue.main.async {
                let navigationController: UINavigationController? = {
                    return self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
                }()
                navigationController?.popToRootViewController(animated: self.configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(destination: self.configuration.destination, viewController: UIViewController.visibleViewController())
                    self.resultCompletion(with: result, operation: operation)
                })
            }
        }
    }
}
