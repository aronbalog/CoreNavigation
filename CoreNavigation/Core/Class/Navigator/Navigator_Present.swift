extension Navigator {
    func present(
        operation: Navigation.Operation
        ) {
        queue.sync {
            resolve(
                onComplete: { destination, viewController, embeddingViewController in
                    let dataPassingCandidates: [Any?] =
                        self.configuration.protections +
                            [
                                destination,
                                self.configuration.embeddable,
                                viewController,
                                embeddingViewController
                    ]
                    self.passData(self.configuration.dataPassingBlock, to: dataPassingCandidates)
                    let destinationViewController = embeddingViewController ?? viewController
                    let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController)
                    var transitioningDelegate = self.configuration.transitioningDelegateBlock?()
                    DispatchQueue.main.async {
                        destinationViewController.transitioningDelegate = transitioningDelegate
                        self.configuration.sourceViewController.present(destinationViewController, animated: self.configuration.isAnimatedBlock(), completion: {
                            self.resultCompletion(with: result, operation: operation)
                            transitioningDelegate = nil
                        })
                    }
                },
                onCancel: { error in
                    self.resultFailure(with: error, operation: operation)
                }
            )
        }
    }
}
