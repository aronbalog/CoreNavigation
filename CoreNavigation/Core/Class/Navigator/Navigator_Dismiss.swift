extension Navigator {
    func dismiss(
        operation: Navigation.Operation) {
        queue.sync {
            DispatchQueue.main.async {
                let sourceViewController = self.configuration.sourceViewController as! DestinationType.ViewControllerType

                sourceViewController.dismiss(animated: self.configuration.isAnimatedBlock(), completion: {
                    self.resultCompletion(
                        with: self.doOnNavigationSuccess(
                            destination: self.configuration.destination,
                            viewController: UIViewController.visibleViewController()
                        ),
                        operation: operation
                    )
                })
            }
        }
    }
}
