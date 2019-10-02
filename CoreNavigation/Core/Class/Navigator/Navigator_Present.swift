extension Navigator {
    func present(
        operation: Navigation.Operation
        ) {
        DispatchQueue.main.async {
            self.resolve(
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
                    
                    func action() {
                        destinationViewController.transitioningDelegate = transitioningDelegate
                        self.configuration.sourceViewController.present(destinationViewController, animated: self.configuration.isAnimatedBlock(), completion: {
                            self.resultCompletion(with: result, operation: operation)
                            transitioningDelegate = nil
                        })
                    }
                    
                    if let delayBlock = self.configuration.delayBlock {
                        let timeInterval = delayBlock()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
                    } else {
                        DispatchQueue.main.async(execute: action)
                    }
                },
                onCancel: { error in
                    self.resultFailure(with: error, operation: operation)
                }
            )
        }
    }
}
