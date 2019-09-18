extension Navigator {
    func present<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            resolve(
                with: configuration,
                onComplete: { destination, viewController, embeddingViewController in
                    let dataPassingCandidates: [Any?] =
                        configuration.protections +
                            [
                                destination,
                                configuration.embeddable,
                                viewController,
                                embeddingViewController
                    ]
                    self.passData(configuration.dataPassingBlock, to: dataPassingCandidates)
                    let destinationViewController = embeddingViewController ?? viewController
                    let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController, configuration: configuration)
                    var transitioningDelegate = configuration.transitioningDelegateBlock?()
                    DispatchQueue.main.async {
                        destinationViewController.transitioningDelegate = transitioningDelegate
                        configuration.sourceViewController.present(destinationViewController, animated: configuration.isAnimatedBlock(), completion: {
                            self.resultCompletion(with: result, configuration: configuration)
                            transitioningDelegate = nil
                        })
                    }
                },
                onCancel: { error in
                    self.resultFailure(with: error, configuration: configuration)
                }
            )
        }
    }
}
