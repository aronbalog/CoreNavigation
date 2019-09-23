extension Navigator {
    func performSegue(
        with segueIdentifier: String,
        operation: Navigation.Operation
        ) {
        let sourceViewController = configuration.sourceViewController
        sourceViewController.coreNavigationEvents = UIViewController.Observer()
        
        sourceViewController.coreNavigationEvents?.onPrepareForSegue({ [unowned self] (segue, sender) in
            self.configuration.prepareForSegueBlock?(segue, sender)
            self.passData(self.configuration.dataPassingBlock, to: [segue.destination])
            
            self.configuration.viewControllerEventBlocks.forEach({ (block) in
                self.bindEvents(to: segue.destination as! DestinationType.ViewControllerType, navigationEvents: block())
            })
            if self.configuration.dataPassingBlock == nil {
                self.prepareForStateRestorationIfNeeded(viewController: segue.destination, viewControllerData: nil)
            }
            
            operation.presentedViewController = segue.destination
            
            let result = self.doOnNavigationSuccess(destination: self.configuration.destination, viewController: segue.destination as! DestinationType.ViewControllerType)
            
            self.resultCompletion(with: result, operation: operation)
        })
        
        func action() {
            sourceViewController.performSegue(withIdentifier: segueIdentifier, sender: sourceViewController)
            sourceViewController.coreNavigationEvents = nil
        }
        
        if let delayBlock = self.configuration.delayBlock {
            let timeInterval = delayBlock()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
        } else {
            DispatchQueue.main.async(execute: action)
        }
    }
}
