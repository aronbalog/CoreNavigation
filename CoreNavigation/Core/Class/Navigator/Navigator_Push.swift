extension Navigator {
    func push<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            resolve(
                with: configuration,
                onComplete: { (destination, viewController, embeddingViewController) in
                    let navigationController: UINavigationController? = {
                        return configuration.sourceViewController.navigationController ?? configuration.sourceViewController as? UINavigationController
                    }()
                    let dataPassingCandidates: [Any?] =
                        configuration.protections +
                            [
                                destination,
                                configuration.embeddable,
                                viewController,
                                embeddingViewController
                    ]
                    self.passData(configuration.dataPassingBlock, to: dataPassingCandidates, configuration: configuration)
                    let destinationViewController = embeddingViewController ?? viewController
                    let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController, configuration: configuration)
                    var transitioningDelegate = configuration.transitioningDelegateBlock?()
                    DispatchQueue.main.async {
                        navigationController?.transitioningDelegate = transitioningDelegate
                        navigationController?.pushViewController(destinationViewController, animated: configuration.isAnimatedBlock(), completion: {
                            self.resultCompletion(with: result, configuration: configuration)
                            transitioningDelegate = nil
                        })
                    }
            },
                onCancel: { (error) in
                    self.resultFailure(with: error, configuration: configuration)
            }
            )
        }
    }
}
