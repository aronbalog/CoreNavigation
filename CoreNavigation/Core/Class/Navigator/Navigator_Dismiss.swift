extension Navigator {
    func dismiss<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            DispatchQueue.main.async {
                let sourceViewController = configuration.sourceViewController as! DestinationType.ViewControllerType

                sourceViewController.dismiss(animated: configuration.isAnimatedBlock(), completion: {
                    self.resultCompletion(
                        with: self.doOnNavigationSuccess(
                            destination: configuration.destination,
                            viewController: UIViewController.visibleViewController(),
                            configuration: configuration
                        ),
                        configuration: configuration
                    )
                })
            }
        }
    }
}
