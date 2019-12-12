extension Navigator {
    func push(operation: Navigation.Operation, destination: DestinationType, viewController: DestinationType.ViewControllerType, embeddingViewController: UIViewController?) {
        DispatchQueue.main.async {
            let navigationController: UINavigationController? = {
                self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
            }()
            let dataPassingCandidates: [Any?] =
                self.configuration.protections +
                    [
                        destination,
                        self.configuration.embeddable,
                        viewController,
                        embeddingViewController
            ]
            self.passData(self.configuration.dataPassingBlock, to: dataPassingCandidates)
            let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController)
            var transitioningDelegate = self.configuration.transitioningDelegateBlock?()
            
            func action() {
                let destinationViewController = embeddingViewController ?? viewController

                let dataManager = UIViewController.DataManager()
                dataManager.blocks.addObjects(from: self.configuration.dataReturningBlocks)
                self.configuration.sourceViewController.coreNavigationDataManager = dataManager
                
                navigationController?.transitioningDelegate = transitioningDelegate
                navigationController?.pushViewController(destinationViewController, animated: self.configuration.isAnimatedBlock(), completion: {
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
        }
    }
}
