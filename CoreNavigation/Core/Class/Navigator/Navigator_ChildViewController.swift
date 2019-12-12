extension Navigator {
    func childViewController(operation: Navigation.Operation, destination: DestinationType, viewController: DestinationType.ViewControllerType, embeddingViewController: UIViewController?) {
        DispatchQueue.main.async {
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
            let sourceViewController = self.configuration.sourceViewController
            
            func action() {
                sourceViewController.addChild(destinationViewController)
                destinationViewController.view.frame = sourceViewController.view.bounds
                sourceViewController.view.addSubview(destinationViewController.view)
                destinationViewController.didMove(toParent: sourceViewController)
                self.resultCompletion(with: result, operation: operation)
            }
            
            if let delayBlock = self.configuration.delayBlock {
                let timeInterval = delayBlock()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
            } else {
                DispatchQueue.main.async(execute: action)
            }
        }
    }
}
